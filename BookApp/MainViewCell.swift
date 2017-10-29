//
//  MainViewCell.swift
//  BookApp
//
//  Created by Le Cong on 8/10/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class MainViewCell: UITableViewCell {

    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var titleNews: UILabel!
    @IBOutlet weak var detailNews: UILabel!
    @IBOutlet weak var numberComment: UILabel!
    @IBOutlet weak var numberLike: UILabel!
    @IBOutlet weak var numberView: UILabel!
    @IBOutlet weak var typeNews: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func binData(news: NewsModel) {
        imageNews.sd_setImage(with: URL(string: news.imageURL))
        titleNews.text = news.title
        detailNews.text = news.detailNews
        typeNews.text = String(news.nameType)
        numberView.text = news.author
        numberLike.text = String(news.numberLike)
        numberComment.text = String(news.numberComment)
    }

}
