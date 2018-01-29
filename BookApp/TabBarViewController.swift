//
//  TabBarViewController.swift
//  BookApp
//
//  Created by kien le van on 10/19/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    let statusView = CustomStatusBarView()

    override func viewDidLoad() {
        super.viewDidLoad()
//        selectedIndex = 1
        statusView.frame = CGRect(x: 0, y: -20, width: widthScreen, height: 20)
        statusView.setupUI()
        UIApplication.shared.statusBarView?.addSubview(statusView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showDownloadSuccess), name: Notification.Name(rawValue: "downloadSuccess"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showDownloadPrecess), name: Notification.Name(rawValue: "downloadStart"), object: nil)
        if Constants.sharedInstance.language == 1 {
            tabBar.items![0].image = #imageLiteral(resourceName: "tradition_news")
            tabBar.items![0].selectedImage = #imageLiteral(resourceName: "tradition_news")
            tabBar.items![1].image = #imageLiteral(resourceName: "tradition_book")
            tabBar.items![1].selectedImage = #imageLiteral(resourceName: "tradition_book")
            tabBar.items![2].image = #imageLiteral(resourceName: "tradition_teacher")
            tabBar.items![2].selectedImage = #imageLiteral(resourceName: "tradition_teacher")
            tabBar.items![3].image = #imageLiteral(resourceName: "traditon_member")
            tabBar.items![3].selectedImage = #imageLiteral(resourceName: "traditon_member")
        }
    }

    @objc func showDownloadSuccess() {
        statusView.imageView?.image = #imageLiteral(resourceName: "ic_download_success")
        statusView.statusLabel.text = "Download success".localized
        UIView.animate(withDuration: 0.5, animations: {
            self.statusView.frame = CGRect(x: 0, y: 0, width: widthScreen, height: 20)
        }) { (_) in
            _ = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.hideenStatusBar), userInfo: nil, repeats: false)
            
        }
    }
    
   @objc func showDownloadPrecess() {
        statusView.imageView?.image = #imageLiteral(resourceName: "ic_download_process")
        statusView.statusLabel.text = "Start Download...".localized
        UIView.animate(withDuration: 0.5, animations: {
            self.statusView.frame = CGRect(x: 0, y: 0, width: widthScreen, height: 20)
        }) { (_) in
            _ = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(self.hideenStatusBar), userInfo: nil, repeats: false)
            
        }
    }
    
    @objc func hideenStatusBar () {
        UIView.animate(withDuration: 0.5, animations: {
            self.statusView.frame = CGRect(x: 0, y: -20, width: widthScreen, height: 20)
        }) { (_) in
            
        }
    }
    
}

extension UIApplication {
    
    /// Returns the status bar UIView
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
