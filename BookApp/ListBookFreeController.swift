//
//  ListBookFreeController.swift
//  BookApp
//
//  Created by kien le van on 8/31/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class ListBookFreeController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    var listBook = [Book]()
    lazy var footerView = UIView.initFooterView()
    private var indicator: UIActivityIndicatorView?
    var isMoreData = true
    var isLoading = false
    var pager = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "BookFree"
        table.estimatedRowHeight = 140
        table.register(UINib.init(nibName: "ListBookFreee", bundle: nil), forCellReuseIdentifier: "cell")
        if let ac = footerView.viewWithTag(8) as? UIActivityIndicatorView {
            indicator = ac
        }
        showActivity(inView: UIApplication.shared.keyWindow!)
        loadMore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: Table Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listBook.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListBookFreee {
            cell.binData(book: listBook[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: Table Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        let bookStoryboard = UIStoryboard(name: "Book", bundle: nil)
        if let vc = bookStoryboard.instantiateViewController(withIdentifier: "BookDetail") as? BookDetailViewController {
            vc.bookSelected = listBook[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

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
        let getBookFree: GetBookFreeTask = GetBookFreeTask(limit: 10, page: pager)
        requestWithTask(task: getBookFree, success: { (data) in
            if let list  = data as? [Book] {
                self.listBook += list
                self.table.reloadData()
                self.stopActivityIndicator()
                self.indicator?.stopAnimating()
                self.isLoading = false
                self.pager += 1
                if list.count == 0 {
                    self.isMoreData = false
                    self.table.tableFooterView = UIView()
                }
            }
        }) { (error) in
            _ = UIAlertController(title: nil,
                                  message: error as? String,
                                  preferredStyle: .alert)
        }
    }
}
