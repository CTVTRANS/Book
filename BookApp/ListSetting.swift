//
//  ListSetting.swift
//  BookApp
//
//  Created by kien le van on 9/7/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class ListSetting: NSObject {

    private let _arr: [SettingCellModel]!
    
    init(array: [SettingCellModel]) {
        _arr = array
    }
    var arr: [SettingCellModel] {
        return _arr
    }
}
