//
//  BookTextController.swift
//  BookApp
//
//  Created by kien le van on 8/21/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class BookTextController: BaseViewController, UIWebViewDelegate {
    
    @IBOutlet weak var hightOfWebView: NSLayoutConstraint!
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var scroll: UIScrollView!
    var book: Book?
    var content: String!
    
    @IBOutlet weak var textDetailButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivity(inView: UIApplication.shared.keyWindow!)
        textDetailButton.layer.borderColor = UIColor.rgb(255, 102, 0).cgColor
        if memberInstance == nil || memberInstance?.level == 0 {
            content = css + limitText()
        } else {
            content = css + (book?.content)!
        }
        webview.loadHTMLString(content, baseURL: nil)
        webview.delegate = self
        webview.scrollView.isScrollEnabled = false
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let hightNewOfWebView = webview.scrollView.contentSize.height
        hightOfWebView.constant = hightNewOfWebView
        stopActivityIndicator()
    }
    
    @IBAction func pressedBuy(_ sender: Any) {
        let myStoryBoard = UIStoryboard(name: "Setting", bundle: nil)
        if let vc = myStoryBoard.instantiateViewController(withIdentifier: "BuyProductViewController") as? BuyProductViewController {
            vc.product = book
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func limitText() -> String {
        if let content = book?.content {
            let limit = DefaultApp.sharedInstance.limitWord
            if content.characters.count < limit! + 100 {
                return content
            }
            let index = content.index(content.startIndex, offsetBy: limit! + 100)
            let newContent = content.substring(to: index)
            return newContent
        }
        return " "
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
