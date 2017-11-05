//
//  DetailBinController.swift
//  BookApp
//
//  Created by kien le van on 9/23/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class DetailBinController: BaseViewController {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var numberPhone: UITextField!
    @IBOutlet weak var adress: UITextField!
    
    private var _name: String?
    private var _phone: Int?
    private var _adress: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.delegate = self
        numberPhone.delegate = self
        adress.delegate = self
        cancelButton.layer.borderColor = UIColor.black.cgColor
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func setupUI() {
        if PeoleReciveProduct.sharedInstance.phone != nil {
            name.text = PeoleReciveProduct.sharedInstance.name
            numberPhone.text = String(PeoleReciveProduct.sharedInstance.phone!)
            adress.text = PeoleReciveProduct.sharedInstance.adress
        }
    }
    
    func checkInfor() -> Bool {
        _name = name.text
        _phone = Int(numberPhone.text!)
        _adress = adress.text
        if _name == "" || _adress == "" {
            UIAlertController.showAler(title: "", message: "Please full infomation", inViewController: self)
            return false
        } else if _phone == nil {
            UIAlertController.showAler(title: "", message: ErrorCode.numberPhoneEmty.decodeError(), inViewController: self)
            return false
        }
        self.view.endEditing(true)
        UIAlertController.showAler(title: "", message: ErrorCode.success.decodeError(), inViewController: self)
        return true
    }

    @IBAction func pressedSaveAdress(_ sender: Any) {
        if checkInfor() {
            PeoleReciveProduct.sharedInstance.name = _name
            PeoleReciveProduct.sharedInstance.phone = _phone
            PeoleReciveProduct.sharedInstance.adress = _adress
        }
    }

    @IBAction func pressedCancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension DetailBinController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
