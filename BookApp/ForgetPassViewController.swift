//
//  ForgetPassViewController.swift
//  BookApp
//
//  Created by kien le van on 8/29/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class ForgetPassViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var showAreButton: UIButton!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var code: UITextField!
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
    @IBOutlet weak var titleButtonSendCode: UILabel!
    @IBOutlet weak var buttonSendCode: UIButton!
    
    private var countryPhone: Int?
    private var phone: Int?
    private var codeConfirm: Int?
    private var newPassWord: String?
    private var confirmNewpass: String?
    private var counter = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "忘記密碼"
        buttonSendCode.layer.borderColor = UIColor.rgb(255, 101, 0).cgColor
        showAreButton.layer.borderColor = UIColor.rgb(255, 101, 0).cgColor
        phoneNumber.keyboardType = .numberPad
        code.keyboardType = .numberPad
        newPass.delegate = self
        confirmPass.delegate = self
    }
    
    func checkValidate() -> (Bool, String) {
        countryPhone = Int(country.text!)
        phone = Int(phoneNumber.text!)
        codeConfirm = Int(code.text!)
        newPassWord = newPass.text
        confirmNewpass = confirmPass.text
        if phone == nil || codeConfirm == nil || newPassWord == nil || confirmNewpass == nil {
            return (false, "please fill full information")
        }
        let array = newPassWord?.components(separatedBy: " ")
        if (array?.count)! > 1 {
            return (false, "password cant not has sparce")
        }
        return (true, "success")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func pressedShowAreCdoe(_ sender: Any) {
        let vc = ListCountryView.instance() as? ListCountryView
        vc?.callBack = { [weak self] codeCountry in
            self?.country.text = codeCountry
        }
        vc?.show()
    }
    @IBAction func pressedSendCode(_ sender: Any) {
        countryPhone = Int(country.text!)
        phone = Int(phoneNumber.text!)
        if phone == nil {
            _ = UIAlertController.initAler(title: "", message: "please fill phone number", inViewController: self)
            return
        }
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer(timer:)), userInfo: nil, repeats: true)
        buttonSendCode.isEnabled = false
        let sendCode = GetCodeConfirmTask(countryCode: countryPhone!, phoneNumber: phone!)
        requestWithTask(task: sendCode, success: { (data) in
            if let message = data as? [String: Any] {
                print(message)
            }
        }) { (_) in
        
        }
    }
    
    @IBAction func pressedChangePass(_ sender: Any) {
        let check = checkValidate()
        if !check.0 {
            _ = UIAlertController.initAler(title: "", message: check.1, inViewController: self)
        } else {
            let forgotPass = ForgetPasswordTask(country: countryPhone!,
                                                phone: phone!,
                                                code: codeConfirm!,
                                                newPass: newPassWord!,
                                                confirmPass: confirmNewpass!)
            requestWithTask(task: forgotPass, success: { (data) in
                if let status = data as? (Bool, ErrorCode) {
                    let action = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                        if status.0 {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    })
                    let alert = UIAlertController.init(title: "", message: status.1.decodeError(), preferredStyle: .alert)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }, failure: { (_) in
                
            })
        }
    }
    
    func updateTimer(timer: Timer) {
        counter -= 1
        titleButtonSendCode.text = "  SendCode" + "(\(counter)s)" + "  "
        if counter <= 0 {
            titleButtonSendCode.text = "  SendCode  "
            timer.invalidate()
            counter = 60
            buttonSendCode.isEnabled = true
        }
    }
}
