//
//  MainViewController.swift
//  BookApp
//
//  Created by Le Cong on 8/10/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {

    @IBOutlet weak var constraintTable: NSLayoutConstraint!
    @IBOutlet weak var navigationCustoms: NavigationCustom!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var typeNews1: CustomMenu!
    @IBOutlet weak var typeNews2: CustomMenu!
    @IBOutlet weak var typeNews3: CustomMenu!
    
    var arrayTypeNews: [NewsType] = []
    var arrayNews: [NewsModel] = []
    var typeNewsID: Int = 0
    
    lazy var footerView = UIView.initFooterView()
    var indicator: UIActivityIndicatorView?
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.backgroundColor = UIColor.white
        refresh.tintColor = UIColor.gray
        refresh.addTarget(self, action: #selector(reloadMyData), for: .valueChanged)
        return refresh
    }()
    
    var pager = 1
    var isMoreData = true
    var isLoadMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCallBack()
        getListTypeNews()
        setupUI()
        cellBackClickType()
        table.backgroundView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationCustoms.checkNotifocation()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        table.reloadData()
    }
    
    func checkNotifocationApp() {
        navigationCustoms.checkNotifocation()
    }
    
    func reloadMyData() {
        arrayNews.removeAll()
        table.reloadData()
        pager = 1
        isMoreData = true
        loadMoreData()
    }
    
    // MARK: Setup UI
    
    func setupUI() {
        showActivity(inView: self.view)
        table.estimatedRowHeight = 140
        table.addSubview(refreshControl)
        if let ac = footerView.viewWithTag(8) as? UIActivityIndicatorView {
            indicator = ac
        }
        
        var contrainTop: CGFloat = 40
        contrainTop.adjustsSizeToRealIPhoneSize = 40
        constraintTable.constant = contrainTop
    }
    
    // MARK: Call API
    
    func getListTypeNews() {
        let getAllTypeNews: GetAllTypeNewsTask = GetAllTypeNewsTask()
        requestWithTask(task: getAllTypeNews, success: { (_) in
            self.arrayTypeNews = Constants.sharedInstance.listNewsType
            let arrayType1 = self.arrayTypeNews.filter({ (type: NewsType) -> Bool in
                return type.parentID == 0
            })
            self.typeNewsID = (arrayType1.first?.idType)!
            self.typeNews1.reloadType(array: arrayType1)
            self.reloadMyData()
        }) { (_) in
            
        }
    }
    
    func loadMoreData() {
        let getNews = GetNewsForTypeTask(typeID: typeNewsID, page: pager)
        requestWithTask(task: getNews, success: { (data) in
            if let list = data as? [NewsModel] {
                self.arrayNews += list
                self.table.reloadData()
                self.stopActivityIndicator()
    
                self.isLoadMore = false
                self.refreshControl.endRefreshing()
                self.indicator?.stopAnimating()
                self.pager += 1
                if list.count == 0 {
                    self.isMoreData = false
                }
            }
        }) { (_) in
             self.stopActivityIndicator()
        }
    }
    
    // MARK: Callback Click
    
    func cellBackClickType() {
        typeNews1.callBack = { [weak self] (typeID) in
            self?.showActivity(inView: (self?.table.backgroundView)!)
            self?.typeNewsID = typeID
            self?.reloadMyData()
            let array2 = self?.arrayTypeNews.filter({ (type) -> Bool in
                return type.parentID == typeID
            })
            if (array2?.count)! > 0 {
                var newConstraint: CGFloat = 72
                newConstraint.adjustsSizeToRealIPhoneSize = 72
                self?.constraintTable.constant = newConstraint
            } else {
                var newConstraint: CGFloat = 40
                newConstraint.adjustsSizeToRealIPhoneSize = 40
                self?.constraintTable.constant = newConstraint
            }
            self?.typeNews2.reloadType(array: array2!)
        }
        
        typeNews2.callBack = { [weak self] (typeID2) in
            self?.showActivity(inView: (self?.table.backgroundView)!)
            self?.typeNewsID = typeID2
            self?.reloadMyData()
            var array3 = self?.arrayTypeNews.filter({ (type) -> Bool in
                return type.parentID == typeID2
            })
            if (array3?.count)! > 0 {
                let allType3 = NewsType(idType: typeID2, parentID: typeID2, nameType: "全部", desciptionType: "")
                array3?.insert(allType3, at: 0)
                var newConstraint: CGFloat = 104
                newConstraint.adjustsSizeToRealIPhoneSize = 104
                self?.constraintTable.constant = newConstraint
            } else {
                var newConstraint: CGFloat = 72
                newConstraint.adjustsSizeToRealIPhoneSize = 72
                self?.constraintTable.constant = newConstraint
            }
            self?.typeNews3.reloadType(array: array3!)
        }
        
        typeNews3.callBack = { [weak self] (typeID3) in
            self?.showActivity(inView: (self?.table.backgroundView)!)
            self?.typeNewsID = typeID3
            self?.reloadMyData()
        }
    }
    
    func setupCallBack() {
        NotificationCenter.default.addObserver(self, selector: #selector(checkNotifocationApp), name: NSNotification.Name(rawValue: "reciveNotificaton"), object: nil)
        navigationCustoms.callBackTopButton = { [weak self] (typeButton: TopButton) in
            if typeButton == TopButton.search {
                self?.goToSearch()
                return
            }
            if !(self?.checkLogin())! {
                self?.goToSigIn()
                return
            }
            switch typeButton {
            case TopButton.messageNotification: self?.goToNotification(myViewController: self!)
            case TopButton.videoNotification: self?.goToListPlayaudio()
            default : break
            }
        }
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: Table View Dta Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = table.dequeueReusableCell(withIdentifier: "MainViewCell", for: indexPath) as? MainViewCell {
            cell.binData(news: arrayNews[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        let type = arrayNews[indexPath.row].typeNews
        ShareModel.shareIntance.nameShare = arrayNews[indexPath.row].title
        ShareModel.shareIntance.detailShare = arrayNews[indexPath.row].detailNews
        if type == 1 {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailNewsController {
                vc.news = arrayNews[indexPath.row]
                navigationController?.pushViewController(vc, animated: true)
            }
        } else if type == 2 {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "Type2Detail") as? Type2DetailNewsViewController {
                vc.news = arrayNews[indexPath.row]
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "Type3DetailNewsController") as? Type3DetailNewsController {
                vc.news = arrayNews[indexPath.row]
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: Table View Delegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let endOftable = table.contentOffset.y >= (table.contentSize.height - table.frame.size.height)
        if isMoreData && endOftable && !isLoadMore && !scrollView.isDragging && !scrollView.isDecelerating {
            isLoadMore = true
            table.tableFooterView = footerView
            indicator?.startAnimating()
            loadMoreData()
        } else if !isMoreData && endOftable {

        }
    }
}
