//
//  NewsBookmarkedCell.swift
//  BookApp
//
//  Created by kien le van on 9/7/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class NewsBookmarkedCell: UITableViewCell {

    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    @IBOutlet weak var newsName: UILabel!
    @IBOutlet weak var heightOfImage: NSLayoutConstraint!
    @IBOutlet weak var newsImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsImage.layer.cornerRadius = heightOfImage.constant / 2
    }
    
    func binData(news: NewsModel) {
        type.text = news.nameType
        time.text = news.timeUp
        newsDescription.text = news.detailNews
        newsName.text = news.title
        newsImage.sd_setImage(with: URL(string: news.imageURL))
    }

}
