//
//  BookDetailViewController.swift
//  BookApp
//
//  Created by kien le van on 8/21/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class BookDetailViewController: BaseViewController {

    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var topShare: TopViewShare!
    @IBOutlet weak var topTabbar: CustomTopTabbar!
    @IBOutlet weak var bottomView: BottomView!
    private var timer: Timer?
    
    var downloadImageSuccess = false
    var downloadAuidosucess = false
    var bookSelected: Book!
    var free: Bool = false
    
    // MARK: Property Use For Hidden StatusBar
    var isHiddenBaterry: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.5) { () -> Void in
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if checkLogin() {
            checkLikeBookmark()
        }
        setupScroll()
        setupCallBackBottom()
        setupCallBackTopTabbar()
        setupShareView()
        scroll.delegate = self
        setupShareObject()
        bottomView.numberComment.text = String(bookSelected.numberComment)
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(increaseViewBook), userInfo: nil, repeats: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return isHiddenBaterry
    }
    
    func setupShareObject() {
        ShareModel.shareIntance.nameShare = bookSelected.name
        let detailBook = bookSelected.descriptionBook.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        var str = ""
        if detailBook.count < 200 {
            str = detailBook
        } else {
            let index = detailBook.index(detailBook.startIndex, offsetBy: 199)
            str = String(detailBook[..<index])
        }
        ShareModel.shareIntance.detailShare = str + "..."
    }
    
    func checkLikeBookmark() {
        let checkLiked: CheckLikedTask = CheckLikedTask(likeType: Object.book.rawValue, memberID: (memberInstance?.idMember)!, objectID: bookSelected.idBook)
        requestWithTask(task: checkLiked, success: { [weak self] (data) in
            if let status = data as? (Bool, Int) {
                if status.0 {
                    self?.bottomView.likeImage.image = #imageLiteral(resourceName: "ic_bottom_liked")
                } else {
                    self?.bottomView.likeImage.image = #imageLiteral(resourceName: "ic_bottom_like")
                }
                self?.bookSelected.numberLike = status.1
                self?.bottomView.numberLike.text = String(status.1)
            }
        }) { (_) in
        }
        let checkBookMarked: CheckBookMarkedTask = CheckBookMarkedTask(bookMarkType: Object.book.rawValue, memberID: (memberInstance?.idMember)!, objectID: bookSelected.idBook)
        requestWithTask(task: checkBookMarked, success: { [weak self] (data) in
            if let status = data as? (Bool, Int) {
                if status.0 {
                    self?.bottomView.bookMarkImage.image = #imageLiteral(resourceName: "ic_bottom_bookMarked")
                } else {
                    self?.bottomView.bookMarkImage.image = #imageLiteral(resourceName: "ic_bottom_bookMark")
                }
                self?.bookSelected.numberBookMark = status.1
                self?.bottomView.numberBookmark.text = String(status.1)
            }
        }) { (_) in
        }
    }
    
    // MARK: Setup ScrollView
    
    func setupScroll() {
        scroll.contentSize = CGSize(width: 3 * widthScreen, height: scroll.frame.height)
        let audioVC = self.storyboard?.instantiateViewController(withIdentifier: "BookAudio") as? BookAudioController
        audioVC?.book = bookSelected
        audioVC?.view.frame = CGRect(x: 0, y: 0, width: scroll.frame.size.width, height: scroll.frame.height)
        let videoVC = self.storyboard?.instantiateViewController(withIdentifier: "BookVideo") as? BookVideoController
        videoVC?.book = bookSelected
        videoVC?.view.frame = CGRect(x: widthScreen, y: 0, width: scroll.frame.size.width, height: scroll.frame.height)
        videoVC?.callBackFullScreen = { [weak self] in
            self?.isHiddenBaterry = !(self?.isHiddenBaterry)!
        }
        let textVC =
            self.storyboard?.instantiateViewController(withIdentifier: "BookText") as? BookTextController
        textVC?.book = bookSelected
        textVC?.view.frame = CGRect(x: 2 * widthScreen, y: 0, width: scroll.frame.size.width, height: scroll.frame.height)
        audioVC?.willMove(toParentViewController: self)
        self.addChildViewController(audioVC!)
        audioVC?.didMove(toParentViewController: self)
        scroll.addSubview((audioVC?.view)!)
        
        videoVC?.willMove(toParentViewController: self)
        self.addChildViewController(videoVC!)
        videoVC?.didMove(toParentViewController: self)
        scroll.addSubview(videoVC!.view)
        
        textVC?.willMove(toParentViewController: self)
        self.addChildViewController(textVC!)
        textVC?.didMove(toParentViewController: self)
        scroll.addSubview(textVC!.view)
    }
    
    func setupShareView() {
        topShare.titleTop.text = bookSelected?.name
        if self.revealViewController() != nil {
            revealViewController().rightViewRevealWidth = 80
            topShare.shareButton.addTarget(self.revealViewController(), action: #selector(revealViewController().rightRevealToggle(_:)), for: .touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    
    @objc func increaseViewBook() {
        let increaseView = IncreaseViewBookTask(idBook: bookSelected.idBook)
        requestWithTask(task: increaseView, success: { (_) in
            
        }) { (_) in
        }
    }
    
    // MARK: Call Back

    func setupCallBackBottom() {
        bottomView.numberBookmark.text = String(bookSelected.numberBookMark)
        bottomView.numberLike.text = String(bookSelected.numberLike)
        bottomView.numberComment.text = String(bookSelected.numberComment)
        
        bottomView.pressedBottomButton = { [weak self] (typeButton: BottomButton) in
            let myStoryboard = UIStoryboard(name: "Global", bundle: nil)
            if typeButton == BottomButton.back {
                self?.timer?.invalidate()
                self?.timer = nil
                self?.navigationController?.popViewController(animated: true)
                return
            }
            if !(self?.checkLogin())! {
                self?.goToSigIn()
                return
            }
            switch typeButton {
            case BottomButton.back: break
            case BottomButton.bookMark: self?.pressedBookmark()
            case BottomButton.comment:
                let vc = myStoryboard.instantiateViewController(withIdentifier: "CommentController") as? CommentController
                vc?.idObject = self?.bookSelected?.idBook
                vc?.commentType = Object.book.rawValue
                vc?.object = self?.bookSelected
                self?.present(vc!, animated: false, completion: nil)
            case BottomButton.like: self?.pressedLike()
            case BottomButton.download:
                
                if self?.memberInstance?.level != 1 && !(self?.free)! {
                    UIAlertController.showAler(title: "", message: "Only VIP can download".localized, inViewController: self!)
                    return
                }
                let download = DownloadAudioController()
                download.downloadBook(book: (self?.bookSelected)!)
            }
        }
    }
    
    func setListBookBdownload() {
        var listBookDownaloaed = Book.getBook()
        for singleBook in listBookDownaloaed! where singleBook.idBook == bookSelected.idBook {
            return
        }
        listBookDownaloaed?.append(bookSelected)
        Book.saveBook(myBook: listBookDownaloaed!)
    }
    
    func setupCallBackTopTabbar() {
        topTabbar.changeViewPressed = {[weak self] (originX: CGFloat, originY: CGFloat, widthView: CGFloat, hightView: CGFloat, index: Int) in
            self?.scroll.contentOffset = CGPoint(x: CGFloat(index) * widthScreen, y: 0)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension BookDetailViewController: UIScrollViewDelegate {
    
    // MARK: Scroll Delagate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position: CGFloat = scroll.contentOffset.x / scroll.frame.size.width
        if position > 0.7 {
            self.bottomView.downloadButton.isHidden = true
            self.bottomView.downloadImage.isHidden = true
        } else {
            self.bottomView.downloadButton.isHidden = false
            self.bottomView.downloadImage.isHidden = false
        }
        switch position {
        case 0...0.3 :
            topTabbar.audioButton.setTitleColor(UIColor.rgb(255, 102, 0), for: .normal)
            topTabbar.textButton.setTitleColor(UIColor.black, for: .normal)
            topTabbar.videoButton.setTitleColor(UIColor.black, for: .normal)
        case 0.8...1.2 :
            topTabbar.videoButton.setTitleColor(UIColor.rgb(255, 102, 0), for: .normal)
            topTabbar.textButton.setTitleColor(UIColor.black, for: .normal)
            topTabbar.audioButton.setTitleColor(UIColor.black, for: .normal)
        case 1.8...2.7 :
            topTabbar.textButton.setTitleColor(UIColor.rgb(255, 102, 0), for: .normal)
            topTabbar.videoButton.setTitleColor(UIColor.black, for: .normal)
            topTabbar.audioButton.setTitleColor(UIColor.black, for: .normal)
        default: break
            
        }
        
        let newFrame = CGRect(x: position * (widthScreen / 3), y: topTabbar.animationView.frame.origin.y, width: widthScreen / 3, height: topTabbar.animationView.frame.size.height)
        UIView.animate(withDuration: 0.15, delay: 0.0, options: [], animations: {
            self.topTabbar.animationView.frame = newFrame
        }, completion: nil
        )
    }

}

extension BookDetailViewController {
    func pressedBookmark() {
        let bookMarkTask: BookMarkTask = BookMarkTask(bookMarkType: Object.book.rawValue, memberID: (memberInstance?.idMember)!, objectId: bookSelected.idBook, token: tokenInstance!)
        self.requestWithTask(task: bookMarkTask, success: { (data) in
            let status: BookMark = (data as? BookMark)!
            if status == BookMark.bookMark {
                self.bottomView.bookMarkImage.image = #imageLiteral(resourceName: "ic_bottom_bookMarked")
                self.bookSelected.numberBookMark += 1
            } else {
                self.bottomView.bookMarkImage.image = #imageLiteral(resourceName: "ic_bottom_bookMark")
                self.bookSelected.numberBookMark -= 1
            }
            self.bottomView.numberBookmark.text = String(self.bookSelected.numberBookMark)
        }, failure: { (_) in
            
        })
    }
    
    func pressedLike() {
        let likeTask: LikeTask = LikeTask(likeType: Object.book.rawValue, memberID: (memberInstance?.idMember)!, objectId: bookSelected.idBook, token: tokenInstance!)
        requestWithTask(task: likeTask, success: { (data) in
            let status: Like = (data as? Like)!
            if status == Like.like {
                self.bottomView.likeImage.image = #imageLiteral(resourceName: "ic_bottom_liked")
                self.bookSelected.numberLike += 1
            } else {
                self.bookSelected.numberLike -= 1
                self.bottomView.likeImage.image = #imageLiteral(resourceName: "ic_bottom_like")
            }
            self.bottomView.numberLike.text = String(self.bookSelected.numberLike)
        }, failure: { (_) in
            
        })
    }
}
