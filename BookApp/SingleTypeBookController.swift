//
//  SingleTypeBookController.swift
//  BookApp
//
//  Created by kien le van on 9/25/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class SingleTypeBookController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var typeBook: BookType?
    private var listBook: [Book] = []
    lazy var footerView = UIView.initFooterView()
    private var indicator: UIActivityIndicatorView?
    private var isMoreData = true
    private var isLoading = false
    private var pager = 1
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.backgroundColor = UIColor.white
        refresh.tintColor = UIColor.gray
        refresh.addTarget(self, action: #selector(reloadMyData), for: .valueChanged)
        return refresh
    }()
    private var sortBy: String = "date"

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
        loadMoreData(with: sortBy)
    }
    
    func reloadMyData() {
        listBook.removeAll()
        table.reloadData()
        pager = 1
        isMoreData = true
        loadMoreData(with: sortBy)
    }
    
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
        
        let getBook: GetListBookForTypeTask = GetListBookForTypeTask(category: (typeBook?.typeID)!, page: pager, orderBy: with)
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
    @IBAction func pressedChooseSortType(_ sender: Any) {
        _ = UIAlertController.showActionSheetWith(arrayTitle: ["date", "numberView"], handlerAction: { (index) in
            if index == 0 {
                self.sortBy = "date"
                self.sortType.text = "date"
            } else {
                self.sortBy = "views"
                self.sortType.text = "views"
            }
            self.reloadMyData()
        }, in: self)
    }
}
