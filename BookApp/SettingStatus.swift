//
//  Setting_Status.swift
//  BookApp
//
//  Created by kien le van on 9/27/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class SettingStatus: BaseDailog {
    
    @IBOutlet weak var circelSecurity: UIView!
    @IBOutlet weak var circelMarried: UIView!
    @IBOutlet weak var circelSingle: UIView!
    
    @IBOutlet weak var dotSecurity: UIView!
    @IBOutlet weak var dotMarried: UIView!
    @IBOutlet weak var dotSingle: UIView!

    var status: (String, StatusMarrige) = ("security".localized, StatusMarrige.sucurity)
    var callBack:((_ status: (String, StatusMarrige)) -> Void) = {_ in}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        circelSecurity.layer.borderColor = UIColor.rgb(201, 201, 201).cgColor
        circelMarried.layer.borderColor = UIColor.rgb(201, 201, 201).cgColor
        circelSingle.layer.borderColor = UIColor.rgb(201, 201, 201).cgColor
        dotSecurity.backgroundColor = UIColor.rgb(255, 102, 0)
    }
    
    @IBAction func pressedSecurity(_ sender: Any) {
        dotSecurity.backgroundColor = UIColor.rgb(255, 102, 0)
        dotMarried.backgroundColor = UIColor.white
        dotSingle.backgroundColor = UIColor.white
        status = ("security".localized, StatusMarrige.sucurity)
    }

    @IBAction func pressedMarried(_ sender: Any) {
        dotSingle.backgroundColor = UIColor.white
        dotSecurity.backgroundColor = UIColor.white
        dotMarried.backgroundColor = UIColor.rgb(255, 102, 0)
        status = ("married".localized, StatusMarrige.married)
    }
    
    @IBAction func pressSingle(_ sender: Any) {
        dotSecurity.backgroundColor = UIColor.white
        dotSingle.backgroundColor = UIColor.rgb(255, 102, 0)
        dotMarried.backgroundColor = UIColor.white
        status = ("unmarried".localized, StatusMarrige.single)
    }
    
    @IBAction func pressedChange(_ sender: Any) {
        self.hide()
        self.callBack(status)
    }
}
