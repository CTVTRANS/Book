//
//  NotificationMessageViewController.swift
//  BookApp
//
//  Created by kien le van on 9/4/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class NotificationMessageViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    private var listNotification: [NotificationApp] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.tableFooterView = UIView()
        table.estimatedRowHeight = 140
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "通知列表"
        navigationController?.isNavigationBarHidden = false
    }
    
    func getData() {
        let getData = GetNotificationTask(limit: 1000, page: 1, memberID: (memberInstance?.idMember)!)
        requestWithTask(task: getData, success: { (data) in
            if let array = data as? (Int, [NotificationApp]) {
                UserDefaults.standard.set(array.0, forKey: "numberNotice")
                self.listNotification = array.1
                self.table.reloadData()
            }
        }) { (_) in
            
        }
    }
    
    // MARK: Table Data Source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = table.dequeueReusableCell(withIdentifier: "MessageNotificationCell", for: indexPath) as? MessageNotificationCell {
            cell.binData(objectNotification: listNotification[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: Table Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailNotificationMessageController") as? DetailNotificationMessageController {
            vc.objectiNotification = listNotification[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let removeNotice = RemoveNoticeTask(memberID: (memberInstance?.idMember)!, noticeID: listNotification[indexPath.row].idNotification, token: tokenInstance!)
            requestWithTask(task: removeNotice, success: { (_) in
                
            }, failure: { (_) in
                
            })
            listNotification.remove(at: indexPath.row)
            table.reloadData()
        }
    }

    func notPrettyString(from object: Any) -> String? {
        if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted) {
            let objectString = String(data: objectData, encoding: .utf8)
            return objectString
        }
        return nil
    }
    
    @IBAction func pressedReadAllMessage(_ sender: Any) {
        var arrayListIdGroup: [Int] = []
        for notice in listNotification {
            arrayListIdGroup.append(notice.idNotification)
        }
        let jsonObject: String = notPrettyString(from: arrayListIdGroup)!
        let sendMarked = MarkRaededNotification(memberID: (memberInstance?.idMember)!, arrayID: jsonObject, token: tokenInstance!)
        requestWithTask(task: sendMarked, success: { (_) in
            
        }) { (_) in
            
        }

        table.reloadData()
    }
    
    @IBAction func pressedBackButton(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        _ = self.navigationController?.popToRootViewController(animated: false)
    }
}
