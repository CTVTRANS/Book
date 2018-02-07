//
//  BuyVipMarkViewController.swift
//  BookApp
//
//  Created by le kien on 2/2/18.
//

import UIKit

class BuyVipMoneyViewController: BaseViewController {

    @IBOutlet weak var detail: UIWebView!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var name: UILabel!
    var vip: Vip!
    var numberYear = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detail.delegate = self
        name.text = memberInstance?.name
        money.text = vip.price.description
        detail.loadHTMLString(vip.conten, baseURL: nil)
        navigationItem.title = "buy vip now".localized
    }
    @IBAction func minusPress(_ sender: Any) {
        if numberYear > 1 {
            numberYear -= 1
        }
        year.text = numberYear.description
        money.text = (vip.price * Float(numberYear)).description
    }
    
    @IBAction func addPress(_ sender: Any) {
        if numberYear < 3 {
           numberYear += 1
        }
        year.text = numberYear.description
        money.text = (vip.price * Float(numberYear)).description
    }
    
    @IBAction func pressBuy(_ sender: Any) {
        let getBinVip = BuyVipTask(memberiD: (memberInstance?.idMember)!, token: tokenInstance!, type: 1, idVip: vip.idVip, numberYear: numberYear)
        requestWithTask(task: getBinVip, success: { (response) in
            guard let data = response as? (String, String) else {
                return
            }
            let orderID = data.0
            let signInfo = data.1
            self.goToPayment(withSubject: "VIP",
                             body: "Buy Vip",
                             orderID: orderID,
                             urlNotice: urlNotificationVip,
                             optionalPayment: signInfo,
                             andPrice: self.vip.price.description, copmleted: {
                UIAlertController.showAler(title: "", message: "success!".localized, inViewController: self)
            })
            return
        }, failure: { (error) in
            UIAlertController.showAler(title: "", message: error!, inViewController: self)
            return
        })
    }
}

extension BuyVipMoneyViewController: UIWebViewDelegate {

}
