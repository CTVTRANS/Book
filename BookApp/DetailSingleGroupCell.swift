//
//  DetailSingleGroupCell.swift
//  BookApp
//
//  Created by kien le van on 9/11/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class DetailSingleGroupCell: UITableViewCell {

    @IBOutlet weak var titleNews: UILabel!
    @IBOutlet weak var imageNews: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func binData(news: NewsInGroups) {
        titleNews.text = news.title
        imageNews.sd_setImage(with: URL(string: news.imageURL), placeholderImage: #imageLiteral(resourceName: "userPlaceHolder"))
    }

}
