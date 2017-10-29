//
//  ChanelHotController.swift
//  BookApp
//
//  Created by kien le van on 9/6/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class ChanelHotController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    var listChanelHot = [Chanel]()
    private let listChanelSubcribled = Constants.sharedInstance.listChanelSubcribled
    private var isLoading = false
    private var isMoreData = true
    private var pager = 1
    lazy var footerView = UIView.initFooterView()
    private var indicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.estimatedRowHeight = 140
        table.tableFooterView = UIView()
        showActivity(inView: self.view)
        table.register(UINib.init(nibName: "ChanelViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        if let ac = footerView.viewWithTag(8) as? UIActivityIndicatorView {
            indicator = ac
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        listChanelHot.removeAll()
        pager = 1
        loadMore()
    }
    
    // MARK: Table Data Source
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listChanelHot.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ChanelViewCell
        let chanel = listChanelHot[indexPath.row]
        cell?.binData(chanel: chanel)
        for chanelHot in Constants.sharedInstance.listChanelSubcribled {
            if chanel.idChanel ==  chanelHot.idChanel {
                cell?.subcribleButton.setTitle("  已订阅频道  ", for: .normal)
                cell?.subcribleButton.isEnabled = false
                break
            } else {
                 cell?.subcribleButton.setTitle("  订阅频道  ", for: .normal)
            }
        }
        cell?.callBackButton = { [weak self] in
            let subcrible: SubcribleChanelTask =
                SubcribleChanelTask(memberID: (self!.memberInstance?.idMember)!,
                                    chanelID: chanel.idChanel,
                                    token: (self?.tokenInstance)!)
            self?.requestWithTask(task: subcrible, success: { [weak self] (data) in
                let status: Subcrible = (data as? Subcrible)!
                if status == Subcrible.subcrible {
                    if !(self?.checkLogin())! {
                        self?.goToSigIn()
                        return
                    }
                    Constants.sharedInstance.listChanelSubcribled.append(chanel)
                    cell?.subcribleButton.setTitle("  已订阅频道  ", for: .normal)
                    cell?.subcribleButton.isEnabled = false
                }
            }) { (error) in
                _ = UIAlertController(title: nil,
                                      message: error as? String,
                                      preferredStyle: .alert)
            }
        }
        return cell!
    }
    
    // MARK: Table Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        let detailTeacherVC = storyboard!.instantiateViewController(withIdentifier: "DetailChanelViewController") as? DetailChanelViewController
        detailTeacherVC?.chanel = listChanelHot[indexPath.row]
        self.navigationController?.pushViewController(detailTeacherVC!, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let endOftable = table.contentOffset.y >= (table.contentSize.height - table.frame.size.height)
        if isMoreData && endOftable && !isLoading && !scrollView.isDragging && !scrollView.isDecelerating {
            isLoading = true
            table.tableFooterView = footerView
            indicator?.startAnimating()
            loadMore()
        }
    }
    
    func loadMore() {
        let getHotChanel: GetHotChanelTask = GetHotChanelTask(page: pager)
        requestWithTask(task: getHotChanel, success: { (data) in
            if let list = data as? [Chanel] {
                self.listChanelHot += list
                self.stopActivityIndicator()
                self.isLoading = false
                self.pager += 1
                self.indicator?.stopAnimating()
                
                self.table.reloadData()
                if list.count == 0 {
                    self.isMoreData = false
                }
            }
        }) { (error) in
            self.stopActivityIndicator()
            _ = UIAlertController(title: nil, message: error as? String, preferredStyle: .alert)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
