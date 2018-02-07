//
//  BuyProductViewController.swift
//  BookApp
//
//  Created by kien le van on 9/13/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class BuyProductViewController: BaseViewController, UIWebViewDelegate {
    
    @IBOutlet weak var contrainForScroll: NSLayoutConstraint!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var statusTranfer: UILabel!
    @IBOutlet weak var numberMark: UILabel!
    @IBOutlet weak var titleProduct: UILabel!
    @IBOutlet weak var buyButtonCase1: UIButton!
    @IBOutlet weak var buyButtonCase2: UIButton!
    
    @IBOutlet weak var point1: UILabel!
    @IBOutlet weak var point2: UILabel!
    @IBOutlet weak var detailBody: UIWebView!
    @IBOutlet weak var heightOfWebView: NSLayoutConstraint!
    
    @IBOutlet weak var view1234: UIView!
    @IBOutlet weak var adressView: UIView!
    
    var product: AnyObject?
    private var nameproduct: String?
    private var bookProduct: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buyButtonCase1.layer.borderColor = UIColor.rgb(255, 102, 0).cgColor
        buyButtonCase2.layer.borderColor = UIColor.rgb(255, 102, 0).cgColor
        navigationItem.title = ""
        detailBody.delegate = self
        if let book = product as? Book {
            bookProduct = book
            imageProduct.sd_setImage(with: URL(string: book.imageURL), placeholderImage: #imageLiteral(resourceName: "place_holder"))
            point1.text = String(book.priceMix[0].point) + "Point".localized + " + \(String(book.priceMix[0].mooney)) " + "Money".localized
            point2.text = String(book.priceMix[1].point) + "Point".localized + " + \(String(book.priceMix[1].mooney)) " + "Money".localized
            if book.typePay == "point" || book.price != 0 {
                titleProduct.text = "[积] " + book.name
                nameproduct = "[积] " + book.name
                numberMark.text = String(book.price!) + "Point".localized
            } else {
                titleProduct.text = "[现] " + book.name
                nameproduct = "[现] " + book.name
                numberMark.text = String(book.priceMix[0].point) + "Point".localized + " + \(String(book.priceMix[0].mooney)) " + "Money".localized
                point1.removeFromSuperview()
                buyButtonCase1.removeFromSuperview()
            }
            detailBody.loadHTMLString(css + book.descriptionBook, baseURL: nil)
        }
        if let vip = product as? Vip {
            adressView.removeFromSuperview()
            view1234.removeFromSuperview()
            contrainForScroll.constant = 12
            point1.removeFromSuperview()
            buyButtonCase1.removeFromSuperview()
            point2.removeFromSuperview()
            buyButtonCase2.removeFromSuperview()

            imageProduct.sd_setImage(with: URL(string: vip.imageURL), placeholderImage: #imageLiteral(resourceName: "place_holder"))
            titleProduct.text = "[现] " + vip.title
            numberMark.text = String(vip.price) + "Money".localized
            detailBody.loadHTMLString(css + vip.conten, baseURL: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.isNavigationBarHidden = false
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let heightnew = detailBody.scrollView.contentSize.height
        heightOfWebView.constant = heightnew
    }
    
    @IBAction func pressedBuyButtonCase1(_ sender: Any) {
        let point = numberMark.text
        numberMark.text = point1.text
        point1.text = point

    }
    
    @IBAction func pressedBuyButtonCase2(_ sender: Any) {
        let point = numberMark.text
        numberMark.text = point2.text
        point2.text = point
    }

    @IBAction func pressedEditInfomationBin(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailBinController") as? DetailBinController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func pressBuy(_ sender: Any) {
        if !checkLogin() {
            goToSigIn()
            return
        }
        if let vipProduct = product as? Vip {
            buyVipPoint(vip: vipProduct)
            return
        }
        if PeoleReciveProduct.sharedInstance.phone == nil {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailBinController") as? DetailBinController {
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            if numberMark.text?.range(of: "Point".localized) != nil, numberMark.text?.range(of: "Money".localized) == nil {
                let array = numberMark.text?.components(separatedBy: "Point".localized)
                if let numberPoint = Int((array?.first)!) {
                    if numberPoint > (memberInstance?.point)! {
                        UIAlertController.showAler(title: "", message: "not enough point".localized, inViewController: self)
                        return
                    }
                    oderBook(with: numberPoint)
                }
                return
            }
            
            if let vc = storyboard?.instantiateViewController(withIdentifier: "ConfirmBinViewController") as? ConfirmBinViewController {
                vc.nameBook = nameproduct
                vc.book = bookProduct
                vc.methodPayment = numberMark.text
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension BuyProductViewController {
    func oderBook(with point: Int) {
        let oderBin = BuyBookTask(idMember: (memberInstance?.idMember)!, token: tokenInstance!, bookID: (bookProduct?.idBook)!, nameUser: PeoleReciveProduct.sharedInstance.name!, phone: PeoleReciveProduct.sharedInstance.phone!, address: PeoleReciveProduct.sharedInstance.adress!)
        requestWithTask(task: oderBin, success: { (response) in
            if let status = response as? ErrorCode, status == ErrorCode.success {
                self.memberInstance?.point -= point
                ProfileMember.saveProfile(myProfile: self.memberInstance!)
                UIAlertController.showAler(title: "", message: "success!".localized, inViewController: self)
            }
        }) { (error) in
            UIAlertController.showAler(title: "", message: error!, inViewController: self)
        }
    }
    
    func buyVipPoint(vip: Vip) {
        if (memberInstance?.point)! > vip.point {
            let buyVip = BuyVipTask(memberiD: (memberInstance?.idMember)!, token: tokenInstance!, type: 0, idVip: vip.idVip, numberYear: 1)
            requestWithTask(task: buyVip, success: { (data) in
                if let status = data as? (Bool, ErrorCode) {
                    if status.0 {
                        self.memberInstance?.point -= vip.point
                        UIAlertController.showAler(title: "", message: "success!".localized, inViewController: self)
                        return
                    }
                    UIAlertController.showAler(title: "", message: status.1.decodeError(), inViewController: self)
                }
            }, failure: { (_) in
                
            })
        }
    }
}
