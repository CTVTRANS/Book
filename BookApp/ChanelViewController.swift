//
//  ChanelViewController.swift
//  BookApp
//
//  Created by kien le van on 9/5/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import FSPagerView

class ChanelViewController: BaseViewController, FSPagerViewDelegate, FSPagerViewDataSource {

    @IBOutlet weak var navigationView: NavigationCustom!
    @IBOutlet weak var suggestChanel: CustomChanelCollection!
    var indicatorSuggest = UIView()
    @IBOutlet weak var freeChanel: CustomChanelCollection!
    var indicatorViewFree = UIView()
    var currentPageSuggest = 1
    var currentFree = 1
    
    private var listSlider: [SliderShow] = []
    @IBOutlet weak var pageControlView: FSPageControl! {
        didSet {
            self.pageControlView.transform = CGAffineTransform(rotationAngle: .pi/2)
            self.pageControlView.contentHorizontalAlignment = .center
            self.pageControlView.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }

    @IBOutlet weak var sliderShow: FSPagerView! {
        didSet {
            sliderShow.scrollDirection = .vertical
            self.sliderShow.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.sliderShow.itemSize = .zero
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivity(inView: self.view)
        callBack()
        setupCallBackNavigation()
        suggestChanel.name.text = "热门老师"
        freeChanel.name.text = "猜你喜欢"
        getBaner()
        getData()
        
        let getChaelSubcrible: GetAllChanelSubcribledTask =
            GetAllChanelSubcribledTask(memberID: (memberInstance?.idMember)!)
        requestWithTask(task: getChaelSubcrible, success: { (_) in
            
        }) { (error) in
            _ = UIAlertController(title: nil, message: error as? String, preferredStyle: .alert)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationView.checkNotifocation()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: Get Baner From Server
    
    func getBaner() {
        let getBanerTask = GetSliderBanerTask(typeSlider: ScreenShow.chanel.rawValue)
        requestWithTask(task: getBanerTask, success: { (data) in
            if let listBaner = data as? [SliderShow] {
                self.listSlider = listBaner
                self.pageControlView.numberOfPages = self.listSlider.count
                self.sliderShow.reloadData()
                self.stopActivityIndicator()
            }
        }) { (_) in
            self.stopActivityIndicator()
        }
    }
    
    func getData() {
        indicatorSuggest.showActivity(inView: suggestChanel)
        let getChanelSuggest: GetChanelSuggestTask =
            GetChanelSuggestTask(lang: Constants.sharedInstance.language,
                                 limit: 3,
                                 page: currentPageSuggest)
        requestWithTask(task: getChanelSuggest, success: { [weak self] (data) in
            if let suggestArray = data as? [Chanel] {
                self?.currentPageSuggest += 1
                self?.suggestChanel.reloadChanel(arrayChanel: suggestArray)
                self?.indicatorSuggest.stopActivityIndicator()
            }
        }) { (error) in
            self.indicatorSuggest.stopActivityIndicator()
            _ = UIAlertController(title: nil, message: error as? String, preferredStyle: .alert)
        }
        
        indicatorViewFree.showActivity(inView: freeChanel)
        let getFreeChanel: GetChanelFreeTask =
            GetChanelFreeTask(lang: Constants.sharedInstance.language,
                              limit: 3,
                              page: currentFree)
        requestWithTask(task: getFreeChanel, success: { [weak self] (data) in
            if let freeArray = data as? [Chanel] {
                self?.currentFree += 1
                self?.freeChanel.reloadChanel(arrayChanel: freeArray)
                self?.indicatorViewFree.stopActivityIndicator()
            }
        }) { (error) in
            self.indicatorSuggest.stopActivityIndicator()
            _ = UIAlertController(title: nil, message: error as? String, preferredStyle: .alert)
        }
    }
    
    // MARK: FSPagerView Data Source
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return listSlider.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = sliderShow.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.sd_setImage(with: URL(string:listSlider[index].imageURL))
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
        self.pageControlView.currentPage = pagerView.currentIndex
    }
    
    // MARK: Call Back
    
    func callBack() {
        let teacherStoryboard = UIStoryboard(name: "Chanel", bundle: nil)
        suggestChanel.callBackClickCell = {[weak self] (chanelSelected: Chanel) in
            if let detailTeacherVC = teacherStoryboard.instantiateViewController(withIdentifier: "DetailChanelViewController") as? DetailChanelViewController {
                detailTeacherVC.chanel = chanelSelected
                self?.navigationController?.pushViewController(detailTeacherVC, animated: true)
            }
        }
        
        freeChanel.callBackClickCell = {[weak self] (chanelSelected: Chanel) in
            if let detailTeacherVC = teacherStoryboard.instantiateViewController(withIdentifier: "DetailChanelViewController") as? DetailChanelViewController {
                detailTeacherVC.chanel = chanelSelected
                self?.navigationController?.pushViewController(detailTeacherVC, animated: true)
            }
        }
    }
    
    func checkNotifocationApp() {
        navigationView.checkNotifocation()
    }
    
    // MARK: Button Control
   
    func setupCallBackNavigation() {
        NotificationCenter.default.addObserver(self, selector: #selector(checkNotifocationApp), name: NSNotification.Name(rawValue: "reciveNotificaton"), object: nil)
        navigationView.callBackTopButton = { [weak self] (typeButton: TopButton) in
            switch typeButton {
            case TopButton.messageNotification:
                if !(self?.checkLogin())! {
                    self?.goToSigIn()
                    return
                }
                self?.goToNotification(myViewController: self!)
            case TopButton.videoNotification:
               self?.goToListPlayaudio()
            case TopButton.search:
                self?.goToSearch()
            }
        }
    }
    
    @IBAction func showHotChanel(_ sender: Any) {
        let chanelStoryboard = UIStoryboard(name: "Chanel", bundle: nil)
        if let vc = chanelStoryboard.instantiateViewController(withIdentifier: "ChanelHotController") as? ChanelHotController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func showSubcribeed(_ sender: Any) {
        let chanelStoryboard = UIStoryboard(name: "Chanel", bundle: nil)
        if let controller = chanelStoryboard.instantiateViewController(withIdentifier: "ChanelSubscribeController") as? ChanelSubscribeController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func loadMore(_ sender: Any) {
        
        getData()
    }
}
