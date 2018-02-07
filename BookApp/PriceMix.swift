//
//  PriceMix.swift
//  BookApp
//
//  Created by kien le van on 9/15/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class PriceMix: NSObject {
    
    private var _point: Int!
    private var _money: Float!
    
    init(point: Int, money: Float) {
        _point = point
        _money = money
    }
    var point: Int {
        return _point
    }
    var mooney: Float {
        return _money
    }
}
