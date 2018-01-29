//
//  ShareController.swift
//  BookApp
//
//  Created by kien le van on 9/21/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import Social

class ShareController: BaseViewController {

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func pressedShareWeibo() {
        let textToShare = ShareModel.shareIntance.nameShare + "\n" + ShareModel.shareIntance.detailShare
        if let myWebsite = NSURL(string: ShareModel.shareIntance.linkDownApp) {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.postToFacebook,
                                                UIActivityType.postToTwitter,
                                                UIActivityType.postToVimeo,
                                                UIActivityType.print,
                                                UIActivityType.airDrop,
                                                UIActivityType.copyToPasteboard,
                                                UIActivityType.assignToContact,
                                                UIActivityType.saveToCameraRoll,
                                                UIActivityType.addToReadingList,
                                                UIActivityType.postToFlickr,
                                                UIActivityType.mail,
                                                UIActivityType.message
            ]
            activityVC.completionWithItemsHandler = { (activity, success, items, error) in
                if success {
                    self.upDatePointBase(type: UpdatePointType.share.rawValue)
                }
            }
            
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func pressedShareWechat() {
        let textToShare = ShareModel.shareIntance.nameShare + "\n" + ShareModel.shareIntance.detailShare
        if let myWebsite = NSURL(string: ShareModel.shareIntance.linkDownApp) {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.postToFacebook,
                                                UIActivityType.postToTwitter,
                                                UIActivityType.postToVimeo,
                                                UIActivityType.postToTencentWeibo,
                                                UIActivityType.print,
                                                UIActivityType.airDrop,
                                                UIActivityType.copyToPasteboard,
                                                UIActivityType.assignToContact,
                                                UIActivityType.saveToCameraRoll,
                                                UIActivityType.addToReadingList,
                                                UIActivityType.postToFlickr,
                                                UIActivityType.mail,
                                                UIActivityType.postToWeibo,
                                                UIActivityType.message
                                                ]
            activityVC.completionWithItemsHandler = { (activity, success, items, error) in
                if success {
                    self.upDatePointBase(type: UpdatePointType.share.rawValue)
                }
            }
            
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func pressedShareFacebook() {
        let textToShare = ShareModel.shareIntance.nameShare + "\n" + ShareModel.shareIntance.detailShare
        if let myWebsite = NSURL(string: ShareModel.shareIntance.linkDownApp) {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.postToTwitter,
                                                UIActivityType.postToVimeo,
                                                UIActivityType.postToTencentWeibo,
                                                UIActivityType.print,
                                                UIActivityType.airDrop,
                                                UIActivityType.copyToPasteboard,
                                                UIActivityType.assignToContact,
                                                UIActivityType.saveToCameraRoll,
                                                UIActivityType.addToReadingList,
                                                UIActivityType.postToFlickr,
                                                UIActivityType.mail,
                                                UIActivityType.postToWeibo,
                                                UIActivityType.message
            ]
            activityVC.completionWithItemsHandler = { (activity, success, items, error) in
                if success {
                    self.upDatePointBase(type: UpdatePointType.share.rawValue)
                }
            }
            
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}

extension ShareController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ShareViewCell
        switch indexPath.row {
        case 0:
            cell?.imageShare.image = #imageLiteral(resourceName: "ic_share_weibo")
        case 1:
            cell?.imageShare.image = #imageLiteral(resourceName: "ic_share_wechat")
        case 2:
            cell?.imageShare.image = #imageLiteral(resourceName: "ic_share_facebook")
        default:
            break
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        if !checkLogin() {
            self.revealViewController().revealToggle(animated: true)
            goToSigIn()
            return
        }
        self.revealViewController().revealToggle(animated: true)
        switch indexPath.row {
        case 0:
            pressedShareWeibo()
        case 1:
            pressedShareWechat()
        case 2:
            pressedShareFacebook()
        default:
            break
        }
    }
}
