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
            point1.text = String(book.priceMix[0].point) + " 積分 ＋ " + String(book.priceMix[0].mooney) + " 現金"
            point2.text = String(book.priceMix[1].point) + " 積分 ＋ " + String(book.priceMix[1].mooney) + " 現金"
            if book.typePay == "point" || book.price != 0 {
                titleProduct.text = "[積] " + book.name
                nameproduct = "[積] " + book.name
                numberMark.text = String(book.price!) + " 積分"
            } else {
                titleProduct.text = "[現] " + book.name
                nameproduct = "[現] " + book.name
                numberMark.text = String(book.priceMix[0].point) + " 積分 ＋ " + String(book.priceMix[0].mooney) + " 現金"
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
            titleProduct.text = "[現] " + vip.title
            numberMark.text = String(vip.price) + " 現金"
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
        if product as? Vip != nil {
            goToPayment()
            return
        }
        if PeoleReciveProduct.sharedInstance.phone == nil {
            _ = UIAlertController.initAler(title: "", message: "Please fill information recipient", inViewController: self)
        } else {
            if numberMark.text?.range(of: " 積分") != nil {
                let array = numberMark.text?.components(separatedBy: " 積分")
                let numberPoint = Int((array?.first)!)
                if numberPoint! > (memberInstance?.point)! {
                    _ = UIAlertController.initAler(title: "", message: "You haven't enought Point", inViewController: self)
                    return
                }
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
