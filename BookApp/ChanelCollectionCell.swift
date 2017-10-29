//
//  TeacherCollectionCell.swift
//  BookApp
//
//  Created by kien le van on 8/18/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class ChanelCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageChanel: UIImageView!
    @IBOutlet weak var nameTeacher: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func binData(chanel: Chanel) {
        nameTeacher.text = chanel.nameChanel
        imageChanel.sd_setImage(with: URL(string: chanel.imageChanelURL),
                                placeholderImage: #imageLiteral(resourceName: "place_holder"))
    }

}
