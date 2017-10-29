//
//  HistotyMarkCell.swift
//  BookApp
//
//  Created by kien le van on 9/13/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class HistoryMarkCell: UITableViewCell {

    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var imageVip: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func binData(history: HistoryBuy) {
        name.text = history.productVip?.title
        time.text = history.time.components(separatedBy: " ")[0]
        imageVip.sd_setImage(with: URL(string: (history.productVip?.imageURL)!))
        detail.text = history.productVip?.descriptionVip
    }

}
