//
//  TeacherSubscribeController.swift
//  BookApp
//
//  Created by kien le van on 8/14/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class ChanelSubscribeController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    private var listChanelSubcribled = [Chanel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.estimatedRowHeight = 140
        table.register(UINib.init(nibName: "ChanelViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        table.tableFooterView = UIView()
        showActivity(inView: self.view)
        let getChaelSubcrible: GetAllChanelSubcribledTask = GetAllChanelSubcribledTask(memberID: (memberInstance?.idMember)!)
        requestWithTask(task: getChaelSubcrible, success: { (_) in
            self.listChanelSubcribled = Constants.sharedInstance.listChanelSubcribled
            self.table.reloadData()
            self.stopActivityIndicator()
        }) { (error) in
            self.stopActivityIndicator()
            _ = UIAlertController(title: nil, message: error as? String, preferredStyle: .alert)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: Table Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listChanelSubcribled.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ChanelViewCell
        cell?.binData(chanel: listChanelSubcribled[indexPath.row])
        cell?.subcribleButton.setTitle("  退订  ", for: .normal)
        cell?.callBackButton = {
            let unSubcrible: SubcribleChanelTask =
                SubcribleChanelTask(memberID: (self.memberInstance?.idMember)!,
                                    chanelID: self.listChanelSubcribled[indexPath.row].idChanel,
                                    token: self.tokenInstance!)
            self.requestWithTask(task: unSubcrible, success: { (data) in
                let status: Subcrible = (data as? Subcrible)!
                if status == Subcrible.unSubcrible {
                    self.listChanelSubcribled.remove(at: indexPath.row)
                    Constants.sharedInstance.listChanelSubcribled = self.listChanelSubcribled
                    self.table.reloadData()
                }
            }) { (error) in
                _ = UIAlertController(title: nil,
                                      message: error as? String,
                                      preferredStyle: .alert)
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: Table Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        let detailTeacherVC = storyboard!.instantiateViewController(withIdentifier: "DetailChanelViewController") as? DetailChanelViewController
        detailTeacherVC?.chanel = listChanelSubcribled[indexPath.row]
        self.navigationController?.pushViewController(detailTeacherVC!, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
