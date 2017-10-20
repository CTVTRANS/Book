//
//  ChangeProfileViewController.swift
//  BookApp
//
//  Created by kien le van on 9/14/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

enum TypeView: Int {
    case name = 0, email, pass, information
}

enum StatusMarrige: Int {
    case sucurity = 0, single, married
}

enum Sex: Int {
    case female = 0, male, sucurity
}

class ChangeProfileViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var infomationView: UIView!
    @IBOutlet weak var passWordView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var oldPassTextField: UITextField!
    @IBOutlet weak var newPassTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var sex: UILabel!
    @IBOutlet weak var birthDay: UILabel!
    @IBOutlet weak var statusMarrie: UILabel!
    @IBOutlet weak var hobby: UITextField!
    @IBOutlet weak var occupation: UITextField!
    
    @IBOutlet weak var contrainName: NSLayoutConstraint!
    @IBOutlet weak var contrainEmail: NSLayoutConstraint!
    @IBOutlet weak var contrainPass: NSLayoutConstraint!
    
    // MARK: Property
    var typeViewShow: TypeView = TypeView(rawValue: 0)!
    private var sexMember: Int = Sex.sucurity.rawValue
    private var statusMarrigeMember = StatusMarrige.sucurity.rawValue
    private var nameMember: String!
    private var emailMember: String!
    private var birthDayMember: String!
    private var jobMember: String!
    private var hobbyMember: String!
    
    var changePass = false
    private var oldPassMember: String?
    private var newPassMember: String?
    private var confirmPassMember: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
        setupSexAndMarried()
        infomationView.isHidden = true
        passWordView.isHidden = true
        emailView.isHidden = true
        userNameView.isHidden = true
        showView(tyepViewNeedShow: typeViewShow)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        let rightButton = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(saveInfomation))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    func setupKeyboard() {
        userNameTextField.delegate = self
        emailTextField.delegate = self
        emailTextField.keyboardType = .emailAddress
        occupation.delegate = self
        hobby.delegate = self
        userNameTextField.text = memberInstance?.name
        emailTextField.text = memberInstance?.email
        birthDay.text = memberInstance?.dateOfBirth
        hobby.text = memberInstance?.hobby
        occupation.text = memberInstance?.job
    }
    
    func setupSexAndMarried() {
        let sexType: Int = (memberInstance?.sex!)!
        switch sexType {
        case 0:
            sex.text = "女"
        case 1:
            sex.text = "男"
        case 2:
            sex.text = "性別"
        default:
            break
        }
        
        let marrigeType: Int = (memberInstance?.marriage!)!
        switch marrigeType {
        case 0:
            statusMarrie.text = "性別"
        case 1:
            statusMarrie.text = "未婚"
        case 2:
            statusMarrie.text = "已婚"
        default:
            break
        }
    }
    
    func showView(tyepViewNeedShow: TypeView) {
        switch tyepViewNeedShow {
        case .name:
            userNameView.isHidden = false
            contrainName.constant = 22
        case .email:
            emailView.isHidden = false
            contrainEmail.constant = 22
        case .pass:
            passWordView.isHidden = false
            contrainPass.constant = 22
        case .information:
            infomationView.isHidden = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func saveInfomation() {
        if !changePass {
            self.view.endEditing(true)
            self.nameMember = (userNameTextField.text != nil) ? userNameTextField.text : ""
            self.emailMember = (emailTextField.text != nil) ? emailTextField.text : ""
            self.birthDayMember = (birthDay.text != nil) ? birthDay.text : ""
            self.jobMember = (occupation.text != nil) ? occupation.text : ""
            self.hobbyMember = (hobby.text != nil) ? hobby.text: ""

            let change = UpdateMemberTask(memberID: memberInstance?.idMember, token: tokenInstance,
                                          nameMember: nameMember, email: emailMember,
                                          sex: sexMember, birthDay: birthDayMember,
                                          job: jobMember, status: statusMarrigeMember,
                                          hobby: hobbyMember)
            requestWithTask(task: change, success: { (_) in
                let updateInfo = GetProfileMemberTask(idMember: (self.memberInstance?.idMember)!)
                self.requestWithTask(task: updateInfo, success: { (_) in
                    _ = UIAlertController.initAler(title: "Success", message: "Change infomation conplete", inViewController: self)
                }, failure: { (_) in
                    
                })
            }) { (_) in
                
            }
        } else {
          changePassPressed()
        }
    }
    
    func changePassPressed() {
        oldPassMember = oldPassTextField.text
        newPassMember = newPassTextField.text
        confirmPassMember = confirmPassTextField.text
        if (newPassMember?.components(separatedBy: " ").count)! > 1 || (confirmPassMember?.components(separatedBy: " ").count)! > 1 {
             _ = UIAlertController.initAler(title: "", message: "Password cant has space", inViewController: self)
            return
        }
        
        if oldPassMember != nil && newPassMember != nil && confirmPassMember != nil {
            let changePassWord = ChangePasswordTask(memberID: (memberInstance?.idMember)!, oldPass: oldPassMember!, newPass: newPassMember!, confirmPass: confirmPassMember!, token: tokenInstance!)
            requestWithTask(task: changePassWord, success: { (data) in
                if let status = data as? (Bool, String) {
                    if status.0 {
                        let alert = UIAlertController.init(title: "", message: status.1, preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK",
                                                   style: UIAlertActionStyle.default) { (_) in
                            self.navigationController?.popViewController(animated: true)
                        }
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                    _ = UIAlertController.initAler(title: "", message: status.1, inViewController: self)
                }
            }, failure: { (_) in
                
            })
        }
    }
    
    @IBAction func pressedShowDate(_ sender: Any) {
        if let dateDailog = SettingDatepicker.instance() as? SettingDatepicker {
            dateDailog.show()
            dateDailog.callBackDate = { [weak self] date in
                self?.birthDay.text = date
            }
        }
    }
    
    @IBAction func pressShowSex(_ sender: Any) {
        if let sexDailog = SettingChooseSex.instance() as? SettingChooseSex {
            sexDailog.show()
            sexDailog.calBack = { [weak self] (sexString, sexType) in
                self?.sex.text = sexString
                self?.sexMember = sexType.rawValue
            }
        }
    }
    
    @IBAction func pressShowMarrie(_ sender: Any) {
        if let marrieDailog = SettingStatus.instance() as? SettingStatus {
            marrieDailog.show()
            marrieDailog.callBack = { [weak self] (statusString, statusTyppe)in
                self?.statusMarrie.text = statusString
                self?.statusMarrigeMember = statusTyppe.rawValue
            }
        }
    }
}
