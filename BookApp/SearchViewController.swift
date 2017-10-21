//
//  SearchViewController.swift
//  BookApp
//
//  Created by kien le van on 9/4/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var hotView: CustomHistorySearch!
    @IBOutlet weak var typeView: CustomHistorySearch!
    @IBOutlet weak var titleForViewTypes: UILabel!
    @IBOutlet weak var titleForViewHot: UILabel!
    @IBOutlet weak var heightOfTypeView: NSLayoutConstraint!
    @IBOutlet weak var heightOfHotView: NSLayoutConstraint!
    
    @IBOutlet weak var iconSearchBook: UILabel!
    private var listBook: [Book] = []
    private var listTypeBook: [String] = []
    private var listHotBook: [String] = []
    
    @IBOutlet weak var iconSearchNews: UILabel!
    private var listNews: [NewsModel] = []
    private var listTypeNews: [String] = []
    private var listHotNews: [String] = []
    private var seachBook: Bool = true
    
    private var pager = 1
    private var isMoreData = true
    private var isLoading = false
    lazy var refreashControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.backgroundColor = .white
        refresh.tintColor = .gray
        refresh.addTarget(self, action: #selector(reloadDataSearch), for: .valueChanged)
        return refresh
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.isHidden = true
        table.tableFooterView = UIView()
        table.estimatedRowHeight = 140
        searchBar.backgroundImage = UIImage()
        table.addSubview(refreashControl)
        setUp()
        getHotKeyWord()
        setUPCallBack()
        showTypeAndHotKeyWord()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    func reloadDataSearch() {
        pager = 1
        isMoreData = true
        listNews.removeAll()
        listBook.removeAll()
        table.reloadData()
        searchWithKeyWord(keyword: searchBar.text!)
    }
    
    func getHotKeyWord() {
        let getKeyWordBook = GetHotKeyWordTask(type: Object.book.rawValue)
        requestWithTask(task: getKeyWordBook, success: { (data) in
            if let list = data as? [String] {
                self.listHotBook = list
                self.showTypeAndHotKeyWord()
            }
        }) { (_) in
            
        }
        let getKeyWordNews = GetHotKeyWordTask(type: Object.news.rawValue)
        requestWithTask(task: getKeyWordNews, success: { (data) in
            if let list = data as? [String] {
                self.listHotNews = list
                self.showTypeAndHotKeyWord()
            }
        }) { (_) in
            
        }
    }
    
    private func setUp() {
        titleForViewTypes.text = "分类搜素"
        titleForViewHot.text = "热门搜索"
        for typeNews in Constants.sharedInstance.listNewsType {
            self.listTypeNews.append(typeNews.nameType)
        }
        
        let getAllTypeBook: GetTypeOfBookTask = GetTypeOfBookTask()
        requestWithTask(task: getAllTypeBook, success: { (_) in
            for typeBook in Constants.sharedInstance.listBookType {
                self.listTypeBook.append(typeBook.name)
            }
            self.showTypeAndHotKeyWord()
        }) { (_) in
            
        }
    }
    
    func setUPCallBack() {
        typeView.callBackButton = { (_ name: String) in
            self.searchBar.text = name
            self.searchWithKeyWord(keyword: name)
        }
        hotView.callBackButton = { (_ name: String) in
            self.searchBar.text = name
            self.searchWithKeyWord(keyword: name)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if seachBook {
            return listBook.count
        }
        return listNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ResultSearch
        if seachBook {
            cell?.binData(objec: listBook[indexPath.row])
        } else {
            cell?.binData(objec: listNews[indexPath.row])
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if seachBook {
            let myStoryboard = UIStoryboard(name: "Book", bundle: nil)
            if let vc = myStoryboard.instantiateViewController(withIdentifier: "BookDetail") as? BookDetailViewController {
                vc.bookSelected = listBook[indexPath.row]
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            let myStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let type = listNews[indexPath.row].typeNews
            if type == 1 {
                if let vc = myStoryboard.instantiateViewController(withIdentifier: "Detail") as? DetailNewsController {
                    vc.news = listNews[indexPath.row]
                    navigationController?.pushViewController(vc, animated: true)
                }
            } else if type == 2 {
                if let vc = myStoryboard.instantiateViewController(withIdentifier: "Type2Detail") as? Type2DetailNewsViewController {
                    vc.news = listNews[indexPath.row]
                    navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                if let vc = myStoryboard.instantiateViewController(withIdentifier: "Type3DetailNewsController") as? Type3DetailNewsController {
                    vc.news = listNews[indexPath.row]
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        listNews.removeAll()
        listBook.removeAll()
        if searchBar.text != nil {
            isMoreData = true
            searchWithKeyWord(keyword: searchBar.text!)
        }
    }
    
    func searchWithKeyWord(keyword: String) {
        showActivity(inView: self.view)
        if seachBook {
            let searchBookTask: SearchBookTask = SearchBookTask(keyWord: keyword, page: 1)
            requestWithTask(task: searchBookTask, success: { (data) in
                if let arrayBook =  data as? [Book] {
                    self.stopActivityIndicator()
                    if arrayBook.count == 0 {
                        _ = UIAlertController.initAler(title: "", message: "nodata", inViewController: self)
                        return
                    }
                    self.listBook = arrayBook
                    self.table.isHidden = false
                    self.table.reloadData()
                }
            }, failure: { (_) in
                self.stopActivityIndicator()
            })
        } else if !seachBook {
            let searchNewsTask: SearchNewsTask = SearchNewsTask(keyWord: keyword, page: pager)
            requestWithTask(task: searchNewsTask, success: { (data) in
                if let arrayNews = data as? [NewsModel] {
                    self.stopActivityIndicator()
                    if arrayNews.count == 0 {
                        _ = UIAlertController.initAler(title: "", message: "nodata", inViewController: self)
                        return
                    }
                    self.listNews = arrayNews
                    self.table.isHidden = false
                    self.table.reloadData()
                }
            }, failure: { (_) in
                self.stopActivityIndicator()
            })
        }
        searchBar.endEditing(true)
    }
    
    @IBAction func pressedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            table.isHidden = true
            isMoreData = true
        }
    }
    
    @IBAction func pressedChangeType(_ sender: Any) {
        isMoreData = true
        searchBar.text = ""
        if seachBook {
//            iconSearchBook.textColor = UIColor.black
//            iconSearchNews.textColor = UIColor.rgb(255, 102, 0)
            seachBook = false
        } else {
//            iconSearchBook.textColor = UIColor.rgb(255, 102, 0)
//            iconSearchNews.textColor = UIColor.black
            seachBook = true
        }
        let textMidle = iconSearchBook.text
        iconSearchBook.text = iconSearchNews.text
        iconSearchNews.text = textMidle
        showTypeAndHotKeyWord()
    }
    
    private func showTypeAndHotKeyWord() {
        if seachBook {
            typeView.listText = listTypeBook
            hotView.listText = listHotBook
        } else {
            typeView.listText = listTypeNews
            hotView.listText = listHotNews
        }
        typeView.realoadData()
        hotView.realoadData()
        heightOfTypeView.constant = typeView.heightForView!
        heightOfHotView.constant = hotView.heightForView!
        listBook.removeAll()
        listNews.removeAll()
        table.isHidden = true
    }
    
    func searchAction() {
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
