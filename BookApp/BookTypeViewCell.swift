//
//  BookTypeViewCell.swift
//  BookApp
//
//  Created by kien le van on 8/22/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import SDWebImage

class BookTypeViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    func binData(typeBook: BookType) {
        title.text = typeBook.name
        image.sd_setImage(with: URL(string: typeBook.imageURL), placeholderImage: #imageLiteral(resourceName: "place_holder"))
    }
}
