//
//  User.swift
//  BookApp
//
//  Created by kien le van on 8/28/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class User: NSObject {
    private var _name: String!
    private var _age: Int!
    private var _sex: Int!
    private var _imageRRL: String!
    
    init(name: String, age: Int, sex: Int, avata: String) {
        _name = name
        _age = age
        _sex = sex
        _imageRRL = avata
    }
    var name: String {
        get {
            return _name
        }
        set {
            _name = newValue
        }
    }
    var age: Int {
        get {
            return _age
        }
        set {
            _age = newValue
        }
    }
    var sex: Int {
        get {
            return _sex
        }
        set {
            _sex = newValue
        }
    }
    var avata: String {
        get {
            return _imageRRL
        }
        set {
            _imageRRL = newValue
        }
    }
}
