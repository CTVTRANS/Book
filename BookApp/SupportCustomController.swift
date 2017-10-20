//
//  SupportCustomController.swift
//  BookApp
//
//  Created by kien le van on 10/14/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class SupportCustomController: BaseViewController, UIWebViewDelegate {

    @IBOutlet weak var bodyWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivity(inView: self.view)
        bodyWebView.delegate = self
        bodyWebView.loadHTMLString(DefaultApp.sharedInstance.suporter, baseURL: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "幫助中心"
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        stopActivityIndicator()
    }
}
