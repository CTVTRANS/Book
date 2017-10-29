//
//  Vip.swift
//  BookApp
//
//  Created by kien le van on 9/15/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class Vip: NSObject {

    private var _idVip: Int!
    private var _title: String!
    private var _imageURL: String!
    private var _description: String!
    private var _content: String!
    private var _price: Int!
    private var _point: Int!
    
    init(idVip: Int, title: String, imageURL: String, description: String,
         content: String, price: Int, point: Int) {
        _idVip = idVip
        _title = title
        _imageURL = imageURL
        _description = description
        _content = content
        _price = price
        _point = point
    }
    var idVip: Int {
        return _idVip
    }
    var title: String {
        return _title
    }
    var imageURL: String {
        return _imageURL
    }
    var descriptionVip: String {
        return _description
    }
    var conten: String {
        return _content
    }
    var price: Int {
        return _price
    }
    var point: Int {
        return _point
    }
}
