//
//  ShareController.swift
//  BookApp
//
//  Created by kien le van on 9/21/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import Social

class ShareController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

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
    
    func pressedShareWeibo() {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeSinaWeibo) {
            let vc = SLComposeViewController(forServiceType: SLServiceTypeSinaWeibo)
            vc?.setInitialText(ShareModel.shareIntance.nameShare + "\n" + ShareModel.shareIntance.detailShare)
            vc?.add(URL(string: ShareModel.shareIntance.linkDownApp))
            vc?.popoverPresentationController?.sourceView = self.view
            vc?.completionHandler = { status in
                switch status {
                case SLComposeViewControllerResult.done:
                    self.upDatePointBase(type: UpdatePointType.share.rawValue)
                case SLComposeViewControllerResult.cancelled:
                    break
                }
            }
            self.present(vc!, animated: true, completion: nil)
        } else {
            _ = UIAlertController(title: "waring", message: "please install weibo and sigin weibo for share", preferredStyle: .alert)
        }
    }
    
    func pressedShareWechat() {
//        let message = SendMessageToWXReq()
//        message.text = "Hello WeChat"
//        message.bText = true
//        message.scene = 1
//        WXApi.send(message)
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
                                                UIActivityType.postToWeibo
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
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            vc?.add(URL(string: ShareModel.shareIntance.linkDownApp))
            vc?.setInitialText(ShareModel.shareIntance.nameShare + "\n" + ShareModel.shareIntance.detailShare)
            vc?.popoverPresentationController?.sourceView = self.view
            vc?.completionHandler = { status in
                switch status {
                case SLComposeViewControllerResult.done:
                    self.upDatePointBase(type: UpdatePointType.share.rawValue)
                case SLComposeViewControllerResult.cancelled:
                    break
                }
            }
            self.present(vc!, animated: true, completion: nil)
        }
    }
}
