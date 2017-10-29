//
//  DetailSingleGroupViewController.swift
//  BookApp
//
//  Created by kien le van on 9/11/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class DetailSingleGroupViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var heightOfImage: NSLayoutConstraint!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var adress: UILabel!
    @IBOutlet weak var idWeChat: UILabel!
    @IBOutlet weak var nameGroup: UILabel!
    @IBOutlet weak var imageGroup: UIImageView!
    @IBOutlet weak var table: UITableView!
    var groupSelected: SecrectGroup?
    var arrayNews: [NewsInGroups] = []
    
    // MARK: Reload, Refresh View
    
    lazy var footerView = UIView.initFooterView()
    private var indicator: UIActivityIndicatorView?
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.backgroundColor = UIColor.white
        refresh.tintColor = UIColor.gray
        refresh.addTarget(self, action: #selector(reloadMyData), for: .valueChanged)
        return refresh
    }()
    private var pager = 1
    private var isMoreData = true
    private var isLoadMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivity(inView: self.view)
        adress.text = groupSelected?.adress
        idWeChat.text = groupSelected?.idWechat
        nameGroup.text = groupSelected?.name
        imageGroup.sd_setImage(with: URL(string: (groupSelected?.imageURL)!), placeholderImage: #imageLiteral(resourceName: "userPlaceHolder"))
        imageGroup.layer.cornerRadius = heightOfImage.constant / 2
        
        table.addSubview(refreshControl)
        if let ac = footerView.viewWithTag(8) as? UIActivityIndicatorView {
            indicator = ac
        }
        loadMoreData()
        
//        let backItem = UIBarButtonItem()
//        backItem.title = ""
//        navigationItem.backBarButtonItem = backItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (groupSelected?.isSubcrible)! {
            joinButton.setTitle("   已关注   ", for: .normal)
        }
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func reloadMyData() {
        arrayNews.removeAll()
        table.reloadData()
        pager = 1
        isMoreData = true
        loadMoreData()
    }
    
    // MARK: TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DetailSingleGroupCell {
            cell.binData(news: arrayNews[indexPath.row])
        return cell
        }
        return UITableViewCell()
    }
    
    // MARK: TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        let new = arrayNews[indexPath.row]
        new.groupOwner = groupSelected!
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailSingleNewsForGroupController") as? DetailSingleNewsForGroupController {
            vc.news = new
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let endOftable = table.contentOffset.y >= (table.contentSize.height - table.frame.size.height)
        if isMoreData && endOftable && !isLoadMore && !scrollView.isDragging && !scrollView.isDecelerating {
            isLoadMore = true
            table.tableFooterView = footerView
            indicator?.startAnimating()
            loadMoreData()
        }
    }
    
    // MARK: UIControll
    
    @IBAction func pressedJoinButton(_ sender: Any) {
        if !checkLogin() {
            goToSigIn()
            return
        }
        let subcrible = SubcribleOneGroupTask(memberID: (memberInstance?.idMember)!, groupID: (groupSelected?.idGroup)!, token: tokenInstance!)
        requestWithTask(task: subcrible, success: { (data) in
            if let status = data as? Bool {
                if status {
                    self.joinButton.setTitle("   已关注   ", for: .normal)
                    self.groupSelected?.isSubcrible = true
                } else {
                    self.joinButton.setTitle("   關注   ", for: .normal)
                    self.groupSelected?.isSubcrible = false
                }
            }
        }) { (_) in
            
        }
    }
    
    // MARK: Call API
    
    func loadMoreData() {
        let getNewsInGroup: GetNewsInGroupTask = GetNewsInGroupTask(idGroup: (groupSelected?.idGroup)!, limit: 30, page: pager)
        requestWithTask(task: getNewsInGroup, success: { (data) in
            if let  array = data as? [NewsInGroups] {
                self.arrayNews += array
                self.table.reloadData()
                self.stopActivityIndicator()
                
                self.isLoadMore = false
                self.refreshControl.endRefreshing()
                self.indicator?.stopAnimating()
                self.pager += 1
                if array.count == 0 {
                    self.isMoreData = false
                }
            }
        }) { (error) in
            self.stopActivityIndicator()
            _ = UIAlertController(title: nil, message: error as? String, preferredStyle: .alert)
        }

    }
}
