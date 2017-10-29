//
//  CustomVideoViewController.swift
//  testAVPlayerVideo
//
//  Created by kien le van on 10/14/17.
//  Copyright © 2017 kien le van. All rights reserved.
//

import UIKit

class CustomVideoViewController: UIViewController {
   
    var full = false
    var videoLink: String?
    
    var showFrullCcreen = {}
    var showMinizomScreene = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func show() {
        let videoPlayer = VideoPlayerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        videoPlayer.videoURL = videoLink!
        videoPlayer.setupUI()
        self.view.addSubview(videoPlayer)
        videoPlayer.callBack = { [weak self] in
            if !(self?.full)! {
                videoPlayer.frame = CGRect(x: 0, y: 0, width: widthScreen, height: hightScreen)
                self?.showFrullCcreen()
            } else {
                self?.dismiss(animated: false, completion: nil)
                self?.showMinizomScreene()
            }
            self?.full = !(self?.full)!
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
