//
//  ConfirmBinViewController.swift
//  BookApp
//
//  Created by kien le van on 10/14/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class ConfirmBinViewController: BaseViewController, UITextFieldDelegate {
    @IBOutlet weak var nameProduct: UILabel!
    @IBOutlet weak var imageProduct: UIImageView!

    @IBOutlet weak var methodPay: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var nameCustom: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    var book: Book?
    var nameBook: String?
    var methodPayment: String?
    var point: Int?
    var money: Int?
    @IBOutlet weak var contrainKeyBoard: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        address.delegate = self
        nameCustom.delegate = self
        phone.delegate = self
        phone.keyboardType = .numberPad
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "確認訂單"
    }
    
    func setupUI() {
        nameProduct.text = nameBook
        methodPay.text = methodPayment
        imageProduct.sd_setImage(with: URL(string: (book?.imageURL)!))
        address.text = PeoleReciveProduct.sharedInstance.adress
        nameCustom.text = PeoleReciveProduct.sharedInstance.name
        phone.text = String(PeoleReciveProduct.sharedInstance.phone!)
        total.text = methodPayment
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func pressedCorfimBin(_ sender: Any) {
        goToPayment()
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                contrainKeyBoard.constant = 16
            } else {
                contrainKeyBoard.constant = 16 - (endFrame?.size.height)! + 80
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}
