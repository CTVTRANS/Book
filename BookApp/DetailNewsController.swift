//
//  DetailViewController.swift
//  BookApp
//
//  Created by Le Cong on 8/10/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class DetailNewsController: BaseViewController, UIWebViewDelegate {

    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var bottomView: BottomView!
    @IBOutlet weak var bodyNews: UIWebView!
    @IBOutlet weak var detailNews: UILabel!
    @IBOutlet weak var hightOfWebView: NSLayoutConstraint!
    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var userName: UILabel!
    var news: NewsModel!
    private var newsRelated: NewsModel?
    @IBOutlet weak var detailImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivity(inView: UIApplication.shared.keyWindow!)
        setupCallBackButton()
        setupUI()
        bodyNews.delegate = self
        bodyNews.scrollView.isScrollEnabled = false
        getNewsRelated()
        if checkLogin() {
            checkStatusLikeBookmark()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(title: news.title,
                            style: .done,
                            target: self,
                            action: nil)
        setupRightSlideOut()
    }
    
    func checkStatusLikeBookmark() {
        let checkLiked: CheckLikedTask = CheckLikedTask(likeType: Object.news.rawValue,
                                                        memberID: (memberInstance?.idMember)!,
                                                        objectID: news.idNews)
        requestWithTask(task: checkLiked, success: { [weak self] (data) in
            if let status = data as? (Bool, Int) {
                if status.0 {
                    self?.bottomView.likeImage.image = #imageLiteral(resourceName: "ic_bottom_liked")
                } else {
                    self?.bottomView.likeImage.image = #imageLiteral(resourceName: "ic_bottom_like")
                }
                self?.news.numberLike = status.1
                self?.bottomView.numberLike.text = String(status.1)
            }
        }) { (_) in
            
        }
        let checkBookMarked: CheckBookMarkedTask =
            CheckBookMarkedTask(bookMarkType: Object.news.rawValue,
                                memberID: (memberInstance?.idMember)!,
                                objectID: news.idNews)
        requestWithTask(task: checkBookMarked, success: { [weak self] (data) in
            if let status = data as? (Bool, Int) {
                if status.0 {
                    self?.bottomView.bookMarkImage.image = #imageLiteral(resourceName: "ic_bottom_bookMarked")
                } else {
                    self?.bottomView.bookMarkImage.image = #imageLiteral(resourceName: "ic_bottom_bookMark")
                }
                self?.news.numberBookMark = status.1
                self?.bottomView.numberBookmark.text = String(status.1)
            }
        }) { (_) in
            
        }
    }
    
    func setupUI() {
        userName.text = news.author
        bodyNews.loadHTMLString(news.content, baseURL: nil)
        imageNews.sd_setImage(with: URL(string: news.imageURL))
    }
    
    func getNewsRelated() {
        let getNews = GetNewsRelatedTask(idCurrentNews: news.idNews)
        requestWithTask(task: getNews, success: { (data) in
            if let news = data as? NewsModel {
                self.newsRelated = news
                let imageNews = URL(string: news.imageURL)
                self.detailImage.sd_setImage(with: imageNews)
                self.detailNews.text = news.detailNews
                self.stopActivityIndicator()
            }
        }) { (_) in
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let hightContentWeb: CGFloat = bodyNews.scrollView.contentSize.height
        hightOfWebView.constant = hightContentWeb
        stopActivityIndicator()
    }
    
    private func setupCallBackButton() {
        bottomView.downloadImage.isHidden = true
        bottomView.downloadButton.isHidden = true
        bottomView.numberComment.text = String(news.numberComment)
        bottomView.numberLike.text = String(news.numberLike)
        bottomView.numberBookmark.text = String(news.numberBookMark)
        
        bottomView.pressedBottomButton = { [weak self] (typeButton: BottomButton) in
            if typeButton == BottomButton.back {
                self?.navigationController?.popViewController(animated: true)
                return
            }
            if !(self?.checkLogin())! {
                self?.goToSigIn()
                return
            }
            switch typeButton {
            case BottomButton.back:
                 self?.navigationController?.popViewController(animated: true)
            case BottomButton.comment:
                let myStoryboard = UIStoryboard(name: "Global", bundle: nil)
                if let vc = myStoryboard.instantiateViewController(withIdentifier: "CommentController") as? CommentController {
                    vc.idObject = self?.news.idNews
                    vc.commentType = 0
                    vc.object = self?.news
                    self?.present(vc, animated: false, completion: nil)
                }
            case BottomButton.like:
               self?.pressedLike()
            case BottomButton.bookMark:
                self?.pressedBookmark()
            case BottomButton.download:
                print("download")
            }
        }
    }
    
    func pressedBookmark() {
        let bookMarkTask: BookMarkTask = BookMarkTask(bookMarkType: Object.news.rawValue,
                                                      memberID: (memberInstance?.idMember)!,
                                                      objectId: self.news.idNews,
                                                      token: tokenInstance!)
        self.requestWithTask(task: bookMarkTask, success: { (data) in
            let status: BookMark = (data as? BookMark)!
            var currentBookMark: Int =  self.news.numberBookMark
            if status == BookMark.bookMark {
                self.bottomView.bookMarkImage.image = #imageLiteral(resourceName: "ic_bottom_bookMarked")
                currentBookMark += 1
            } else {
                self.bottomView.bookMarkImage.image = #imageLiteral(resourceName: "ic_bottom_bookMark")
                currentBookMark -= 1
            }
            self.news.numberBookMark = currentBookMark
            self.bottomView.numberBookmark.text = String(currentBookMark)

        }, failure: { (_) in
            
        })

    }
    
    func pressedLike() {
        let likeTask: LikeTask = LikeTask(likeType: Object.news.rawValue,
                                          memberID: (memberInstance?.idMember)!,
                                          objectId: news.idNews, token: tokenInstance!)
        self.requestWithTask(task: likeTask, success: { (data) in
            let status: Like = (data as? Like)!
            var currentLike: Int = self.news.numberLike
            if status == Like.like {
                self.bottomView.likeImage.image = #imageLiteral(resourceName: "ic_bottom_liked")
                currentLike += 1
            } else {
                self.bottomView.likeImage.image = #imageLiteral(resourceName: "ic_bottom_like")
                currentLike -= 1
            }
            self.news.numberLike = currentLike
            self.bottomView.numberLike.text = String(currentLike)
        }, failure: { (_) in
            
        })
    }
    
    @IBAction func pressChangeNews(_ sender: Any) {
        bodyNews.scrollView.contentSize.height = 23
        news = newsRelated
        showActivity(inView: UIApplication.shared.keyWindow!)
        setupCallBackButton()
        setupUI()
        getNewsRelated()
        if checkLogin() {
            checkStatusLikeBookmark()
        }
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(title: news.title,
                            style: .done,
                            target: self,
                            action: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
