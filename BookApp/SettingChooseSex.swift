//
//  Setting_ChooseSex.swift
//  BookApp
//
//  Created by kien le van on 9/27/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class SettingChooseSex: BaseDailog {
    
    @IBOutlet weak var circeSecurity: UIView!
    @IBOutlet weak var circelFemale: UIView!
    @IBOutlet weak var circelMale: UIView!

    @IBOutlet weak var dotSecurity: UIView!
    @IBOutlet weak var dotFemale: UIView!
    @IBOutlet weak var dotMale: UIView!

    var sex: (String, Sex) = ("保密", Sex.sucurity)
    var calBack:((_ name: (String, Sex)) -> Void) = {_ in}

    override func awakeFromNib() {
        super.awakeFromNib()
        circeSecurity.layer.borderColor = UIColor.rgb(201, 201, 201).cgColor
        circelMale.layer.borderColor = UIColor.rgb(201, 201, 201).cgColor
        circelFemale.layer.borderColor = UIColor.rgb(201, 201, 201).cgColor
        dotSecurity.backgroundColor = UIColor.rgb(255, 102, 0)
    }
    
    @IBAction func pressedSecurity(_ sender: Any) {
        dotSecurity.backgroundColor = UIColor.rgb(255, 102, 0)
        dotMale.backgroundColor = UIColor.white
        dotFemale.backgroundColor = UIColor.white
        sex = ("保密", Sex.sucurity)
    }
    
    @IBAction func pressedFemale(_ sender: Any) {
        dotSecurity.backgroundColor = UIColor.white
        dotFemale.backgroundColor = UIColor.rgb(255, 102, 0)
        dotMale.backgroundColor = UIColor.white
        sex = ("女", Sex.female)
    }
    
    @IBAction func pressMale(_ sender: Any) {
        dotFemale.backgroundColor = UIColor.white
        dotSecurity.backgroundColor = UIColor.white
        dotMale.backgroundColor = UIColor.rgb(255, 102, 0)
        sex = ("男", Sex.male)
    }

    @IBAction func pressedChange(_ sender: Any) {
        self.hide()
        self.calBack(sex)
    }
}
