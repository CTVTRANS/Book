//
//  MarkCollectionViewCell.swift
//  BookApp
//
//  Created by kien le van on 9/13/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class StoreMarkViewCell: UICollectionViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var pointBookView: UIView!
    @IBOutlet weak var moneyBookView: UIView!
    @IBOutlet weak var moneyBook: UILabel!
    @IBOutlet weak var point: UILabel!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var moneyVipView: UIView!
    @IBOutlet weak var moneyVip: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func binData(product: AnyObject, type: TypeProductRequest) {
        if let book = product as? Book {
            avatar.sd_setImage(with: URL(string: book.imageURL), placeholderImage: #imageLiteral(resourceName: "place_holder"))
            moneyVipView.isHidden = true
            moneyBookView.isHidden = false
            pointBookView.isHidden = false
            if type == TypeProductRequest.pointAndMoney ||
                (type == TypeProductRequest.all && book.typePay == "money") {
                title.text = "[現] " + book.name
                let pirce_Mix: PriceMix = book.priceMix[0]
                let pricePoint = pirce_Mix.point
                let priceMoney = pirce_Mix.mooney
                point.text = String(pricePoint)
                moneyBook.text = String(priceMoney)
                return
            } else if type == TypeProductRequest.point ||
                (type == TypeProductRequest.all && book.typePay == "point") {
                title.text = "[積] " + book.name
                point.text = String(book.price!)
                moneyBookView.isHidden = true
                return
            }
            return
        }
        if let vip = product as? Vip {
            avatar.sd_setImage(with: URL(string: vip.imageURL), placeholderImage: #imageLiteral(resourceName: "place_holder"))
            moneyVipView.isHidden = false
            moneyBookView.isHidden = true
            pointBookView.isHidden = true
            title.text = vip.title
            moneyVip.text = String(vip.price)
            
        }
    }
}
