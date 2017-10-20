//
//  ChanelViewCell.swift
//  BookApp
//
//  Created by kien le van on 9/6/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class ChanelViewCell: UITableViewCell {
    
    @IBOutlet weak var subcribleButton: UIButton!
    @IBOutlet weak var imageChanel: UIImageView!
    @IBOutlet weak var heightOfImage: NSLayoutConstraint!
    @IBOutlet weak var timeUp: UILabel!
    @IBOutlet weak var nameChanel: UILabel!
    
    var callBackButton = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subcribleButton.layer.borderColor = UIColor.rgb(245, 166, 35).cgColor
        imageChanel.layer.cornerRadius = heightOfImage.constant / 2
    }
    
    func binData(chanel: Chanel) {
        nameChanel.text = chanel.nameChanel
        imageChanel.sd_setImage(with: URL(string: chanel.imageChanelURL), placeholderImage: #imageLiteral(resourceName: "userPlaceHolder"))
        let date = chanel.time.components(separatedBy: " ")
        timeUp.text = date[0]
    }
    
    @IBAction func pressedSubcrible(_ sender: Any) {
        self.callBackButton()
    }
}
