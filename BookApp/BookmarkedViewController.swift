//
//  BookmarkedViewController.swift
//  BookApp
//
//  Created by kien le van on 9/7/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class BookmarkedViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var table: UITableView!
    private var listBookMarkOfBook: [Book] = []
    private var listBookMarkOfNews: [NewsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.tableFooterView = UIView()
        table.estimatedRowHeight = 140
        table.register(UINib.init(nibName: "BookDownloadCell", bundle: nil), forCellReuseIdentifier: "bookCell")
        showActivity(inView: self.view)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "My collection".localized
        navigationController?.setNavigationBarHidden(false, animated: animated)
        getNewsBookmarked()
        getBookBookmarked()
    }
    
    func getNewsBookmarked() {
        let getNewsTask = GetAllNewsBookmarkedTask(memberId: (memberInstance?.idMember)!, page: 1)
        requestWithTask(task: getNewsTask, success: { (data) in
            if let listNews = data as? [NewsModel] {
                self.listBookMarkOfNews = listNews
                self.table.reloadData()
                self.stopActivityIndicator()
            }
        }) { (_) in
            self.stopActivityIndicator()
        }
    }
    
    func getBookBookmarked() {
        let getBookTask = GetAllBookBookmarkedTask(memberID: (memberInstance?.idMember)!, page: 1)
        requestWithTask(task: getBookTask, success: { (data) in
            if let listBook = data as? [Book] {
                self.listBookMarkOfBook = listBook
                self.table.reloadData()
                self.stopActivityIndicator()
            }
        }) { (_) in
            self.stopActivityIndicator()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segment.selectedSegmentIndex == 0 {
            return listBookMarkOfNews.count
        } else {
            return listBookMarkOfBook.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segment.selectedSegmentIndex == 0 {
            return newsCells(indexPath: indexPath)
        } else {
            return bookCells(indexPath: indexPath)
        }
    }
    
    func newsCells(indexPath: IndexPath) -> NewsBookmarkedCell {
        let newsCell = table.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as? NewsBookmarkedCell
        newsCell?.binData(news: listBookMarkOfNews[indexPath.row])
        return newsCell!
    }
    
    func bookCells(indexPath: IndexPath) -> BookDownloadCell {
        let bookCell = table.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as? BookDownloadCell
        let book = listBookMarkOfBook[indexPath.row]
        bookCell?.binData(book: book)
        bookCell?.playButton.isHidden = true
        bookCell?.callBackButton = { [weak self] (action: String) in
            switch action {
            case "removeBook":
                self?.removeBookmark(indexPath: indexPath)
                self?.table.reloadData()
                break
            default:
                break
            }
        }
        return bookCell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: false)
        if segment.selectedSegmentIndex == 0 {
            let myStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let type = listBookMarkOfNews[indexPath.row].typeNews
            if type == 1 {
                let vc = myStoryBoard.instantiateViewController(withIdentifier: "Detail") as? DetailNewsController
                vc?.news = listBookMarkOfNews[indexPath.row]
                navigationController?.pushViewController(vc!, animated: true)
            } else if type == 2 {
                let vc = myStoryBoard.instantiateViewController(withIdentifier: "Type2Detail") as? Type2DetailNewsViewController
                vc?.news = listBookMarkOfNews[indexPath.row]
                navigationController?.pushViewController(vc!, animated: true)
            } else {
                let vc = myStoryBoard.instantiateViewController(withIdentifier: "Type3DetailNewsController") as? Type3DetailNewsController
                vc?.news = listBookMarkOfNews[indexPath.row]
                navigationController?.pushViewController(vc!, animated: true)
            }
        } else {
            let myStoryboard = UIStoryboard(name: "Book", bundle: nil)
            let vc = myStoryboard.instantiateViewController(withIdentifier: "BookDetail") as? BookDetailViewController
            vc?.bookSelected = listBookMarkOfBook[indexPath.row]
            navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    func removeBookmark(indexPath: IndexPath) {
        let removeBookmarkTask = BookMarkTask(bookMarkType: Object.book.rawValue,
                                              memberID: (memberInstance?.idMember)!,
                                              objectId: listBookMarkOfBook[indexPath.row].idBook,
                                              token: tokenInstance!)
        requestWithTask(task: removeBookmarkTask, success: { (_) in
            self.listBookMarkOfBook.remove(at: indexPath.row)
            self.table.reloadData()
        }) { (_) in
            
        }
    }
    
    @IBAction func pressedSegment(_ sender: Any) {
        table.reloadData()
    }
}
