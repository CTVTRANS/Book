//
//  BookType.swift
//  BookApp
//
//  Created by kien le van on 8/25/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class MenuType: NSObject {
    private var _parentID: Int!
    private var _nameType: String!
    private var _imageType: String!
    private var _typeID: Int
    private var _descriptionType: String!
    
    init(name: String, image: String, typeID: Int, description: String, parentID: Int) {
        _nameType = name
        _imageType = image
        _typeID = typeID
        _descriptionType = description
        _parentID = parentID
    }
    var name: String {
        return _nameType
    }
    var imageURL: String {
        return _imageType
    }
    var typeID: Int! {
        return _typeID
    }
    var descriptionType: String {
        return _descriptionType
    }
    var parentID: Int! {
        return _parentID
    }
}
