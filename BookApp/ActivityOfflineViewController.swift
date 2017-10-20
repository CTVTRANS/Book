//
//  ActivityOfflineViewController.swift
//  BookApp
//
//  Created by kien le van on 9/8/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import FSPagerView

class ActivityOfflineViewController: BaseViewController, FSPagerViewDataSource, FSPagerViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var addGroupButton: UIButton!
    private var listSlider: [SliderShow] = []
    private var arrayNewsGroup: [NewsInGroups] = []
    
    @IBOutlet weak var sliderShow: FSPagerView! {
        didSet {
            self.sliderShow.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.sliderShow.itemSize = .zero
        }
    }
    
    @IBOutlet weak var pageControlView: FSPageControl! {
        didSet {
            self.pageControlView.contentHorizontalAlignment = .center
            self.pageControlView.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGroupButton.layer.borderColor = UIColor.rgb(255, 102, 0).cgColor
        navigationItem.title = "線下活動"
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "分會圈子",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(pressRighBarButton))
        getBaner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        getNews()
    }
    
    // MARK: Get Baner From Server
    
    func getBaner() {
        let getBanerTask = GetSliderBanerTask(typeSlider: ScreenShow.group.rawValue)
        requestWithTask(task: getBanerTask, success: { (data) in
            if let listBaner = data as? [SliderShow] {
                self.listSlider = listBaner
                self.pageControlView.numberOfPages = self.listSlider.count
                self.sliderShow.reloadData()
            }
        }) { (_) in
            
        }
    }
    
    func getNews() {
        let getNewsTask = GetListNewsForAllGroupTask(memberID: (memberInstance?.idMember)!)
        requestWithTask(task: getNewsTask, success: { (data) in
            if let array = data as? [NewsInGroups] {
                self.arrayNewsGroup = array
                self.table.reloadData()
            }
        }) { (_) in
            
        }
    }
    
    // MARK: FSPagerView Data Source
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return listSlider.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = sliderShow.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.sd_setImage(with: URL(string:listSlider[index].imageURL), completed: { (_, _, _, _) in
        })
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        return cell
    }
    
    // MARK: FSPagerView Delegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        sliderShow.deselectItem(at: index, animated: true)
        sliderShow.scrollToItem(at: index, animated: true)
        self.pageControlView.currentPage = index
        let urlString = listSlider[index].linkBaner
        if let url = URL(string: urlString!) {
            UIApplication.shared.openURL(url)
        }
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard self.pageControlView.currentPage != pagerView.currentIndex else {
            return
        }
        self.pageControlView.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
    }
    
    // MARK: Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayNewsGroup.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NewsForAllGroup
        cell?.binData(news: arrayNewsGroup[indexPath.row])
        return cell!
    }
    
    // MARK: Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailSingleNewsForGroupController") as? DetailSingleNewsForGroupController {
            vc.news = arrayNewsGroup[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: Button Control

    func pressRighBarButton() {
        if !checkLogin() {
            goToSigIn()
            return
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "GroupJoinedViewController") as? GroupJoinedViewController
        navigationController?.pushViewController(vc!, animated: true)
    }

    @IBAction func pressedAddGroupButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ShowAllActivityGroupController") as? ShowAllActivityGroupController
        navigationController?.pushViewController(vc!, animated: true)
    }
}

class NewsForAllGroup: UITableViewCell {
    
    @IBOutlet weak var titleNews: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var nameGroup: UILabel!
    
    func binData(news: NewsInGroups) {
        titleNews.text = news.title
        dateTime.text = news.time.components(separatedBy: " ")[0]
        nameGroup.text = news.groupOwner.name
    }
}
