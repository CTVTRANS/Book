//
//  Constants.swift
//  BookApp
//
//  Created by Le Cong on 8/11/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

let widthScreen: CGFloat = UIScreen.main.bounds.width
let hightScreen: CGFloat = UIScreen.main.bounds.height

enum Object: Int {
    case news = 0, book, comment, chanel
}

enum Like: Int {
    case unLike = 0, like
}

enum Subcrible: Int {
    case subcrible = 0, unSubcrible
}

enum BookMark: Int {
    case bookMark = 0, unBookMark
}

enum TopButton: Int {
    case messageNotification = 0, videoNotification, search
}

enum BottomButton: Int {
    case back = 0, download, bookMark, like, comment
}

enum TypeProductRequest: Int {
    case point = 0, pointAndMoney, all
}

enum ScreenShow: Int {
    case book = 0
    case chanel = 1
    case buyProduct = 2
    case group = 3
}

enum TypePlay: Int {
    case onLine = 0
    case offLine = 1
}

class Constants: NSObject {
    var listNewsType: [NewsType] = []
    var listBookType: [BookType] = []
    var listChanelSubcribled: [Chanel] = []
    var listGroupJoined: [SecrectGroup] = []
    var language: Int = 0

    var listCommentHot: [Comment] = []
    var hasNotification = false
    var deviceToken = ""
    
    static let sharedInstance = Constants()
    private override init() {}
}
