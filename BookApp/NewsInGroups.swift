//
//  NewsInGroups.swift
//  BookApp
//
//  Created by kien le van on 9/12/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class NewsInGroups: NSObject {
    
    private var _idNews: Int!
    private var _imageNews: String!
    private var _title: String!
    private var _descriptionNews: String!
    private var _content: String!
    private var _time: String!
    private var _groupOwner: SecrectGroup?
    
    init(idNews: Int, image: String, title: String, descriptionNews: String, content: String, time: String) {
        _idNews = idNews
        _imageNews = image
        _title = title
        _descriptionNews = descriptionNews
        _content = content
        _time = time
    }
    
    var idNews: Int {
        return _idNews
    }
    var imageURL: String {
        return _imageNews
    }
    var title: String {
        return _title
    }
    var desciptionNews: String {
        return _descriptionNews
    }
    var content: String {
        return _content
    }
    var time: String {
        return _time
    }
    var groupOwner: SecrectGroup {
        get {
            return _groupOwner!
        }
        set {
            _groupOwner = newValue
        }
    }
}
