//
//  BookAudioController.swift
//  BookApp
//
//  Created by kien le van on 8/21/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class BookAudioController: BaseViewController {
    
    @IBOutlet weak var imageBook: UIImageView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var web: UIWebView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var hightOfWebView: NSLayoutConstraint!
    
    @IBOutlet weak var sliderBar: UISlider!
    @IBOutlet weak var currentMinAudio: UILabel!
    @IBOutlet weak var totalTimeAudio: UILabel!
    @IBOutlet weak var buttonImge: UIImageView!
    @IBOutlet weak var audioDetailButton: UIButton!
    
    // MARK: MP3 Property
    
//    lazy var mp3 = MP3Player.shareIntanse
    var loadedAudio: Bool = true
    var loadedWebView: Bool = false
    var book: Book?
    var totalTime: Float64? = 0
    var isdragSlider = false
    var currentTime: Float?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivity(inView: UIApplication.shared.keyWindow!)
        customSliderBar()
        loadWebView()
        checkAudio()
        NotificationCenter.default.addObserver(self, selector: #selector(stopAudio(notification:)), name: NSNotification.Name(rawValue: "videoDidStart"), object: nil)
        mp3.limitTime = { [weak self] in
            self?.buttonImge.image = #imageLiteral(resourceName: "audio_play")
        }
    }
    
    // MARK: Setup Audio
    
    func checkAudio() {
        if let currentBook = mp3.currentAudio as? Book {
            playerOvserver()
            sliderBar.value = Float(mp3.getCurrentTime().0 / mp3.getTotalTime())
            currentMinAudio.text = mp3.getCurrentTime().1
            totalTimeAudio.text = mp3.getTotalTimeString()
            if currentBook.idBook == book?.idBook && mp3.isPlaying() {
                buttonImge.image = #imageLiteral(resourceName: "audio_pause")
            } else if currentBook.idBook == book?.idBook && !mp3.isPlaying() {
                buttonImge.image = #imageLiteral(resourceName: "audio_play")
            } else {
                sliderBar.value = 0.0
                currentMinAudio.text = "00:00"
                totalTimeAudio.text = mp3.getTotalTimeString()
            }
            return
        }
        mp3.currentAudio = nil
        mp3.player?.pause()
        mp3.player = nil
    }
    
    func loadAudio() {
        mp3.track(object: book!, types: TypePlay.onLine)
        mp3.didLoadAudio = { [weak self] timeFloat, timeString in
            self?.totalTimeAudio.text = timeString
            self?.playerOvserver()
        }
    }
    
    func playerOvserver() {
        mp3.player?.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 1), queue: DispatchQueue.main, using: { [weak self] progressTime in
            let seconds = CMTimeGetSeconds(progressTime)
            self?.currentTime = Float(seconds)
            let secondsString = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
            let minutesString = String(format: "%02d", Int(seconds / 60))
            self?.currentMinAudio.text = "\(minutesString):\(secondsString)"
            
//            if self?.tokenInstance == "" || self?.memberInstance?.level == 0 {
//                if seconds > Double(DefaultApp.sharedInstance.limitAudio) {
//                    self?.mp3.pause()
//                    self?.mp3.player?.seek(to: kCMTimeZero)
//                    self?.buttonImge.image = #imageLiteral(resourceName: "audio_play")
//                }
//            }
            
            if let duration = self?.mp3.player?.currentItem?.duration {
                if !(self?.isdragSlider)! {
                    let durationSeconds = CMTimeGetSeconds(duration)
                    self?.sliderBar.value = Float(seconds / durationSeconds)
                }
            }
        })
    }
    
    // MARK: Setup Silder Bar
    
    func customSliderBar() {
        sliderBar.minimumValue = 0.0
        sliderBar.value = 0.0
        sliderBar.setThumbImage(#imageLiteral(resourceName: "thumb"), for: .normal)
        sliderBar.minimumTrackTintColor = UIColor.rgb(255, 106, 6)
        sliderBar.addTarget(self, action: #selector(playbackSliderValueChanged(slider:event:)), for: .valueChanged)
    }
    
    func playbackSliderValueChanged( slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                isdragSlider = true
                break
            case .moved: break
            case .ended:
                isdragSlider = false
                break
            default:
                break
            }
        }
        if let duration = mp3.player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(sliderBar.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            mp3.player?.seek(to: seekTime, completionHandler: { (_) in
            })
        }
    }
    
    // MARK: UIcontrol
    
    @IBAction func pressPlay(_ sender: Any) {
        loadAudio()
        if buttonImge.image == #imageLiteral(resourceName: "audio_play") {
            mp3.play()
            buttonImge.image = #imageLiteral(resourceName: "audio_pause")
        } else {
            mp3.pause()
            buttonImge.image = #imageLiteral(resourceName: "audio_play")
        }
    }
    
    @IBAction func pressedPrevious(_ sender: Any) {
        let seconds: Int64 = Int64(currentTime!)
        let targetTime: CMTime = CMTimeMake(seconds - 15, 1)
        mp3.player?.seek(to: targetTime)
    }
    
    @IBAction func pressedNext(_ sender: Any) {
        let seconds: Int64 = Int64(currentTime!)
        let targetTime: CMTime = CMTimeMake(seconds + 15, 1)
        mp3.player?.seek(to: targetTime)
    }
    
    func stopAudio(notification: Notification) {
        if mp3.isPlaying() {
            mp3.pause()
            buttonImge.image = #imageLiteral(resourceName: "audio_play")
        }
    }
    
    @IBAction func pressedBuy(_ sender: Any) {
        let myStoryBoard = UIStoryboard(name: "Setting", bundle: nil)
        if let vc = myStoryBoard.instantiateViewController(withIdentifier: "BuyProductViewController") as? BuyProductViewController {
            vc.product = book
            navigationController?.pushViewController(vc, animated: true)
            navigationItem.backBarButtonItem?.title = ""
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension BookAudioController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        imageBook.layer.cornerRadius = imageBook.frame.size.width / 2
        let hightOfContenWebView: CGFloat = web.scrollView.contentSize.height
        hightOfWebView.constant = hightOfContenWebView
        self.loadedWebView = true
        if self.loadedAudio && self.loadedWebView {
            self.stopActivityIndicator()
        }
    }
    
    func loadWebView() {
        audioDetailButton.layer.borderColor = UIColor.rgb(255, 101, 0).cgColor
        imageBook.sd_setImage(with: URL(string: (book?.imageURL)!), placeholderImage: #imageLiteral(resourceName: "place_holder"))
        web.delegate = self
        let content = css + (book?.descriptionBook)!
        web.loadHTMLString(content, baseURL: nil)
        web.scrollView.isScrollEnabled = false
    }
}
