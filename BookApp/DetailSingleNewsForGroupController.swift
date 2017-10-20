//
//  DetailSingleNewsForGroupController.swift
//  BookApp
//
//  Created by kien le van on 10/11/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class DetailSingleNewsForGroupController: BaseViewController, UIWebViewDelegate {
    
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var imageGroup: UIImageView!
    @IBOutlet weak var nameGroup: UILabel!
    @IBOutlet weak var idWeChat: UILabel!
    @IBOutlet weak var adress: UILabel!
    @IBOutlet weak var heightOfImage: NSLayoutConstraint!
    
    @IBOutlet weak var titleNews: UILabel!
    @IBOutlet weak var timeNews: UILabel!
    @IBOutlet weak var detailNews: UILabel!
    @IBOutlet weak var imageNews: UIImageView!
    
    @IBOutlet weak var heightOfWebView: NSLayoutConstraint!
    @IBOutlet weak var bodyWebView: UIWebView!
    var news: NewsInGroups?

    override func viewDidLoad() {
        showActivity(inView: self.view)
        let groupOwner = news?.groupOwner
        super.viewDidLoad()
        imageGroup.sd_setImage(with: URL(string: (groupOwner?.imageURL)!), placeholderImage: #imageLiteral(resourceName: "place_holder"))
        imageGroup.layer.cornerRadius = heightOfImage.constant / 2
        nameGroup.text = groupOwner?.name
        idWeChat.text = groupOwner?.idWechat
        adress.text = groupOwner?.adress
        if (news?.groupOwner.isSubcrible)! {
            joinButton.setTitle("subcribled", for: .normal)
        }
        
        titleNews.text = news?.title
        detailNews.text = news?.desciptionNews
        timeNews.text = news?.time.components(separatedBy: " ")[0]
        imageNews.sd_setImage(with: URL(string:(news?.imageURL)!), placeholderImage: #imageLiteral(resourceName: "place_holder"))
        
        bodyWebView.delegate = self
        bodyWebView.loadHTMLString((news?.content)!, baseURL: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let heightNew: CGFloat = bodyWebView.scrollView.contentSize.height
        heightOfWebView.constant = heightNew
        stopActivityIndicator()
    }
    
    @IBAction func pressedJoinButton(_ sender: Any) {
        if !checkLogin() {
            goToSigIn()
            return
        }
        
        let subcrible = SubcribleOneGroupTask(memberID: (memberInstance?.idMember)!, groupID: (news?.groupOwner.idGroup)!, token: tokenInstance!)
        requestWithTask(task: subcrible, success: { (data) in
            if let status = data as? Bool {
                if status {
                    self.joinButton.setTitle("subcribled", for: .normal)
                    self.news?.groupOwner.isSubcrible = true
                } else {
                    self.joinButton.setTitle("   關注   ", for: .normal)
                    self.news?.groupOwner.isSubcrible = false
                }
            }
        }) { (_) in
            
        }
    }
}
