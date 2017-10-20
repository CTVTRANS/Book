//
//  Type2DetailNewsViewController.swift
//  BookApp
//
//  Created by kien le van on 8/23/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import Social

class Type2DetailNewsViewController: BaseViewController {

    @IBOutlet weak var viewBounds: UIView!
    @IBOutlet weak var bottomView: BottomView!
    @IBOutlet weak var timeUp: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var webContent: UIWebView!
    @IBOutlet weak var newsName: UILabel!
    var news: NewsModel!
//    private lazy var member = ProfileMember.getProfile()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivity(inView: UIApplication.shared.keyWindow!)
        if checkLogin() {
            checkStatusLikeBookmark()
        }
        setupUI()
        viewBounds.layer.borderColor = UIColor.rgb(52, 52, 52).cgColor
        setupCallBackButton()
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
        newsName.text = news.title
        userName.text = news.author
        let date = news.timeUp.components(separatedBy: " ")
        timeUp.text = date[0]
        webContent.loadHTMLString(news.content, baseURL: nil)
        stopActivityIndicator()
    }
    
    private func setupCallBackButton() {
        bottomView.downloadButton.isHidden = true
        bottomView.downloadImage.isHidden = true
        bottomView.numberComment.text = String(news.numberComment)
        bottomView.numberLike.text = String(news.numberLike)
        bottomView.numberBookmark.text = String(news.numberBookMark)
        
        bottomView.pressedBottomButton = { [weak self] (typeButotn: BottomButton) in
            if typeButotn == BottomButton.back {
                self?.navigationController?.popViewController(animated: true)
                return
            }
            if !(self?.checkLogin())! {
                self?.goToSigIn()
                return
            }
            switch typeButotn {
            case BottomButton.back:
                 self?.navigationController?.popViewController(animated: true)
            case BottomButton.bookMark:
                self?.pressedBookmark()
            case BottomButton.download:
                print("download")
            case BottomButton.like:
               self?.pressedLike()
            case BottomButton.comment:
                let myStoryboard = UIStoryboard(name: "Global", bundle: nil)
                if let vc = myStoryboard.instantiateViewController(withIdentifier: "CommentController") as? CommentController {
                    vc.idObject = self?.news.idNews
                    vc.commentType = 0
                    vc.object = self?.news
                    self?.present(vc, animated: false, completion: nil)
                }
            }
        }
    }
    
    func pressedLike() {
        let likeTask: LikeTask = LikeTask(likeType: Object.news.rawValue,
                                          memberID: (memberInstance?.idMember)!,
                                          objectId: news.idNews,
                                          token: tokenInstance!)
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

    func pressedBookmark() {
        let bookMarkTask: BookMarkTask = BookMarkTask(bookMarkType: Object.news.rawValue,
                                                      memberID: (memberInstance?.idMember)!,
                                                      objectId: news.idNews,
                                                      token: tokenInstance!)
        self.requestWithTask(task: bookMarkTask, success: { (data) in
            let status: BookMark = (data as? BookMark)!
            var currentBookMark: Int = self.news.numberBookMark
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
}
