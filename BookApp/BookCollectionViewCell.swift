//
//  BookCollectionViewCell.swift
//  BookApp
//
//  Created by kien le van on 8/17/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameBook: UILabel!
    @IBOutlet weak var imageBook: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func binData(book: Book) {
        nameBook.text = book.name
        let urlString = book.imageURL
        if urlString != "abc" {
            imageBook.sd_setImage(with: URL(string: urlString), placeholderImage: #imageLiteral(resourceName: "place_holder"))
        }
    }
}
