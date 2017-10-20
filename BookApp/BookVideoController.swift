//
//  BookVideoController.swift
//  BookApp
//
//  Created by kien le van on 8/21/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer

class BookVideoController: BaseViewController, UIWebViewDelegate, AVPlayerViewControllerDelegate {
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var web: UIWebView!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var hightOfWebView: NSLayoutConstraint!
    
    @IBOutlet weak var videoDetailButton: UIButton!
    var loadedVideo: Bool = false
    var loadedWebView: Bool = false
    var book: Book?
    
    let video = CustomVideoViewController()
    var callBackFullScreen = {}
    var full = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivity(inView: UIApplication.shared.keyWindow!)
        videoDetailButton.layer.borderColor = UIColor.rgb(255, 101, 0).cgColor
        web.delegate = self
        let content = css + (book?.descriptionBook)!
        web.loadHTMLString(content, baseURL: nil)
        web.scrollView.isScrollEnabled = false
        
        video.view.frame = CGRect(x: 0, y: 0, width: widthScreen, height: widthScreen * 9/16)
        headerView.addSubview(video.view)
        video.videoLink = book?.video
        video.show()
        
        video.showMinizomScreene = {
            self.video.view.removeFromSuperview()
            self.callBackFullScreen()
            self.video.view.frame = CGRect(x: 0, y: 0, width: widthScreen, height: widthScreen * 9/16)
            self.headerView.addSubview(self.video.view)
        }
        video.showFrullCcreen = {
            self.callBackFullScreen()
            self.video.view.removeFromSuperview()
            if let window = UIApplication.shared.keyWindow {
                self.video.view.frame = CGRect(x: 0, y: 0, width: widthScreen, height: hightScreen)
                window.addSubview( self.video.view)
            }
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let hightOfContenWebView: CGFloat = web.scrollView.contentSize.height
        hightOfWebView.constant = hightOfContenWebView
        print(web.frame.size.height)
        self.loadedWebView = true
        self.stopActivityIndicator()
    }
    
    // Button Controll
    
    @IBAction func pressedBuy(_ sender: Any) {
        let myStoryBoard = UIStoryboard(name: "Setting", bundle: nil)
        if let vc = myStoryBoard.instantiateViewController(withIdentifier: "BuyProductViewController") as? BuyProductViewController {
            vc.product = book
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
