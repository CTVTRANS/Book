//
//  MenuCollectionViewCell.swift
//  BookApp
//
//  Created by kien le van on 10/16/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.rgb(201, 201, 201).cgColor
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
    }

    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            if newValue {
                nameType.textColor = .white
                self.backgroundColor = UIColor.rgb(255, 102, 0)
            } else if newValue == false {
                nameType.textColor = .black
                self.backgroundColor = .white
            }
        }
    }
}
