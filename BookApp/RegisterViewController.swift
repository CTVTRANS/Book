//
//  RegisterViewController.swift
//  BookApp
//
//  Created by kien le van on 8/29/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var titleForbutton: UILabel!
    @IBOutlet weak var sendCodebutton: UIButton!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var showAreButton: UIButton!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var code: UITextField!
    @IBOutlet weak var nameUser: UITextField!
    @IBOutlet weak var passWord: UITextField!
    
    private var countryPhone: Int?
    private var phone: Int?
    private var codeConfirm: Int?
    private var name: String?
    private var pass: String?
    private var counter = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "注册"
        navigationController?.navigationBar.backItem?.title = ""
        showAreButton.layer.borderColor = UIColor.rgb(255, 102, 0).cgColor
        sendCodebutton.layer.borderColor = UIColor.rgb(255, 102, 0).cgColor
        code.keyboardType = .numberPad
        phoneNumber.keyboardType = .numberPad
        code.delegate = self
        phoneNumber.delegate = self
        nameUser.delegate = self
        passWord.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func checkValidate() -> (ErrorCode) {
        countryPhone = Int(country.text!)
        phone = Int(phoneNumber.text!)
        codeConfirm = Int(code.text!)
        name = nameUser.text
        pass = passWord.text
        if phone == nil {
            return ErrorCode.numberPhoneEmty
        } else if codeConfirm == nil {
            return ErrorCode.confirmCodeEmty
        } else if codeConfirm == nil {
            return ErrorCode.confirmCodeEmty
        } else if name == "" {
            return ErrorCode.nameEmty
        } else if pass == "" {
            return ErrorCode.passwordEmty
        }
        let array = pass?.components(separatedBy: " ")
        if (array?.count)! > 1 {
            return ErrorCode.passwordHasSpace
        }
        return ErrorCode.success
    }

    @IBAction func pressedRegister(_ sender: Any) {
        let check = checkValidate()
        if check == ErrorCode.success {
            let register = RegisterTask(countryCode: countryPhone!, phoneNumber: phone!, codeConfirm: codeConfirm!, name: name!, password: pass!)
            requestWithTask(task: register, success: { (data) in
                if let status = data as? ErrorCode {
                    let action = UIAlertAction(title: "确认", style: .default, handler: { (_) in
                        if status == ErrorCode.success {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    })
                    let alert = UIAlertController.init(title: "", message: status.decodeError(), preferredStyle: .alert)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }, failure: { (_) in
                
            })
        } else {
            UIAlertController.showAler(title: "", message: check.decodeError(), inViewController: self)
        }
    }

    @IBAction func showListCountry(_ sender: Any) {
        let vc = ListCountryView.instance() as? ListCountryView
        vc?.callBack = { [unowned self] codeCountry in
            self.country.text = codeCountry
        }
        vc?.show()
    }
    
    @IBAction func pressedSencode(_ sender: Any) {
        countryPhone = Int(country.text!)
        phone = Int(phoneNumber.text!)
        if phone == nil {
            UIAlertController.showAler(title: "", message: ErrorCode.numberPhoneEmty.decodeError(), inViewController: self)
            return
        }
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer(timer:)), userInfo: nil, repeats: true)
        sendCodebutton.isEnabled = false
        let sendCode = GetCodeConfirmTask(countryCode: countryPhone!, phoneNumber: phone!)
        requestWithTask(task: sendCode, success: { (data) in
            if let message = data as? [String: Any] {
                print(message)
            }
        }) { (_) in
        
        }
    }
    
    @objc func updateTimer(timer: Timer) {
        counter -= 1
        titleForbutton.text = "获取验证码" + "(\(counter)s)" + "  "
        if counter <= 0 {
            titleForbutton.text = "获取验证码  "
            timer.invalidate()
            counter = 60
            sendCodebutton.isEnabled = true
        }
    }
    
    @IBAction func pressedShowAgreement(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AgreementsViewController") as? AgreementsViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
