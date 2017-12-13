//
//  CommentController.swift
//  BookApp
//
//  Created by kien le van on 8/28/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class CommentController: BaseViewController, UITextViewDelegate {
    
    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var titleComment: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var botLayoutCommentView: NSLayoutConstraint!
    @IBOutlet weak var commentTextView: UITextView!
    
    private var tap: UITapGestureRecognizer?
    var arrayObject = [SpecialComment]()
    var arrayComment: [Comment] = []
    var commentNormal: SpecialComment?
   
    var idObject: Int?
    var commentType: Int?
    var object: AnyObject!
    
    var isLoading = false
    var isMoreData = true
    var pager = 1
    lazy var footer = UIView.initFooterView()
    var indicator: UIActivityIndicatorView?
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.backgroundColor = .white
        refresh.tintColor = .gray
        refresh.addTarget(self, action: #selector(reloadMyData), for: .valueChanged)
        return refresh
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivity(inView: self.view)
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification1:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        commentTextView.delegate = self
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        alphaView.addGestureRecognizer(tap!)
        getComment()
        if let ac = footer.viewWithTag(8) as? UIActivityIndicatorView {
            indicator = ac
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func reloadMyData() {
        isMoreData = true
        pager = 1
        arrayComment.removeAll()
        commentNormal = SpecialComment(name: "Comment Newest".localized, array: arrayComment)
        arrayObject.removeAll()
        table.reloadData()
        getComment()
    }
    
    func setupUI() {
        alphaView.isHidden = true
        commentView.isHidden = true
        table.estimatedRowHeight = 140
        table.tableFooterView = footer
        table.addSubview(refreshControl)
        table.backgroundView = table.noData
        commentNormal = SpecialComment(name: "Comment Newest".localized, array: arrayComment)
        
        if let news = object as? NewsModel {
            titleComment.text = " " + news.title + " "
            detail.text = news.detailNews
        }
        if let book = object as? Book {
            titleComment.text = " " + book.name + " "
            detail.text = "Book App"
        }
        if let chanel = object as? Chanel {
            titleComment.text = " " + chanel.nameChanel + " "
            detail.text = chanel.nameTeacher
        }
    }
    
    // MARK: Call API
    
    func getComment() {
        let getCommentHot: GetCommentHot = GetCommentHot(commentType: commentType!, idObject: idObject!, memberID: (memberInstance?.idMember)!)
        requestWithTask(task: getCommentHot, success: { (data) in
            if let arrayCommentHot = data as? [Comment] {
                if arrayCommentHot.count > 0 {
                    let hotComment: SpecialComment = SpecialComment(name: "Comment Hot".localized, array: arrayCommentHot)
                    self.arrayObject.append(hotComment)
                    Constants.sharedInstance.listCommentHot = arrayCommentHot
                } else {
                     Constants.sharedInstance.listCommentHot.removeAll()
                }
            }
            self.arrayObject.append(self.commentNormal!)
            self.getCommentAPI()
        }) { (error) in
            self.stopActivityIndicator()
            UIAlertController.showAler(title: "", message: error!, inViewController: self)
        }
    }
   
    // MARK: Button Control
    
    @IBAction func pressedBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func pressedWriteButton(_ sender: Any) {
        commentTextView.becomeFirstResponder()
    }
    
    @IBAction func pressedSendComment(_ sender: Any) {
        let sendComment: SendCommentTask = SendCommentTask(commentType: commentType!, memberID: (memberInstance?.idMember)!, objectId: idObject!, content: commentTextView.text, token: tokenInstance!)
        requestWithTask(task: sendComment, success: { (_) in
            self.commentTextView.text = ""
            self.commentTextView.endEditing(true)
            UIAlertController.showAler(title: "", message: "send message success, please wait review".localized, inViewController: self)
        }) { (_) in
            
        }
    }
    
    // MARK: Keyboard Control
   
    @objc func keyboardNotification(notification1: NSNotification) {
        if let userInfo = notification1.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.navigationItem.leftBarButtonItem?.isEnabled = true
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                commentView.isHidden = true
                alphaView.isHidden = true
                botLayoutCommentView.constant = 0.0
            } else {
                self.navigationItem.leftBarButtonItem?.isEnabled = false
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                commentView.isHidden = false
                alphaView.isHidden = false
                alphaView.backgroundColor = .black
                alphaView.alpha = 0.5
                botLayoutCommentView.constant = (endFrame?.size.height)! - 3
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
            //            DispatchQueue.main.async(execute: {
            //                self.scrollLastMessage()
            //            })
        }
    }
    
    @objc func dismissKeyboard() {
        commentTextView.endEditing(true)
    }
    
    func getCommentAPI() {
        let getComment: GetAllComment = GetAllComment(commentType: self.commentType!, idObject: self.idObject!, page: pager, idMember: (self.memberInstance?.idMember)!)
        self.requestWithTask(task: getComment, success: { (data) in
            if let arrayOfComment = data as? [Comment] {
                if arrayOfComment.count > 0 {
                    self.pager += 1
                    let objectNormalcomment = self.arrayObject.filter({ (obj) -> Bool in
                        return obj.name == "Comment Newest".localized
                    })
                    objectNormalcomment.first?.comment += arrayOfComment
                } else {
                    self.isMoreData = false
                }
                self.isLoading = false
                self.indicator?.stopAnimating()
                self.table.reloadData()
                self.stopActivityIndicator()
                self.refreshControl.endRefreshing()
            }
        }) { (error) in
            self.stopActivityIndicator()
            UIAlertController.showAler(title: "", message: (error)!, inViewController: self)
        }
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self)
    }
}

extension CommentController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Table Data Source
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: table.frame.size.width, height: 30))
        view.backgroundColor = UIColor.rgb(254, 153, 0)
        let nameTypeComment: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: table.frame.size.width, height: 30))
        var size: CGFloat = 13
        size.adjustsSizeToRealIPhoneSize = 13.0
        nameTypeComment.font = UIFont(name: "HelveticaNeue", size: size)
        nameTypeComment.text = arrayObject[section].name
        nameTypeComment.textAlignment = .left
        nameTypeComment.textColor = UIColor.white
        nameTypeComment.backgroundColor = UIColor.clear
        view.addSubview(nameTypeComment)
        return view
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arrayObject[section].name
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayObject.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayObject[section].comment.count
    }
    
    // MARK: Table Delegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell
        let sectionObject = arrayObject[indexPath.section]
        let commenObject = sectionObject.comment[indexPath.row]
        cell?.binData(commentObject: commenObject)
        cell?.pressLikeComment = { [unowned self] in
            let likeComment: LikeTask = LikeTask(likeType: Object.comment.rawValue,
                                                 memberID: (self.memberInstance?.idMember)!,
                                                 objectId: commenObject.idComment,
                                                 token: (self.tokenInstance)!)
            self.requestWithTask(task: likeComment, success: { (data) in
                let status: Like = (data as? Like)!
                var currentLike: Int = Int(cell!.numberLike.text!)!
                if status == Like.like {
                    currentLike += 1
                    cell?.imageLike.image = #imageLiteral(resourceName: "ic_bottom_liked")
                    cell?.numberLike.text = String(currentLike)
                } else {
                    currentLike -= 1
                    cell?.imageLike.image = #imageLiteral(resourceName: "ic_bottom_like")
                    cell?.numberLike.text = String(currentLike)
                }
            }, failure: { (_) in
                
            })
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let endOfTable = table.contentOffset.y >= (table.contentSize.height - table.frame.size.height)
        if isMoreData && !isLoading && endOfTable && !scrollView.isDecelerating && !scrollView.isDragging {
            isLoading = true
            getCommentAPI()
            indicator?.startAnimating()
        }
    }
}
