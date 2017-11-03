//
//  MarkViewController.swift
//  BookApp
//
//  Created by kien le van on 9/13/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class StoreMarkViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collection: UICollectionView!
    private var listSlieShow: [SliderShow] = []
    private var listProduct: [AnyObject] = []
    
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.backgroundColor = UIColor.white
        refresh.tintColor = UIColor.gray
        refresh.addTarget(self, action: #selector(reloadMyData), for: .valueChanged)
        return refresh
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivity(inView: self.view)
        navigationItem.title = "积分商城"
        collection.register(UINib.init(nibName: "StoreMarkViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        collection.addSubview(refreshControl)
        getBaner()
        getProduct()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func reloadMyData() {
        listProduct.removeAll()
        collection.reloadData()
        getProduct()
    }
    
    // MARK: Get Baner
    
    func getBaner() {
        let getBanerTask = GetSliderBanerTask(typeSlider: ScreenShow.buyProduct.rawValue)
        requestWithTask(task: getBanerTask, success: { (data) in
            if let listBaner = data as? [SliderShow] {
                self.listSlieShow = listBaner
                self.collection.reloadData()
            }
        }) { (_) in
            self.stopActivityIndicator()
        }
    }
    
    // MARK: Get List Product
    
    func getProduct() {
        let getAllproduct: GetAllproductTask = GetAllproductTask(limit: 20, page: 1)
        let getProductVip: GetProductVipTask = GetProductVipTask()
        requestWithTask(task: getProductVip, success: { (data) in
            if let arrayVip = data as? [Vip] {
                self.listProduct = arrayVip
                self.getProductBookWith(task: getAllproduct)
            }
        }, failure: { (_) in
            self.stopActivityIndicator()
        })
    }

    func getProductBookWith(task: BaseTaskNetwork) {
        requestWithTask(task: task, success: { (data) in
            if let list = data as? [Book] {
                for book in list {
                    self.listProduct.append(book)
                }
                self.collection.reloadData()
                self.stopActivityIndicator()
                self.refreshControl.endRefreshing()
            }
        }, failure: { (_) in
            self.stopActivityIndicator()
        })
    }

    // MARK: Collection Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? StoreMarkViewCell {
            cell.binData(product: listProduct[indexPath.row], type: TypeProductRequest.all)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthCell = (widthScreen - 36) / 2
        return CGSize(width: widthCell, height: widthCell + 20.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            if let header = collection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCollectionReusableView", for: indexPath) as? HeaderCollectionReusableView {
                header.binData(listBaner: listSlieShow)
                return header
            }
            return UICollectionReusableView()
        default:
            return UICollectionReusableView()
        }
    }
    
    // MARK: Collection Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "BuyProductViewController") as? BuyProductViewController {
            vc.product = listProduct[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Button Control
    
    @IBAction func pressedShowAllButton(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailStoreMarkController") as? DetailStoreMarkController {
            vc.typeRequest = TypeProductRequest.all
            vc.navigationTitle = "所有商品"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func pressedShowMarkButton(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailStoreMarkController") as? DetailStoreMarkController {
            vc.typeRequest = TypeProductRequest.point
            vc.navigationTitle = "纯积分"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func pressedShowMarkAndMoney(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailStoreMarkController") as? DetailStoreMarkController {
            vc.typeRequest = TypeProductRequest.pointAndMoney
            vc.navigationTitle = "积分+现金"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func pressedShowHistoryBuy(_ sender: Any) {
        let mayStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = mayStoryboard.instantiateViewController(withIdentifier: "HistoryBuyProductController")
        navigationController?.pushViewController(vc, animated: true)
    }
}
