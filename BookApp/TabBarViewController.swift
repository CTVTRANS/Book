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
    }

    @objc func showDownloadSuccess() {
        statusView.imageView?.image = #imageLiteral(resourceName: "ic_download_success")
        statusView.statusLabel.text = "下載成功"
        UIView.animate(withDuration: 0.5, animations: {
            self.statusView.frame = CGRect(x: 0, y: 0, width: widthScreen, height: 20)
        }) { (_) in
            _ = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.hideenStatusBar), userInfo: nil, repeats: false)
            
        }
    }
    
   @objc func showDownloadPrecess() {
        statusView.imageView?.image = #imageLiteral(resourceName: "ic_download_process")
        statusView.statusLabel.text = "開始下載...."
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
