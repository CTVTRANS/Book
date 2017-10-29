//
//  ActivityGroupCell.swift
//  BookApp
//
//  Created by kien le van on 9/8/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class ActivityGroupCell: UITableViewCell {

    @IBOutlet weak var heightOfImage: NSLayoutConstraint!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        statusImage.layer.cornerRadius = heightOfImage.constant / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    func binData(group: SecrectGroup) {
        name.text = group.name
        statusImage.backgroundColor = UIColor.rgb(201, 201, 201)
        if group.isSubcrible {
            statusImage.backgroundColor = UIColor.rgb(255, 102, 0)
        }
    }
}
