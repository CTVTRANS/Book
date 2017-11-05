//
//  VideoLaunhcer.swift
//  testAVPlayerVideo
//
//  Created by kien le van on 10/14/17.
//  Copyright © 2017 kien le van. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    var videoURL: String?
    var callBack = {}
    private var isdragSlider = false
    private var timer: Timer?
    private var showFullScreen = false
    private var player: AVPlayer?
    private var playerlayer: AVPlayerLayer?
    private var currentTime: Float?
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    private lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "audio_play"), for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(#imageLiteral(resourceName: "video_next"), for:  UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
         button.addTarget(self, action: #selector(nextTime), for: .touchUpInside)
        return button
    }()
    
    private lazy var previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(#imageLiteral(resourceName: "video_previous"), for:  UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(previousTime), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePause() {
        timer?.invalidate()
        timer = nil
        if player?.rate == 1 {
            controlsContainerView.isHidden = false
            player?.pause()
            pausePlayButton.setImage(#imageLiteral(resourceName: "audio_play"), for: UIControlState())
        } else {
            player?.play()
            pausePlayButton.setImage(#imageLiteral(resourceName: "audio_pause"), for: UIControlState())
            let notificationName = Notification.Name("videoDidStart")
            NotificationCenter.default.post(name: notificationName, object: nil)
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(hiddenControll), userInfo: nil, repeats: false)
        }
    }
    
    @objc func nextTime() {
        let seconds: Int64 = Int64(currentTime!)
        let targetTime: CMTime = CMTimeMake(seconds + 15, 1)
        player?.seek(to: targetTime)
    }
    
    @objc func previousTime() {
        let seconds: Int64 = Int64(currentTime!)
        let targetTime: CMTime = CMTimeMake(seconds - 15, 1)
        player?.seek(to: targetTime)
    }
    
    private lazy var fullScreenButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setImage(#imageLiteral(resourceName: "full_screen"), for: UIControlState.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(fullSCreenTap), for: .touchUpInside)
        return button
    }()
    
    @objc func fullSCreenTap() {
        self.callBack()
        if !showFullScreen {
            controlsContainerView.goFullscreen()
            playerlayer?.goFullscreen()
            _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(hiddenControll), userInfo: nil, repeats: false)
            fullScreenButton.setImage(#imageLiteral(resourceName: "zoomin_screen"), for: .normal)
        } else {
            self.minimizeToFrame()
            playerlayer?.minimizeToFrame()
            controlsContainerView.minimizeToFrame()
            fullScreenButton.setImage(#imageLiteral(resourceName: "full_screen"), for: .normal)
        }
        showFullScreen = !showFullScreen
    }
    
    private let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    private let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    private let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    private lazy var videoSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = UIColor.init(red: 255/255.0, green: 102/255.0, blue: 0.0, alpha: 1)
        slider.maximumTrackTintColor = .white
        slider.setThumbImage(#imageLiteral(resourceName: "thumb"), for: UIControlState())
        slider.addTarget(self, action: #selector(handleSliderChange(slider:event:)), for: .valueChanged)
        return slider
    }()
    
    @objc func handleSliderChange(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began: isdragSlider = true
                break
            case .moved: break
            case .ended: isdragSlider = false
                break
            default:
                break
            }
        }
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(videoSlider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player?.seek(to: seekTime, completionHandler: { (_) in
            })
        }
    }
    
    private func setupPlayerView() {
        let urlString = videoURL!
        if let url = URL(string: urlString) {
            player = AVPlayer(url: url)
            playerlayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerlayer!)
            playerlayer?.frame = self.frame
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
                
                let seconds = CMTimeGetSeconds(progressTime)
                self.currentTime = Float(seconds)
                if ProfileMember.getToken() == "" || ProfileMember.getProfile()?.level == 0 {
                    if seconds > Double(DefaultApp.sharedInstance.limitVideo) {
                        self.player?.pause()
                        self.player?.seek(to: kCMTimeZero)
                        self.videoSlider.value = 0.0
                        self.pausePlayButton.setImage(#imageLiteral(resourceName: "audio_play"), for: UIControlState())
                    }
                }
                let secondsString = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
                let minutesString = String(format: "%02d", Int(seconds / 60))
                self.currentTimeLabel.text = "\(minutesString):\(secondsString)"
                if let duration = self.player?.currentItem?.duration {
                    if !self.isdragSlider {
                        let durationSeconds = CMTimeGetSeconds(duration)
                        self.videoSlider.value = Float(seconds / durationSeconds)
                    }
                }
            })
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        
        //this is when the player is ready and rendering frames
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = .clear
            pausePlayButton.isHidden = false
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                let secondsText = Int(seconds) % 60
                let minutesText = String(format: "%02d", Int(seconds) / 60)
                videoLengthLabel.text = "\(minutesText):\(secondsText)"
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        setupPlayerView()
        tapVideo()
        controlsContainerView.backgroundColor = UIColor.clear
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        
        controlsContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.addConstraintCenter(to: controlsContainerView, x: 0, y: 0)
        
        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.addConstraintCenter(to: controlsContainerView, x: 0, y: 0)
        pausePlayButton.addConstraintBound(withHeight: 80, withWidth: 80)
        
        controlsContainerView.addSubview(nextButton)
        nextButton.addConstraintCenter(to: controlsContainerView, x: 80, y: 0)
        
        controlsContainerView.addSubview(previousButton)
        previousButton.addConstraintCenter(to: controlsContainerView, x: -80, y: 0)
        
        controlsContainerView.addSubview(fullScreenButton)
        fullScreenButton.addConstraintBound(withHeight: 22, withWidth: 22)
        fullScreenButton.addContrainRight(to: controlsContainerView, withRight: -8)
        fullScreenButton.addConstraintBottom(to: controlsContainerView, withBottom: -4)
        
        controlsContainerView.addSubview(videoLengthLabel)
        videoLengthLabel.addContrainRight(to: fullScreenButton, withRight: -20)
        videoLengthLabel.addConstraintBottom(to: controlsContainerView, withBottom: -2)
        videoLengthLabel.addConstraintBound(withHeight: 24, withWidth: 50)
        
        controlsContainerView.addSubview(currentTimeLabel)
        currentTimeLabel.addConstraintleft(to: controlsContainerView, withLeft: 8)
        currentTimeLabel.addConstraintBottom(to: controlsContainerView, withBottom: -2)
        currentTimeLabel.addConstraintBound(withHeight: 24, withWidth: 50)
        
        controlsContainerView.addSubview(videoSlider)
        videoSlider.addConstraintleft(to: currentTimeLabel, withLeft: 46)
        videoSlider.addConstraintBottom(to: controlsContainerView, withBottom: 0)
        videoSlider.addContrainRight(to: videoLengthLabel, withRight: -58)
        videoSlider.addConstraintHeight(withHeight: 30)
        
        backgroundColor = .black
    }

    @objc func hiddenControll() {
        controlsContainerView.isHidden = true
    }
    
    @objc func showControl() {
        controlsContainerView.isHidden = false
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(hiddenControll), userInfo: nil, repeats: false)
    }
    
    func tapVideo() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showControl))
        tap.delegate = self as? UIGestureRecognizerDelegate
        self.addGestureRecognizer(tap)
    }
}

extension CGAffineTransform {
    static let ninetyDegreeRotation = CGAffineTransform(rotationAngle: .pi/2)
}

extension UIView {
    var fullScreenAnimationDuration: TimeInterval {
        return 0.15
    }
    
    func minimizeToFrame() {
        UIView.animate(withDuration: fullScreenAnimationDuration) {
            self.layer.setAffineTransform(.identity)
            self.frame = CGRect(x: 0, y: 0, width: widthScreen, height: widthScreen * 9/16)
            self.layoutIfNeeded()
        }
    }
    
    func goFullscreen() {
        UIView.animate(withDuration: fullScreenAnimationDuration) {
            self.frame = CGRect(x: -(hightScreen - widthScreen) / 2,
                                y: (hightScreen - widthScreen) / 2,
                                width: hightScreen,
                                height: widthScreen)
            self.layer.setAffineTransform(.ninetyDegreeRotation)
        }
    }
}

extension AVPlayerLayer {
    
    var fullScreenAnimationDuration: TimeInterval {
        return 0.15
    }
    
    func minimizeToFrame() {
        UIView.animate(withDuration: fullScreenAnimationDuration) {
            self.setAffineTransform(.identity)
            self.frame = CGRect(x: 0, y: 0, width: widthScreen, height: widthScreen * 9/16)
        }
    }
    
    func goFullscreen() {
        UIView.animate(withDuration: fullScreenAnimationDuration) {
            self.setAffineTransform(.ninetyDegreeRotation)
            self.frame = UIScreen.main.bounds
        }
    }
}

extension UIView {
    func addContrainRight(to secondView: UIView, withRight right: CGFloat) {
        let rightConstraint = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: secondView, attribute: .right, multiplier: 1, constant: right)
        NSLayoutConstraint.activate([rightConstraint])
    }
    
    func addConstraintleft(to secondView: UIView, withLeft left: CGFloat) {
        let leftConstraint = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: secondView, attribute: .left, multiplier: 1, constant: left)
        NSLayoutConstraint.activate([leftConstraint])
    }
    
    func addConstraintBottom(to secondView: UIView, withBottom bottom: CGFloat) {
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: secondView, attribute: .bottom, multiplier: 1, constant: bottom)
        NSLayoutConstraint.activate([bottomConstraint])
    }
    
    func addConstraintBound(withHeight height: CGFloat, withWidth width: CGFloat) {
        let widthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
        NSLayoutConstraint.activate([widthConstraint, heightConstraint])
    }
    
    func addConstraintHeight(withHeight height: CGFloat) {
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
        NSLayoutConstraint.activate([heightConstraint])
    }
    
    func addConstraintCenter(to secondView: UIView, x xConstraint: CGFloat, y yContraint: CGFloat) {
        let xCenter = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: secondView, attribute: .centerX, multiplier: 1, constant:  xConstraint)
        let yCenter = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: secondView, attribute: .centerY, multiplier: 1, constant: yContraint)
        NSLayoutConstraint.activate([xCenter, yCenter])
    }
}
