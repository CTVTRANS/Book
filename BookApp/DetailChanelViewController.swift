//
//  DetailTeacherViewController.swift
//  BookApp
//
//  Created by kien le van on 8/14/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class DetailChanelViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var process: UIProgressView!
    // MARK: Property UI
    
    @IBOutlet weak var bottomView: BottomView!
    @IBOutlet weak var topViewShare: TopViewShare!
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var chanelImage: UIImageView!
    @IBOutlet weak var nameTeacher: UILabel!
    @IBOutlet weak var chaneType: UILabel!
    @IBOutlet weak var numberView: UILabel!
    @IBOutlet weak var numberSubcrible: UILabel!
    
    @IBOutlet weak var downloadAllButton: UIButton!
    @IBOutlet weak var subcribedTeacher: UIButton!
    @IBOutlet weak var heightImageChanel: NSLayoutConstraint!
    
    // MARK: Property Control
    
    var chanel: Chanel!
    var lessonUploaded = [Lesson]()
    var timer: Timer?
    var idChap: Int?
    
    private lazy var footerView = UIView.initFooterView()
    private var indicator: UIActivityIndicatorView?
    private var isMoreData = true
    private var isLoading = false
    private var pager = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.estimatedRowHeight = 140
        showActivity(inView: self.view)
        setupUI()
        setupTopShare()
        setupCallBackBottom()
        if checkLogin() {
            checkLike()
            checkSubcribleed()
        }
        getDataFromServer()
        var heightHeader: CGFloat = 188
        heightHeader.adjustsSizeToRealIPhoneSize = 188
        table.tableHeaderView?.frame.size.height = heightHeader
        if let ac = footerView.viewWithTag(8) as? UIActivityIndicatorView {
            indicator = ac
        }
        ShareModel.shareIntance.nameShare = chanel.nameChanel
        ShareModel.shareIntance.detailShare = ""
        mp3.limitTime = { [weak self] in
            self?.table.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = chanel.nameChanel
        navigationController?.setNavigationBarHidden(false, animated: false)
        let leftBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_navigation"), style: .done, target: self, action: #selector(pressedBack))
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func pressedBack() {
        timer?.invalidate()
        timer = nil
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: UI
    
    func setupUI() {
        downloadAllButton.layer.borderColor = UIColor.rgb(254, 153, 0).cgColor
        subcribedTeacher.layer.borderColor = UIColor.rgb(254, 153, 0).cgColor
        table.tableFooterView = UIView()
        
        chanelImage.sd_setImage(with: URL(string: chanel.imageTeacherURL))
        chanelImage.layer.cornerRadius = heightImageChanel.constant / 2
        chaneType.text = chanel.typeChanel
        nameTeacher.text = chanel.nameTeacher
        numberSubcrible.text = String(chanel.numberSubcrible)
        bottomView.numberLike.text = String(chanel.numberLike)
        bottomView.numberComment.text = String(chanel.numberCommet)
        bottomView.hiddenBottom()
        
    }
    
    func checkLike() {
        let chekLike = CheckLikedTask(likeType: Object.chanel.rawValue, memberID: (memberInstance?.idMember)!, objectID: chanel.idChanel)
        requestWithTask(task: chekLike, success: { [weak self] (data) in
            if let status = data as? (Bool, Int) {
                if status.0 {
                    self?.bottomView.likeImage.image = #imageLiteral(resourceName: "ic_bottom_liked")
                } else {
                    self?.bottomView.likeImage.image = #imageLiteral(resourceName: "ic_bottom_like")
                }
            }
        }) { (_) in
        }
    }
    
    func setupTopShare() {
        topViewShare.titleTop.text = chanel.nameChanel
        if self.revealViewController() != nil {
            revealViewController().rightViewRevealWidth = 80
            topViewShare.shareButton.addTarget(self.revealViewController(), action: #selector(revealViewController().rightRevealToggle(_:)), for: .touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    // MARK: Get Data
    
    func getDataFromServer() {
        let getNumberView: GetTotaViewOfChanel = GetTotaViewOfChanel(chanelID: chanel.idChanel)
        requestWithTask(task: getNumberView, success: { (data) in
            if let numberViewChanel = data as? Int {
                self.chanel.numberView = numberViewChanel
                self.numberView.text = String(numberViewChanel)
            }
        }) { (_) in
            
        }
        loadMore()
    }
    
    func checkSubcribleed() {
        let allChanelSubcrible: [Chanel] = Constants.sharedInstance.listChanelSubcribled
        for chanelSubcribled in allChanelSubcrible where chanel.idChanel == chanelSubcribled.idChanel {
            subcribedTeacher.setTitle("  已訂閱頻道  ", for: .normal)
            subcribedTeacher.isEnabled = false
        }
    }
    
    // MARK: Table Delegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let endOftable = table.contentOffset.y >= (table.contentSize.height - table.frame.size.height)
        if isMoreData && endOftable && !isLoading && !scrollView.isDragging && !scrollView.isDecelerating {
            isLoading = true
            table.tableFooterView = footerView
            indicator?.startAnimating()
            loadMore()
        }
    }
    
    func loadMore() {
        let getLesson: GetListlessonOfChanelTask = GetListlessonOfChanelTask(chanelID: chanel.idChanel, page: pager)
        requestWithTask(task: getLesson, success: { (data) in
            if let arrayLesson = data as? [Lesson] {
                self.lessonUploaded  += arrayLesson
                self.table.reloadData()
                self.stopActivityIndicator()
                self.pager += 1
                self.isLoading = false
                self.indicator?.stopAnimating()
                if arrayLesson.count == 0 {
                    self.isMoreData = false
                }
            }
        }) { (error) in
            _ = UIAlertController(title: nil, message: error as? String, preferredStyle: .alert)
        }
    }
    
    // MARK: Play Music
    
    func play(lesson: Lesson, index: Int) {
        if let current = mp3.currentAudio as? Lesson {
            if lesson.idChap == current.idChap && mp3.isPlaying() {
                mp3.pause()
                table.reloadData()
                return
            } else if lesson.idChap == current.idChap && !mp3.isPlaying() {
                mp3.play()
                table.reloadData()
                return
            }
        }
        mp3.track(object: lesson, types: TypePlay.onLine)
        mp3.didLoadAudio = { [weak self] _, _ in
            self?.inCreeView(lesson: lesson)
            self?.table.reloadData()
        }
       addToHistory(lesson: lesson)
    }
    
    // MARK: Button Control
    
    func setupCallBackBottom() {
        bottomView.numberLike.text = String(chanel.numberLike)
        bottomView.numberComment.text = String(chanel.numberCommet)
        bottomView.pressedBottomButton = { [weak self] typeButton in
            if !(self?.checkLogin())! {
                self?.goToSigIn()
                return
            }
            if typeButton == BottomButton.comment {
                let myStoryboard = UIStoryboard(name: "Global", bundle: nil)
                let vc = myStoryboard.instantiateViewController(withIdentifier: "CommentController") as? CommentController
                vc?.idObject = self?.chanel.idChanel
                vc?.commentType = 2
                vc?.object = self?.chanel
                self?.present(vc!, animated: false, completion: nil)
            } else if typeButton == BottomButton.like {
                self?.likeChanel()
            }
        }
    }
    
    @IBAction func pressedSubcribeButton(_ sender: Any) {
        if !checkLogin() {
            goToSigIn()
            return
        }
        let subcrible: SubcribleChanelTask = SubcribleChanelTask(memberID: (memberInstance?.idMember)!, chanelID: chanel.idChanel, token: tokenInstance!)
        requestWithTask(task: subcrible, success: { (data) in
            if let status: Subcrible = data as? Subcrible {
                if status == Subcrible.subcrible {
                    self.chanel.numberSubcrible += 1
                    self.numberSubcrible.text = String(self.chanel.numberSubcrible)
                    Constants.sharedInstance.listChanelSubcribled.append(self.chanel)
                    self.subcribedTeacher.setTitle("  已訂閱頻道  ", for: .normal)
                    self.subcribedTeacher.isEnabled = false
                }
            }
        }) { (_) in
            
        }
    }
    
    @IBAction func pressedDownloadAll(_ sender: Any) {
        if !checkLogin() {
            goToSigIn()
            return
        } else if memberInstance?.level == 0 {
            UIAlertController.showAler(title: "", message: "VIP會員才能下載", inViewController: self)
            return
        }
        let download = DownloadAudioController()
        download.downloadArrayLeeson(arrayLesson: lessonUploaded) { (_) in

        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension DetailChanelViewController {
    func likeChanel() {
        let like = LikeTask(likeType: Object.chanel.rawValue, memberID: (memberInstance?.idMember)!, objectId: chanel.idChanel, token: tokenInstance!)
        requestWithTask(task: like, success: { (data) in
            let status: Like = (data as? Like)!
            if status == Like.like {
                self.bottomView.likeImage.image = #imageLiteral(resourceName: "ic_bottom_liked")
                self.chanel.numberLike += 1
            } else {
                self.chanel.numberLike -= 1
                self.bottomView.likeImage.image = #imageLiteral(resourceName: "ic_bottom_like")
            }
            self.bottomView.numberLike.text = String(self.chanel.numberLike)
        }) { (_) in
            
        }
    }
    
    func addToHistory(lesson: Lesson) {
        let add = AddToHistoryTask(memberid: (memberInstance?.idMember)!, token: tokenInstance!, type: ScreenShow.chanel.rawValue, lessonID: lesson.idChap)
        requestWithTask(task: add, success: { (_) in
            
        }) { (_) in
            
        }
    }
    
    @objc func sendRequestIncreaseViews() {
        let viewed: IncreaseVIewChanelTask = IncreaseVIewChanelTask(lessonID: idChap!)
        requestWithTask(task: viewed, success: { (data) in
            if let status = data as? String {
                if status == "success" {
                    self.chanel.numberView += 1
                    let numberView = self.chanel.numberView
                    self.numberView.text = String(numberView)
                    self.table.reloadData()
                }
            }
        }) { (_) in
            
        }
    }
    
    func inCreeView(lesson: Lesson) {
        timer?.invalidate()
        timer = nil
        idChap = lesson.idChap
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(sendRequestIncreaseViews), userInfo: nil, repeats: false)
        
    }
    
    // MARK: Table Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessonUploaded.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChanelUpLoaeCell", for: indexPath) as? ChanelUpLoaeCell {
            let lesson: Lesson = lessonUploaded[indexPath.row]
            lesson.chanelOwner = chanel.nameChanel
            cell.binData(chap: lesson)
            cell.callBackButton = { [weak self] (typeButton: String) in
                switch typeButton {
                case "download":
                    if !(self?.checkLogin())! {
                        self?.goToSigIn()
                        return
                    } else if self?.memberInstance?.level == 0 {
                        UIAlertController.showAler(title: "", message: "VIP會員才能下載", inViewController: self!)
                        return
                    }
                    let download = DownloadAudioController()
                    let arr = [lesson]
                    download.downloadArrayLeeson(arrayLesson: arr, completionHandler: { (_) in

                    })
                case "play":
                    self?.play(lesson: lesson, index: indexPath.row)
                default :
                    return
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
    }
}
