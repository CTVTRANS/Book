//
//  BookViewController.swift
//  BookApp
//
//  Created by Le Cong on 8/12/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import SDWebImage
import FSPagerView

class BookViewController: BaseViewController {

    @IBOutlet weak var viewForNewestBook: UIView!
    @IBOutlet weak var navigationCustom: NavigationCustom!
    @IBOutlet weak var tableBookType: UICollectionView!
    @IBOutlet weak var suggestBookView: CustomBookCollection!
    @IBOutlet weak var freeBookView: CustomBookCollection!
    @IBOutlet weak var newestBookImage: UIImageView!
    @IBOutlet weak var newestBooktype: UILabel!
    @IBOutlet weak var newestBookName: UILabel!
    @IBOutlet weak var newestBookDescription: UILabel!
    @IBOutlet weak var newestBookTimeUp: UILabel!
    @IBOutlet weak var newestBookNumberView: UILabel!
    
    var bookTypeArray = [MenuType]()
    var suggestArray = [Book]()
    var freeArray = [Book]()
    var  newestBook: Book!
    
    // MARK: Property Slider Show
    
    var listSlider: [SliderShow] = []
    @IBOutlet weak var sliderShow: FSPagerView! {
        didSet {
            self.sliderShow.scrollDirection = .vertical
            self.sliderShow.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.sliderShow.itemSize = .zero
        }
    }
    @IBOutlet weak var pageControlView: FSPageControl! {
        didSet {
            self.pageControlView.transform = CGAffineTransform(rotationAngle: .pi/2)
            self.pageControlView.contentHorizontalAlignment = .center
            self.pageControlView.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
        setupCallBackClickCell()
        setupCallBackNavigation()
        showActivity(inView: self.view)
        getBaner()
        getBookNewest()
        getBookSuggest()
        getBookFree()
        getTypeBook()
        MP3Player.shareIntanse.limitTime()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationCustom.checkNotifocation()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setUpTitle() {
        suggestBookView.setupView(image: #imageLiteral(resourceName: "ic_reload"))
        suggestBookView.detailTitle.text = "换一换"
        suggestBookView.titleView.text = "猜你喜欢"
        freeBookView.setupView(image: #imageLiteral(resourceName: "ic_next"))
        freeBookView.detailTitle.text = "全部"
        freeBookView.titleView.text = "限时免费"
    }
    
    // MARK: Call API
    
    func getBaner() {
        let getBanerTask = GetSliderBanerTask(typeSlider: ScreenShow.book.rawValue)
        requestWithTask(task: getBanerTask, success: { (data) in
            if let listBaner = data as? [SliderShow] {
                self.listSlider = listBaner
                self.pageControlView.numberOfPages = self.listSlider.count
                self.sliderShow.reloadData()
            }
        }) { (_) in
            
        }
    }
    
    func getTypeBook() {
        let getTypeTask: GetTypeOfBookTask = GetTypeOfBookTask()
        requestWithTask(task: getTypeTask, success: { (_) in
            self.bookTypeArray = Constants.sharedInstance.listBookType.filter({ (type) -> Bool in
                return type.parentID == 0
            })
            self.tableBookType.reloadData()
        }) { (error) in
            self.stopActivityIndicator()
            UIAlertController.showAler(title: "", message: (error as? String)!, inViewController: self)
        }
    }
    
    func getBookSuggest() {
        let getBookSuggest: GetAllBookSuggestTask = GetAllBookSuggestTask(limit: 3, page: 1)
        requestWithTask(task: getBookSuggest, success: { (data) in
            self.suggestBookView.reloadData(arrayOfBook: (data as? [Book])!)
        }) { (error) in
            self.stopActivityIndicator()
        }
    }
    
    func getBookFree() {
        let getBookFree: GetBookFreeTask = GetBookFreeTask(limit: 3, page: 1)
        requestWithTask(task: getBookFree, success: { (data) in
            self.freeBookView.reloadData(arrayOfBook: (data as? [Book])!)
        }) { (error) in
            self.stopActivityIndicator()
        }
    }
    
    func getBookNewest() {
        let getNewestBookTask: GetBookNewestTask = GetBookNewestTask(limit: 1)
        requestWithTask(task: getNewestBookTask, success: { (data) in
            if let news = data as? [Book] {
                if news.first != nil {
                    self.newestBook = news.first
                    self.newestBookImage.sd_setImage(with: URL(string: self.newestBook.imageURL), placeholderImage: #imageLiteral(resourceName: "place_holder"))
                    self.newestBooktype.text = " " + self.newestBook.typeName + " "
                    self.newestBookName.text = self.newestBook.name
                    self.newestBookDescription.text = self.newestBook.author
                    if self.newestBook.numberHumanReaed < 10000 {
                        self.newestBookNumberView.text = String(self.newestBook.numberHumanReaed)
                    } else {
                        let numberVew = self.newestBook.numberHumanReaed/10000
                        self.newestBookNumberView.text = String(numberVew) + "万"
                    }
                    let dateupBook = self.newestBook.timeUpBook.components(separatedBy: " ")
                    self.newestBookTimeUp.text = dateupBook[0]
                } else {
                    self.viewForNewestBook.isHidden = true
                }
                self.stopActivityIndicator()
            }
        }) { (error) in
            self.viewForNewestBook.isHidden = true
            self.stopActivityIndicator()
        }
    }
    
    // MARK: Call Back For CEll
    
    func setupCallBackClickCell() {
        let bookStoryboard = UIStoryboard(name: "Book", bundle: nil)
        suggestBookView.callBackClickCell = {[weak self] (bookSelected: Book) in
            let vc = bookStoryboard.instantiateViewController(withIdentifier: "BookDetail") as? BookDetailViewController
            vc?.bookSelected = bookSelected
            self?.navigationController?.pushViewController(vc!, animated: true)
        }
        suggestBookView.callBackReloadButton = { [weak self] in
            self?.showActivity(inView: (self?.suggestBookView)!)
            let getBookSuggest: GetAllBookSuggestTask = GetAllBookSuggestTask(limit: 3, page: 2)
            self?.requestWithTask(task: getBookSuggest, success: { (data) in
                self?.stopActivityIndicator()
                self?.suggestBookView.reloadData(arrayOfBook: (data as? [Book])!)
            }) { (error) in
                self?.stopActivityIndicator()
                UIAlertController.showAler(title: "", message: (error as? String)!, inViewController: self!)
            }
        }
        
        freeBookView.callBackClickCell = {[weak self] (bookSelected: Book) in
            let vc = bookStoryboard.instantiateViewController(withIdentifier: "BookDetail") as? BookDetailViewController
            vc?.bookSelected = bookSelected
            self?.navigationController?.pushViewController(vc!, animated: true)
        }
        freeBookView.callBackReloadButton = { [weak self] in
            let vc = bookStoryboard.instantiateViewController(withIdentifier: "ListBookFreeController") as? ListBookFreeController
            self?.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    // MARK: Button Controll
    
    @IBAction func pressedShowDetailBook(_ sender: Any) {
        let bookStoryboard = UIStoryboard(name: "Book", bundle: nil)
        let vc = bookStoryboard.instantiateViewController(withIdentifier: "BookDetail") as? BookDetailViewController
        vc?.bookSelected = newestBook
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    // MARK: Call Back Navigation
    
    @objc func checkNotifocationApp() {
        navigationCustom.checkNotifocation()
    }
    
    func setupCallBackNavigation() {
         NotificationCenter.default.addObserver(self, selector: #selector(checkNotifocationApp), name: NSNotification.Name(rawValue: "reciveNotificaton"), object: nil)
        navigationCustom.callBackTopButton = { [weak self] (typeButton: TopButton) in
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
}

extension BookViewController: FSPagerViewDelegate, FSPagerViewDataSource {
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
        self.pageControlView.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
    }
}

extension BookViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: CollectionView Data Souce
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookTypeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tableBookType.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? BookTypeViewCell
        cell?.binData(typeBook: bookTypeArray[indexPath.row])
        return cell!
    }
    
    // MARK: CollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let myStoryboard = UIStoryboard(name: "Book", bundle: nil)
        if let vc = myStoryboard.instantiateViewController(withIdentifier: "SingleTypeBookController") as? SingleTypeBookController {
            vc.typeID = bookTypeArray[indexPath.row].typeID
            vc.indexpath = indexPath
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
