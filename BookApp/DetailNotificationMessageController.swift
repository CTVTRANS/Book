//
//  DetailNotificationMessageController.swift
//  BookApp
//
//  Created by kien le van on 9/4/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import SWRevealViewController

class DetailNotificationMessageController: BaseViewController {

    @IBOutlet weak var detal: UILabel!
    var objectiNotification: NotificationApp?
//    var indexobjec: Int
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !(objectiNotification?.isReaded)! {
             markedNotification()
        }
        navigationItem.title = "通知列表"
        detal.text = objectiNotification?.detailText
        ShareModel.shareIntance.nameShare = (objectiNotification?.title)!
        ShareModel.shareIntance.detailShare = (objectiNotification?.detailText)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        if self.revealViewController() != nil {
            revealViewController().rightViewRevealWidth = 80
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_share_rightBar"), style: .plain, target: self.revealViewController(), action: #selector(revealViewController().rightRevealToggle(_:)))
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        setupRightSlideOut()
    }
    
    func notPrettyString(from object: Any) -> String? {
        if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted) {
            let objectString = String(data: objectData, encoding: .utf8)
            return objectString
        }
        return nil
    }
    
    func markedNotification() {
        var arrayListIdGroup: [Int] = []
        arrayListIdGroup.append((objectiNotification?.idNotification)!)
        let jsonObject: String = notPrettyString(from: arrayListIdGroup)!
        let sendMarked = MarkRaededNotification(memberID: (memberInstance?.idMember)!, arrayID: jsonObject, token: tokenInstance!)
        requestWithTask(task: sendMarked, success: { (_) in
            //
            // decride number bage -= 1
        }) { (_) in
            
        }
    }
}
