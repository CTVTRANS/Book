//
//  SiginViewController.swift
//  BookApp
//
//  Created by kien le van on 8/29/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var countryCode: UILabel!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var showAreCodeButton: UIButton!
    
    private var country: Int!
    private var phone: Int!
    private var pass: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backItem?.title = ""
        showAreCodeButton.layer.borderColor = UIColor.rgb(255, 101, 0).cgColor
        phoneNumber.delegate = self
        phoneNumber.keyboardType = .numberPad
        passWord.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func checkPhonePass() -> (ErrorCode) {
        phone = Int(phoneNumber.text!)
        pass = passWord.text
        country = Int(countryCode.text!)
        if phone == nil {
            return ErrorCode.numberPhoneEmty
        } else if pass == "" {
            return ErrorCode.passwordError
        }
        return ErrorCode.success
    }

    @IBAction func pressedDismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func pressLoginButton(_ sender: Any) {
        let status = checkPhonePass()
        if status != ErrorCode.success {
            UIAlertController.showAler(title: " ", message: status.decodeError(), inViewController: self)
        }
        self.view.endEditing(true)
        if status == ErrorCode.success {
            let sigIn = SignInTaks(countryCode: country, phoneNumerber: phone, password: pass)
            requestWithTask(task: sigIn, success: { (data) in
                if let status = data as? ErrorCode {
                    if status == ErrorCode.success {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }, failure: { (_) in
                
            })
        }
    }
    
    @IBAction func pressedPhoneCountryCode(_ sender: Any) {
        let country = ListCountryView.instance() as? ListCountryView
        country?.callBack = { [unowned self] code in
            self.countryCode.text = "+" + code
        }
        country?.show()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
