//
//  NewsModel.swift
//  BookApp
//
//  Created by Le Cong on 8/10/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class NewsModel: NSObject {
    private var _idNews, _typeNews: Int!
    private var _nameTypeNews: String!
    private var _author: String!
    private var _imageURL, _content, _note: String!
    private var _titleNews, _detailTitle, _timeUp: String!
    private var _numberViewNews, _numberLikeNews, _numberCommentNews, _numberBookMarkNews: Int!
    private var _category: Int!
    
    init(idNews: Int, author: String, imageUrl: String, title: String,
         detail: String, type: Int, nameType: String, content: String, note: String,
         timeUp: String, numberView: Int, numberLike: Int,
         numberComment: Int, numberBookMark: Int, category: Int) {
            _idNews = idNews
            _author = author
            _imageURL = imageUrl
            _titleNews = title
            _detailTitle = detail
            _typeNews = type
            _nameTypeNews = nameType
            _content = content
            _note = note
            _timeUp = timeUp
            _numberViewNews = numberView
            _numberLikeNews = numberLike
            _numberCommentNews = numberComment
            _numberBookMarkNews = numberBookMark
        _category = category
    }
    var idNews: Int {
        return _idNews
    }
    var author: String {
        return _author
    }
    var imageURL: String {
        return _imageURL
    }
    var title: String {
        return _titleNews
    }
    var detailNews: String {
        return _detailTitle
    }
    var typeNews: Int {
        return _typeNews
    }
    var nameType: String {
        return _nameTypeNews
    }
    var content: String {
        return _content
    }
    var note: String {
        return _note
    }
    var timeUp: String {
        return _timeUp
    }
    var numberViewNews: Int {
        get {
            return _numberViewNews
        }
        set {
            _numberViewNews = newValue
        }
    }
    var numberLike: Int {
        get {
            return _numberLikeNews
        }
        set {
            _numberLikeNews = newValue
        }
    }
    var numberComment: Int {
        get {
            return _numberCommentNews
        }
        set {
            _numberCommentNews = newValue
        }
    }
    var numberBookMark: Int {
        get {
            return _numberBookMarkNews
        }
        set {
            _numberBookMarkNews = newValue
        }
    }
    var category: Int {
        return _category
    }
}
