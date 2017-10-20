//
//  ListBookFreee.swift
//  BookApp
//
//  Created by kien le van on 9/13/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class ListBookFreee: UITableViewCell {

    @IBOutlet weak var imageBook: UIImageView!
    @IBOutlet weak var typeBook: UILabel!
    @IBOutlet weak var nameBook: UILabel!
    @IBOutlet weak var descriptionBook: UILabel!
    @IBOutlet weak var numberView: UILabel!
    @IBOutlet weak var timeUp: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func binData(book: Book) {
        typeBook.text = " " + book.typeName + " "
        nameBook.text = book.name
        descriptionBook.text = book.author
        numberView.text = String(book.numberHumanReaed)
        imageBook.sd_setImage(with: URL(string: book.imageURL))
        let date = book.timeUpBook.components(separatedBy: " ")
        timeUp.text = date[0]
    }
}
