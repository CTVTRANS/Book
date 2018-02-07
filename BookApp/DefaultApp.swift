//
//  DefaultApp.swift
//  BookApp
//
//  Created by kien le van on 10/16/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class DefaultApp: NSObject {

    var audioFree = false
    var timeLimitAudio = 0
    var limitVideo = 0
    var limitWord = 0
    var defaultAvatar = ""
    var defaultBackground = ""
    var suporter = ""
    var termOffUse = ""
    
    static let sharedInstance = DefaultApp()
}
