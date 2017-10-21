//
//  CommentController.swift
//  BookApp
//
//  Created by kien le van on 8/28/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class CommentController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var titleComment: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var botLayoutCommentView: NSLayoutConstraint!
    @IBOutlet weak var commentTextView: UITextView!
    
    private var tap: UITapGestureRecognizer?
    private var arrayObject = [SpecialComment]()
    var idObject: Int?
    var commentType: Int?
    var object: AnyObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivity(inView: self.view)
        commentView.isHidden = true
        table.estimatedRowHeight = 140
        table.tableFooterView = UIView()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification1:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        commentTextView.delegate = self
        alphaView.isHidden = true
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        alphaView.addGestureRecognizer(tap!)
        getCommet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupUI() {
        if let news = object as? NewsModel {
            titleComment.text = news.title
            detail.text = news.detailNews
        }
        if let book = object as? Book {
            titleComment.text = book.name
             detail.text = "Book App"
        }
        if let chanel = object as? Chanel {
            titleComment.text = chanel.nameChanel
            detail.text = "Book App"
        }
    }
    
    func getCommet() {
        let getCommentHot: GetCommentHot =
            GetCommentHot(commentType: commentType!,
                          idObject: idObject!,
                          memberID: (memberInstance?.idMember)!)
        requestWithTask(task: getCommentHot, success: { (data) in
            if let arrayCommentHot = data as? [Comment] {
                if arrayCommentHot.count > 0 {
                    let hotComment: SpecialComment = SpecialComment(name: "热门评论", array: arrayCommentHot)
                    self.arrayObject.append(hotComment)
                    Constants.sharedInstance.listCommentHot = arrayCommentHot
                }
            }
            let getComment: GetAllComment =
                GetAllComment(commentType: self.commentType!,
                              idObject: self.idObject!,
                              page: 1,
                              idMember: (self.memberInstance?.idMember)!)
            self.requestWithTask(task: getComment, success: { (data) in
                if let arrayOfComment = data as? [Comment] {
                    if arrayOfComment.count > 0 {
                        let normalComment: SpecialComment = SpecialComment(name: "最新评论", array: arrayOfComment)
                        self.arrayObject.append(normalComment)
                    }
                    self.table.reloadData()
                    self.stopActivityIndicator()
                }
            }) { (error) in
                self.stopActivityIndicator()
                _ = UIAlertController(title: nil,
                                      message: error as? String,
                                      preferredStyle: .alert)
            }
            
        }) { (error) in
            self.stopActivityIndicator()
            _ = UIAlertController(title: nil,
                                  message: error as? String,
                                  preferredStyle: .alert)
        }
    }
    
    // MARK: Table Data Source
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: table.frame.size.width, height: 30))
        view.backgroundColor = UIColor.rgb(254, 153, 0)
        let nameTypeComment: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: table.frame.size.width, height: 30))
        nameTypeComment.font = UIFont(name: "DFHei Std W5", size: 15)
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
        cell?.pressLikeComment = { [weak self] in
            let likeComment: LikeTask = LikeTask(likeType: Object.comment.rawValue,
                                                 memberID: (self?.memberInstance?.idMember)!,
                                                 objectId: commenObject.idComment,
                                                 token: (self?.tokenInstance)!)
            self?.requestWithTask(task: likeComment, success: { (data) in
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

    // MARK: Button Control
    
    @IBAction func pressedBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func pressedWriteButton(_ sender: Any) {
        commentTextView.becomeFirstResponder()
    }
    
    @IBAction func pressedSendComment(_ sender: Any) {
        let sendComment: SendCommentTask = SendCommentTask(commentType: commentType!,
                                                           memberID: (memberInstance?.idMember)!,
                                                           objectId: idObject!,
                                                           content: commentTextView.text,
                                                           token: tokenInstance!)
        requestWithTask(task: sendComment, success: { (data) in
            self.commentTextView.text = ""
            self.commentTextView.endEditing(true)
            print(data!)
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
    
    func dismissKeyboard() {
        commentTextView.endEditing(true)
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self)
    }
}
