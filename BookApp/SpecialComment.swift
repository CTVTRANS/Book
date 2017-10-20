//
//  SpecialComment.swift
//  BookApp
//
//  Created by kien le van on 8/31/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class SpecialComment: NSObject {
    
    private var _name: String!
    private var _listComment: [Comment]?
    
    init(name: String, array: [Comment]) {
        _name = name
        _listComment = array
    }
    var name: String {
        return _name
    }
    var comment: [Comment] {
        return _listComment!
    }
}
