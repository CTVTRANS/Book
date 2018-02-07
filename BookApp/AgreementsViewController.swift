//
//  AgreementsViewController.swift
//  BookApp
//
//  Created by kien le van on 10/24/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class AgreementsViewController: BaseViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivity(inView: self.view)
        webView.delegate = self
        let termOfUse = DefaultApp.sharedInstance.termOffUse
        webView.loadHTMLString(termOfUse, baseURL: nil)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        stopActivityIndicator()
    }

}
