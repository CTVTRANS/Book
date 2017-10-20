//
//  SettingViewCell.swift
//  BookApp
//
//  Created by kien le van on 9/7/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class SettingViewCell: UITableViewCell {

    @IBOutlet weak var imageDetail: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var specialName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func binData(settingCell: SettingCellModel) {
        name.text = settingCell.nameSetting
        specialName.text = settingCell.specialName
        detailName.text = settingCell.nameDetail
        if !settingCell.showArrow {
            imageDetail.isHidden = true
        }
    }
    
}
