//
//  ScrectGroup.swift
//  BookApp
//
//  Created by kien le van on 9/12/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class SecrectGroup: NSObject {
    
    private var _characterGroup: String!
    private var _idGroup: Int!
    private var _name: String!
    private var _imageURL: String!
    private var _idWechat: String!
    private var _adress: String!
    private var _isSubcrible: Bool
    
    init(idGroup: Int, name: String, imageURL: String, idWechat: String,
         adress: String, isSubcrible: Bool, charaterGroup: String) {
        _idGroup = idGroup
        _name = name
        _imageURL = imageURL
        _idWechat = idWechat
        _adress = adress
        _isSubcrible = isSubcrible
        _characterGroup = charaterGroup
    }
    
    var idGroup: Int {
        return _idGroup
    }
    var name: String {
        return _name
    }
    var imageURL: String {
        return _imageURL
    }
    var idWechat: String {
        return _idWechat
    }
    var adress: String {
        return _adress
    }
    var isSubcrible: Bool {
        get {
            return _isSubcrible
        }
        set {
            _isSubcrible = newValue
        }
    }
    var charaterGroup: String {
        return _characterGroup
    }
}
