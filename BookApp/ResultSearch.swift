//
//  ResultSearchCell.swift
//  BookApp
//
//  Created by kien le van on 9/16/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class ResultSearch: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func binData(objec: Any) {
        if let book = objec as? Book {
            title.text = book.name
            let arrayString = book.descriptionBook.components(separatedBy: "</p>")
            let firstString = arrayString[0]
            let index = firstString.index(firstString.startIndex, offsetBy: 4)
            descriptionTitle.text = firstString.substring(from: index)
            return
        }
        if let news = objec as? NewsModel {
            title.text = news.title
            descriptionTitle.text = news.detailNews
        }
    }
}
