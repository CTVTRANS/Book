//
//  Lesson.swift
//  BookApp
//
//  Created by kien le van on 9/5/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class Lesson: NSObject, NSCoding {
    
    private let _idLesson, _chapter: Int!
    private let _timeUp: String?
    private let _name, _description: String!
    private let _imageChapterURL, _contentChapterURL: String!
    private var _isPlay: Int = 0
    private var _pause: Int = 0
    private var _ownerOFChanel: String?
    private var _imageOffline: URL?
    private var _audioOffline: URL?
    
    init(idLesson: Int, chaper: Int, time: String, name: String, description: String,
         imageURL: String, contentURL: String) {
        _idLesson = idLesson
        _chapter = chaper
        _timeUp = time
        _name = name
        _description = description
        _imageChapterURL = imageURL
        _contentChapterURL = contentURL
    }
    
    required init(coder decoder: NSCoder) {
        _idLesson = decoder.decodeObject(forKey: "_idLesson") as? Int
        _chapter = decoder.decodeObject(forKey: "_chapter") as? Int
        _timeUp = decoder.decodeObject(forKey: "_timeUp") as? String
        _name = decoder.decodeObject(forKey: "_name") as? String
        _description = decoder.decodeObject(forKey: "_description") as? String
        _imageChapterURL = decoder.decodeObject(forKey: "_imageChapterURL") as? String
        _imageOffline = decoder.decodeObject(forKey: "_imageOffline") as? URL
        _contentChapterURL = decoder.decodeObject(forKey: "_contentChapterURL") as? String
        _audioOffline = decoder.decodeObject(forKey: "_audioOffline") as? URL
        _ownerOFChanel = decoder.decodeObject(forKey: "_ownerOFChanel") as? String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(_idLesson, forKey: "_idLesson")
        coder.encode(_chapter, forKey: "_chapter")
        coder.encode(_timeUp, forKey: "_timeUp")
        coder.encode(_name, forKey: "_name")
        coder.encode(_description, forKey: "_description")
        coder.encode(_imageOffline, forKey: "_imageOffline")
        coder.encode(_audioOffline, forKey: "_audioOffline")
        coder.encode(_ownerOFChanel, forKey: "_ownerOFChanel")
        coder.encode(_contentChapterURL, forKey: "_contentChapterURL")
        coder.encode(_imageChapterURL, forKey: "_imageChapterURL")
    }
    
    class func saveLesson(lesson: [Lesson]) {
        let encodeData = NSKeyedArchiver.archivedData(withRootObject: lesson)
        UserDefaults.standard.set(encodeData, forKey: "lessonDownload")
    }
    
    class func getLesson() -> [Lesson]? {
        if let data = UserDefaults.standard.data(forKey: "lessonDownload"), let myLesson = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Lesson] {
            return myLesson
        }
        let litsLesson: [Lesson] = []
        return litsLesson
    }
    
    var idChap: Int {
        return _idLesson!
    }
    var chapter: Int {
        return _chapter!
    }
    var timeUp: String {
        return _timeUp!
    }
    var name: String {
        return _name!
    }
    var descriptionChap: String {
        return _description!
    }
    var imageChapURL: String {
        return _imageChapterURL!
    }
    var contentURL: String {
        return _contentChapterURL!
    }
    var isPlay: Int {
        get { return _isPlay}
        set { _isPlay = newValue}
    }
    var pause: Int {
        get { return _pause}
        set { _pause = newValue}
    }
    var chanelOwner: String {
        get { return _ownerOFChanel!}
        set { _ownerOFChanel = newValue}
    }
    var imageOffline: URL? {
        get { return _imageOffline}
        set { _imageOffline = newValue}
    }
    var audioOffline: URL {
        get { return _audioOffline!}
        set { _audioOffline = newValue}
    }
}
