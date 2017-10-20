//
//  CountryCell.swift
//  BookApp
//
//  Created by kien le van on 10/4/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func binData(nameCountry: String) {
        let countryCode = nameCountry.components(separatedBy: " ")
        name.text = countryCode[0]
    }
    
}
