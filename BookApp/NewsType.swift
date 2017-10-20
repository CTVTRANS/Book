//
//  NewsType.swift
//  BookApp
//
//  Created by kien le van on 9/18/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class NewsType: NSObject {
    
    private var _idType: Int!
    private var _nameType: String!
    private var _description: String!
    private var _parentID: Int!
    
    init(idType: Int, parentID: Int, nameType: String, desciptionType: String) {
        _idType = idType
        _parentID = parentID
        _nameType = nameType
        _description = desciptionType
    }

    var idType: Int {
        return _idType
    }
    var nameType: String {
        return _nameType
    }
    var descriptionType: String {
        return _description
    }
    var parentID: Int {
        return _parentID
    }
}
