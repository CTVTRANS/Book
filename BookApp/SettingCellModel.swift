//
//  SettingCellModel.swift
//  BookApp
//
//  Created by kien le van on 9/7/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class SettingCellModel: NSObject {
    
    private var _name: String!
    private var _specialName: String!
    private var _arrowDetail: Bool!
    private var _nameDetail: String!
    
    init(name: String, specialName: String, arrrowDetail: Bool, nameDetail: String) {
        _name = name
        _specialName = specialName
        _arrowDetail = arrrowDetail
        _nameDetail = nameDetail
    }
    var nameSetting: String {
        return _name
    }
    var specialName: String {
        return _specialName
    }
    var showArrow: Bool {
        return _arrowDetail
    }
    var nameDetail: String {
        return _nameDetail
    }
}
