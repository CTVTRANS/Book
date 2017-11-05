//
//  SearchViewController.swift
//  BookApp
//
//  Created by kien le van on 9/4/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController, UISearchBarDelegate {
    
    // MARK: Property UI

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var hotView: CustomHistorySearch!
    @IBOutlet weak var typeView: CustomHistorySearch!
    @IBOutlet weak var titleForViewTypes: UILabel!
    @IBOutlet weak var titleForViewHot: UILabel!
    @IBOutlet weak var heightOfTypeView: NSLayoutConstraint!
    @IBOutlet weak var heightOfHotView: NSLayoutConstraint!
    
    // MARK: Property Object
    
    @IBOutlet weak var iconSearchBook: UILabel!
    var listBook: [Book] = []
    var listTypeBook: [TypeSearch] = []
    var listHotBook: [TypeSearch] = []
    
    @IBOutlet weak var iconSearchNews: UILabel!
    var listNews: [NewsModel] = []
    var listTypeNews: [TypeSearch] = []
    var listHotNews: [TypeSearch] = []
    var searchBook: Bool = true
    var currentIDType: Int?
    
    // MARK: Property Reload - Refreash
    
    var pager = 1
    var isMoreData = true
    var isLoading = false
    lazy var footerView = UIView.initFooterView()
    var indicator: UIActivityIndicatorView?
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
        table.tableFooterView = footerView
        table.estimatedRowHeight = 140
        searchBar.backgroundImage = UIImage()
        table.addSubview(refreashControl)
        setUp()
        getHotKeyWord()
        setUPCallBack()
        showTypeAndHotKeyWord()
        if let ac = footerView.viewWithTag(8) as? UIActivityIndicatorView {
            indicator = ac
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    @objc func reloadDataSearch() {
        pager = 1
        isMoreData = true
        listNews.removeAll()
        listBook.removeAll()
        table.reloadData()
        table.isHidden = false
        table.backgroundView = UIView()
        showActivity(inView: table.backgroundView!)
        if currentIDType == nil {
            searchWithKeyWord(keyword: searchBar.text!)
        } else {
            searchWithTypeName(typeID: currentIDType!)
        }
    }
    
    // MARK: Get Key Work Hot
    
    func getHotKeyWord() {
        let getKeyWordBook = GetHotKeyWordTask(type: Object.book.rawValue)
        requestWithTask(task: getKeyWordBook, success: { (data) in
            if let list = data as? [String] {
                for nameKeyword in list {
                    let typeSearch = TypeSearch(idType: 1, name: nameKeyword)
                     self.listHotBook.append(typeSearch)
                }
                self.showTypeAndHotKeyWord()
            }
        }) { (_) in
            
        }
        let getKeyWordNews = GetHotKeyWordTask(type: Object.news.rawValue)
        requestWithTask(task: getKeyWordNews, success: { (data) in
            if let list = data as? [String] {
                for nameKeyword in list {
                    let typeSearch = TypeSearch(idType: 1, name: nameKeyword)
                     self.listHotNews.append(typeSearch)
                }
                self.showTypeAndHotKeyWord()
            }
        }) { (_) in
            
        }
    }
    
    // MARK: Set Up UI
    
    private func setUp() {
        titleForViewTypes.text = "分类搜素"
        titleForViewHot.text = "热门搜索"
        for typeNews in Constants.sharedInstance.listNewsType {
            let typeSearch = TypeSearch(idType: typeNews.idType, name: typeNews.nameType)
            self.listTypeNews.append(typeSearch)
        }
        
        let getAllTypeBook: GetTypeOfBookTask = GetTypeOfBookTask()
        requestWithTask(task: getAllTypeBook, success: { (_) in
            for typeBook in Constants.sharedInstance.listBookType {
                let typeSearch = TypeSearch(idType: typeBook.typeID, name: typeBook.name)
                self.listTypeBook.append(typeSearch)
            }
            self.showTypeAndHotKeyWord()
        }) { (_) in
            
        }
    }
    
    private func showTypeAndHotKeyWord() {
        if searchBook {
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
    
    // MARK: UIControll
    
    func setUPCallBack() {
        typeView.callBackButton = { [unowned self] (_ type: TypeSearch) in
            self.searchBar.text = type.nameTypeSearch
            self.currentIDType = type.idTypeSearch
            self.reloadDataSearch()
        }
        hotView.callBackButton = { [unowned self] (_ type: TypeSearch) in
            self.currentIDType = nil
            self.searchBar.text = type.nameTypeSearch
            self.reloadDataSearch()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil {
            table.isHidden = false
            isMoreData = true
            pager = 1
            let keyWord = searchBar.text
            let array = listTypeBook.filter({ (object) -> Bool in
                return object.nameTypeSearch == keyWord
            })
            if array.count > 0 {
                currentIDType = array.first?.idTypeSearch
                searchWithTypeName(typeID: (array.first?.idTypeSearch)!)
                return
            }
            reloadDataSearch()
        }
    }
    
    @IBAction func pressedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentIDType = nil
        if searchText == "" {
            table.isHidden = true
            isMoreData = true
        }
    }
    
    @IBAction func pressedChangeType(_ sender: Any) {
        isMoreData = true
        searchBar.text = ""
        if searchBook {
            searchBook = false
        } else {
            searchBook = true
        }
        let textMidle = iconSearchBook.text
        iconSearchBook.text = iconSearchNews.text
        iconSearchNews.text = textMidle
        showTypeAndHotKeyWord()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

struct TypeSearch {
    var idTypeSearch: Int?
    var nameTypeSearch: String?
    init(idType: Int, name: String) {
        idTypeSearch = idType
        nameTypeSearch = name
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBook {
            return listBook.count
        }
        return listNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ResultSearch
        if searchBook {
            cell?.binData(objec: listBook[indexPath.row])
        } else {
            cell?.binData(objec: listNews[indexPath.row])
        }
        return cell!
    }
    
    // MARK: Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchBook {
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
}

extension SearchViewController {
    
    // MARK: Search With Type Object
    
    func searchWithTypeName(typeID: Int) {
        if searchBook {
            let searchBook = GetListBookForTypeTask(category: typeID, page: pager, orderBy: "date")
            requestWithTask(task: searchBook, success: { (data) in
                self.indicator?.stopAnimating()
                self.refreashControl.endRefreshing()
                self.isLoading = false
                if let arrayBook =  data as? [Book] {
                    self.listBook += arrayBook
                    self.table.reloadData()
                    if arrayBook.count == 0 {
                        self.isMoreData = false
                        self.table.backgroundView = self.table.noData
                    } else {
                        self.pager += 1
                        self.table.backgroundView = nil
                    }
                }
            }, failure: { (_) in
                self.table.backgroundView = nil
            })
        } else {
            let searchNews = GetNewsForTypeTask(typeID: typeID, page: pager)
            requestWithTask(task: searchNews, success: { (data) in
                self.table.backgroundView = nil
                self.indicator?.stopAnimating()
                self.refreashControl.endRefreshing()
                self.isLoading = false
                if let arrayNews = data as? [NewsModel] {
                    self.listNews += arrayNews
                    self.table.reloadData()
                    if arrayNews.count == 0 {
                        self.isMoreData = false
                        self.table.backgroundView = self.table.noData
                    } else {
                        self.pager += 1
                        self.table.backgroundView = nil
                    }
                }
            }, failure: { (_) in
                self.table.backgroundView = nil
            })
        }
    }

    // MARK: Search With Text
    
    func searchWithKeyWord(keyword: String) {
        if searchBook {
            let searchBookTask: SearchBookTask = SearchBookTask(keyWord: keyword, page: pager)
            requestWithTask(task: searchBookTask, success: { (data) in
                self.table.backgroundView = nil
                self.indicator?.stopAnimating()
                self.refreashControl.endRefreshing()
                self.isLoading = false
                if let arrayBook =  data as? [Book] {
                    self.listBook += arrayBook
                    self.table.reloadData()
                    if arrayBook.count == 0 {
                        self.table.backgroundView = self.table.noData
                        self.isMoreData = false
                    } else {
                        self.pager += 1
                        self.table.backgroundView = nil
                    }
                }
            }, failure: { (_) in
                self.table.backgroundView = nil
            })
        } else if !searchBook {
            let searchNewsTask: SearchNewsTask = SearchNewsTask(keyWord: keyword, page: pager)
            requestWithTask(task: searchNewsTask, success: { (data) in
                self.table.backgroundView = nil
                self.indicator?.stopAnimating()
                self.refreashControl.endRefreshing()
                self.isLoading = false
                if let arrayNews = data as? [NewsModel] {
                    self.listNews += arrayNews
                    self.table.reloadData()
                    if arrayNews.count == 0 {
                        self.isMoreData = false
                        self.table.backgroundView = self.table.noData
                    } else {
                        self.pager += 1
                        self.table.backgroundView = nil
                    }
                }
            }, failure: { (_) in
                self.table.backgroundView = nil
            })
        }
        searchBar.endEditing(true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let endTable = table.contentOffset.y >= table.contentSize.height - table.frame.size.height
        if isMoreData && endTable && !isLoading && !scrollView.isDragging && !scrollView.isDecelerating {
            table.tableFooterView = footerView
            isLoading = true
            indicator?.startAnimating()
            if currentIDType == nil {
                searchWithKeyWord(keyword: searchBar.text!)
            } else {
                searchWithTypeName(typeID: currentIDType!)
            }
        }
    }
}
