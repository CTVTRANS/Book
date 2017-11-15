//
//  SingleTypeBookController.swift
//  BookApp
//
//  Created by kien le van on 9/25/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class SingleTypeBookController: BaseViewController {
    
    @IBOutlet weak var menu1: CustomMenu!
    @IBOutlet weak var menu2: CustomMenu!
    @IBOutlet weak var menu3: CustomMenu!
    @IBOutlet weak var heighOfView: NSLayoutConstraint!
    var listBookType: [MenuType] = []
    var typeID = 0
    var indexpath: IndexPath!
    
    var listBook: [Book] = []
    lazy var footerView = UIView.initFooterView()
    var indicator: UIActivityIndicatorView?
    var isMoreData = true
    var isLoading = false
    var pager = 1
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.backgroundColor = UIColor.white
        refresh.tintColor = UIColor.gray
        refresh.addTarget(self, action: #selector(reloadMyData), for: .valueChanged)
        return refresh
    }()
    var sortBy: String = "date"

    @IBOutlet weak var sortType: UILabel!
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivity(inView: self.view)
        table.tableFooterView = UIView()
        table.register(UINib.init(nibName: "ListBookFreee", bundle: nil), forCellReuseIdentifier: "cell")
        table.estimatedRowHeight = 140
        table.addSubview(refreshControl)
        if let ac = footerView.viewWithTag(8) as? UIActivityIndicatorView {
            indicator = ac
        }
        listBookType = Constants.sharedInstance.listBookType
        callBack()
        setupMenu()
        loadMoreData(with: sortBy)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func setupMenu() {
        let array1 = listBookType.filter { (types) -> Bool in
            return types.parentID == 0
        }
        if array1.count > 0 {
            menu1.reloadType(array: array1)
//            menu1.collection.selectItem(at: indexpath, animated: false, scrollPosition: .right)
//            menu1.collection.scrollToItem(at: indexpath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func callBack() {
        menu1.callBack = { [unowned self] typeID1 in
            self.menu3.isHidden = true
            self.typeID = typeID1
            self.reloadMyData()
            let array2 = Constants.sharedInstance.listBookType.filter { (types) -> Bool in
                return types.parentID == typeID1
            }
            if array2.count > 0 {
                self.menu2.isHidden = false
                var newConstraint: CGFloat = 72 + 64
                newConstraint.adjustsSizeToRealIPhoneSize = 72 + 64
                self.heighOfView.constant = newConstraint
                
            } else {
                self.menu2.isHidden = true
                var newConstraint: CGFloat = 40 + 64
                newConstraint.adjustsSizeToRealIPhoneSize = 40 + 64
                self.heighOfView.constant = newConstraint
            }
            self.typeID = typeID1
            self.menu2.reloadType(array: array2)
        }
        
        menu2.callBack = { [unowned self] typeID2 in
            self.typeID = typeID2
            self.reloadMyData()
            var array3 = Constants.sharedInstance.listBookType.filter { (types) -> Bool in
                return types.parentID == typeID2
            }
            if array3.count > 0 {
                self.menu3.isHidden = false
                let allType3 = MenuType(name: "全部", image: "", typeID: typeID2, description: "", parentID: typeID2)
                array3.insert(allType3, at: 0)
                var newConstraint: CGFloat = 168
                newConstraint.adjustsSizeToRealIPhoneSize = 168
                self.heighOfView.constant = newConstraint
            } else {
                self.menu3.isHidden = true
                var newConstraint: CGFloat = 72 + 64
                newConstraint.adjustsSizeToRealIPhoneSize = 72 + 64
                self.heighOfView.constant = newConstraint
            }
            self.menu3.reloadType(array: array3)
        }
        
        menu3.callBack = { [unowned self] (typeID3) in
//            self.showActivity(inView: (self.table.backgroundView)!)
            self.typeID = typeID3
            self.reloadMyData()
        }
        
    }
    
    @objc func reloadMyData() {
        listBook.removeAll()
        table.reloadData()
        pager = 1
        isMoreData = true
        loadMoreData(with: sortBy)
    }
    
    @IBAction func pressedChooseSortType(_ sender: Any) {
        _ = UIAlertController.showActionSheetWith(arrayTitle: ["日期", "观看次数"], handlerAction: { (index) in
            if index == 0 {
                self.sortBy = "date"
                self.sortType.text = "日期"
            } else {
                self.sortBy = "views"
                self.sortType.text = "观看次数"
            }
            self.reloadMyData()
        }, in: self)
    }
}

extension SingleTypeBookController: UITableViewDelegate, UITableViewDataSource {
    // MARK: Table Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listBook.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListBookFreee
        cell?.binData(book: listBook[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: Table Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let vc = storyboard?.instantiateViewController(withIdentifier: "BookDetail") as? BookDetailViewController {
            vc.bookSelected = listBook[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let endOftable = table.contentOffset.y >= (table.contentSize.height - table.frame.size.height)
        if isMoreData && endOftable && !isLoading && !scrollView.isDragging
            && !scrollView.isDecelerating {
            isLoading = true
            table.tableFooterView = footerView
            indicator?.startAnimating()
            loadMoreData(with: sortBy)
        }
    }
    
    func loadMoreData(with: String) {
        let getBook: GetListBookForTypeTask = GetListBookForTypeTask(category: typeID, page: pager, orderBy: with)
        requestWithTask(task: getBook, success: { (data) in
            if let arrayBook = data as? [Book] {
                self.listBook += arrayBook
                self.stopActivityIndicator()
                self.indicator?.stopAnimating()
                self.refreshControl.endRefreshing()
                self.isLoading = false
                self.table.reloadData()
                self.pager += 1
                if arrayBook.count == 0 {
                    self.isMoreData = false
                }
            }
        }) { (error) in
            _ = UIAlertController(title: nil,
                                  message: error as? String,
                                  preferredStyle: .alert)
        }
    }
}
