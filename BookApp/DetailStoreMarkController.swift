//
//  DetailStoreMarkController.swift
//  BookApp
//
//  Created by kien le van on 9/13/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class DetailStoreMarkController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collection: UICollectionView!
    
    private var pager = 1
    private var isMoreData = true
    private var isLoading = false
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.backgroundColor = UIColor.white
        refresh.tintColor = UIColor.gray
        refresh.addTarget(self, action: #selector(reloadMyData), for: .valueChanged)
        return refresh
    }()
    var footerView: FooterLoadMoreReusableView?
    private var indicator: UIActivityIndicatorView?
    
    var navigationTitle: String?
    var typeRequest: TypeProductRequest!
    private var listProduct: [AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivity(inView: self.view)
        navigationItem.title = navigationTitle
        collection.register(UINib.init(nibName: "StoreMarkViewCell", bundle: nil), forCellWithReuseIdentifier: "cell2")
        collection.addSubview(refreshControl)
        loadMore()
    }
    
    @objc func reloadMyData() {
        listProduct.removeAll()
        collection.reloadData()
        pager = 1
        isMoreData = true
        loadMore()
    }
    
    func getProductBookWith(task: BaseTaskNetwork) {
        requestWithTask(task: task, success: { (data) in
            if let list = data as? [Book] {
                for book in list {
                    self.listProduct.append(book)
                }
                self.pager += 1
                self.isLoading = false
                self.footerView?.stopAnimate()
                self.stopActivityIndicator()
                self.refreshControl.endRefreshing()
                self.collection.reloadData()
            }
        }, failure: { (error) in
            self.stopActivityIndicator()
            UIAlertController.showAler(title: "", message: error!, inViewController: self)
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: Collection Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as? StoreMarkViewCell {
        cell.binData(product: listProduct[indexPath.row], type: typeRequest)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isLoading {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.size.width, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionFooter:
            if let footer = collection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterLoadMoreReusableView", for: indexPath) as? FooterLoadMoreReusableView {
                footerView = footer
                return footer
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionElementKindSectionFooter {
            footerView?.prepareInitialAnimation()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionElementKindSectionFooter {
            footerView?.stopAnimate()
        }
    }
    
    // MARK: Load More
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold = 100.0
        let contentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let diffHeight = contentHeight - contentOffset
        let frameHeight = scrollView.bounds.size.height
        var triggerThreshold  = Float((diffHeight - frameHeight))/Float(threshold)
        triggerThreshold   =  min(triggerThreshold, 0.0)
        let pullRatio = min(fabs(triggerThreshold), 1.0)
        self.footerView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
        if pullRatio >= 1 {
            self.footerView?.animateFinal()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let diffHeight = contentHeight - contentOffset
        let frameHeight = scrollView.bounds.size.height
        let pullHeight  = fabs(diffHeight - frameHeight)
        if pullHeight == 0.0 {
            if (self.footerView?.isAnimatingFinal)! {
                self.isLoading = true
                self.footerView?.startAnimate()
                loadMore()
            }
        }
    }
    
    func loadMore() {
        let getAllproduct: GetAllproductTask = GetAllproductTask(limit: 30, page: pager)
        let getProductByPoint: GetListProductByPointTask = GetListProductByPointTask(limit: 30, page: pager)
        let getproductByPointAndMoney: GetListProductByPointAndMoneyTask = GetListProductByPointAndMoneyTask(limit: 30, page: pager)
        if typeRequest == TypeProductRequest.all {
            if pager > 1 {
                self.getProductBookWith(task: getAllproduct)
                return
            }
            let getProductVip: GetProductVipTask = GetProductVipTask()
            requestWithTask(task: getProductVip, success: { (data) in
                if let arrayVip = data as? [Vip] {
                    self.listProduct = arrayVip
                    self.getProductBookWith(task: getAllproduct)
                }
            }, failure: { (_) in
                
            })
        } else if typeRequest == TypeProductRequest.point {
            getProductBookWith(task: getProductByPoint)
        } else {
            getProductBookWith(task: getproductByPointAndMoney)
        }
    }
}
