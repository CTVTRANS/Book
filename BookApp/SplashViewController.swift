//
//  SplashViewController.swift
//  BookApp
//
//  Created by kien le van on 8/29/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import SWRevealViewController

class SplashViewController: BaseViewController {

    @IBOutlet weak var traditionalButton: UIButton!
    @IBOutlet weak var simpleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        traditionalButton.layer.borderColor = UIColor.rgb(113, 112, 110).cgColor
        simpleButton.layer.borderColor = UIColor.rgb(113, 112, 110).cgColor

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let getDefault = GetDefaultSettingTask()
        getDefault.request(blockSucess: { (_) in
            
        }) { (_) in
            
        }
        if checkLogin() {
            let updateInfo = GetProfileMemberTask(idMember: (self.memberInstance?.idMember)!)
            updateInfo.request(blockSucess: { (_) in
                
            }, andBlockFailure: { (_) in
                
            })
        }

    }
    
    @IBAction func pressedTraditionnal(_ sender: Any) {
        Constants.sharedInstance.language = 1
        let getData = GetNotificationTask(limit: 1000, page: 1, memberID: (memberInstance?.idMember)!)
        requestWithTask(task: getData, success: { (data) in
            if let arrayNotice = data as? (Int, [NotificationApp]) {
                let numberNotice = UserDefaults.standard.integer(forKey: "numberNotice")
                if arrayNotice.0 > numberNotice {
                    Constants.sharedInstance.hasNotification = true
                    let notificationName = Notification.Name("reciveNotificaton")
                    NotificationCenter.default.post(name: notificationName, object: nil)
                }
            }
        }) { (_) in
            
        }
        
        let sendToken = SendTokenTask()
        requestWithTask(task: sendToken, success: { (_) in
            
        }) { (_) in
            
        }
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController {
            self.present(vc, animated: false, completion: nil)
        }
    }

    @IBAction func pressSimple(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController {
            Constants.sharedInstance.language = 0
            self.present(vc, animated: false, completion: nil)
        }
    }
}
