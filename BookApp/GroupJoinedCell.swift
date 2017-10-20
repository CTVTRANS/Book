//
//  GroupJoinedCell.swift
//  BookApp
//
//  Created by kien le van on 9/8/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class GroupJoinedCell: UICollectionViewCell {
    
    @IBOutlet weak var isSubcribleView: UIView!
    @IBOutlet weak var nameGroupd: UILabel!
    @IBOutlet weak var imageGroup: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageGroup.layer.cornerRadius = (widthScreen / 4 - 15) / 2
        isSubcribleView.layer.cornerRadius = (widthScreen / 4 - 15) / 2
    }
    
    func binData(group: SecrectGroup) {
        nameGroupd.text = group.name
        imageGroup.sd_setImage(with: URL(string: group.imageURL), placeholderImage: #imageLiteral(resourceName: "userPlaceHolder"))
        if group.isSubcrible {
            isSubcribleView.isHidden = true
        } else {
            isSubcribleView.isHidden = false
        }
    }

}
