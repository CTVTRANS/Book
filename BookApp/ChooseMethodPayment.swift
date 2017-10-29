//
//  ChooseMethodPayment.swift
//  BookApp
//
//  Created by kien le van on 10/12/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class ChooseMethodPayment: BaseDailog {

    @IBOutlet weak var iosPayView: UIView!
    @IBOutlet weak var androidPayView: UIView!
    @IBOutlet weak var heightOfAndroidView: NSLayoutConstraint!
    
    var callBackWeChat = {}
    var callBackAlipay = {}
    var callBackIOS = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iosPayView.layer.borderColor = UIColor.black.cgColor
        androidPayView.layer.borderColor = UIColor.black.cgColor
        androidPayView.layer.cornerRadius = heightOfAndroidView.constant / 2
    }
    
    @IBAction func tapScreeen(_ sender: Any) {
        self.hide()
    }
    
    @IBAction func pressedWeChat(_ sender: Any) {
        self.callBackWeChat()
    }
    
    @IBAction func pressedAlipay(_ sender: Any) {
        self.callBackAlipay()
    }
    
    @IBAction func pressedIOS(_ sender: Any) {
        self.callBackIOS()
    }
}
