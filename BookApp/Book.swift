//
//  Book.swift
//  BookApp
//
//  Created by kien le van on 8/15/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class Book: NSObject, NSCoding {
    
    private var _idBook, _type: Int!
    private var _typeName, _nameBook, _typePay: String!
    private var _author: String!
    private var _imageBookUrl: String!
    private var _numberHumanReaded: Int!
    private var _timeUpBook: String!
    private var _audio, _video: String!
    private var _content, _desCription: String!
    private var _numberLike, _numberComment, _numberBookMark: Int!
    private var _isPlay: Int = 0
    private var _pause: Int = 0
    private var _price: Int?
    private var _priceMix: [PriceMix]!
    private var _audioOffline: URL?
    private var _imageOffline: URL?
    
    init(idBook: Int, type: Int, typeName: String, name: String, author: String,
         imageUrl: String, numberReaded: Int, timeUp: String, audio: String,
         video: String, content: String, numberLike: Int, numberComment: Int,
         numberBookMark: Int, desCription: String, price: Int?, priceMix: [PriceMix],
         typePay: String) {
            _idBook = idBook
            _type = type
            _typeName = typeName
            _nameBook = name
            _imageBookUrl = imageUrl
            _numberHumanReaded = numberReaded
            _timeUpBook = timeUp
            _audio = audio
            _video = video
            _numberLike = numberLike
            _numberComment = numberComment
            _numberBookMark = numberBookMark
            _author = author
            _content = content
            _desCription = desCription
            _price = price
            _priceMix = priceMix
        _typePay = typePay
    }
    
    required init(coder decoder: NSCoder) {
        _idBook = decoder.decodeObject(forKey: "_idBook") as? Int
        _type = decoder.decodeObject(forKey: "_type") as? Int
        _typeName = decoder.decodeObject(forKey: "_typeName") as? String
        _nameBook = decoder.decodeObject(forKey: "_nameBook") as? String
        _imageOffline = decoder.decodeObject(forKey: "_imageOffline") as? URL
        _timeUpBook = decoder.decodeObject(forKey: "_timeUpBook") as? String
        _numberHumanReaded = decoder.decodeObject(forKey: "_numberHumanReaded") as? Int
        _author = decoder.decodeObject(forKey: "_author") as? String
        _audioOffline = decoder.decodeObject(forKey: "_audioOffline") as? URL
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(_idBook, forKey: "_idBook")
        coder.encode(_type, forKey: "_type")
        coder.encode(_typeName, forKey: "_typeName")
        coder.encode(_nameBook, forKey: "_nameBook")
        coder.encode(_imageOffline, forKey: "_imageOffline")
        coder.encode(_timeUpBook, forKey: "_timeUpBook")
        coder.encode(_numberHumanReaded, forKey: "_numberHumanReaded")
        coder.encode(_author, forKey: "_author")
        coder.encode(_audioOffline, forKey: "_audioOffline")
    }
    
    class func saveBook(myBook: [Book]) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: myBook)
        UserDefaults.standard.set(encodedData, forKey: "bookDownloaded")
    }
    
    class func getBook() -> [Book]? {
        if let data = UserDefaults.standard.data(forKey: "bookDownloaded"),
            let listBook = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Book] {
            return listBook
        }
        let listBook: [Book] = []
        return listBook
    }
    
    var type: Int {
        return _type
    }
    var name: String {
        return _nameBook!
    }
    var typeName: String {
        return _typeName
    }
    var author: String {
        return _author!
    }
    var imageURL: String {
        return _imageBookUrl!
    }
    
    var numberHumanReaed: Int {
        get { return _numberHumanReaded!}
        set { _numberHumanReaded = newValue}
    }
    var numberLike: Int {
        get { return _numberLike}
        set { _numberLike = newValue}
    }
    var numberComment: Int {
        get { return _numberComment}
        set { _numberComment = newValue}
    }
    var numberBookMark: Int {
        get { return _numberBookMark}
        set { _numberBookMark = newValue}
    }
    var timeUpBook: String {
        return _timeUpBook!
    }
    var idBook: Int {
        return _idBook!
    }
    var audio: String {
        return _audio!
    }
    var video: String {
        return _video!
    }
    var content: String {
        return _content!
    }
    var descriptionBook: String {
        return _desCription!
    }
    var isPlay: Int {
        get { return _isPlay}
        set { _isPlay = newValue}
    }
    var pause: Int {
        get { return _pause}
        set { _pause = newValue}
    }
    var price: Int? {
        return _price
    }
    var priceMix: [PriceMix] {
        return _priceMix
    }
    var audioOffline: URL? {
        get { return _audioOffline}
        set { _audioOffline = newValue}
    }
    var imageOffline: URL? {
        get { return _imageOffline}
        set { _imageOffline = newValue}
    }
    var typePay: String {
        return _typePay
    }
}
