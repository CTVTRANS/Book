//
//  GetDefaultSettingTask.swift
//  BookApp
//
//  Created by kien le van on 10/11/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetDefaultSettingTask: BaseTaskNetwork {
    
    override func path() -> String! {
        return defaultNonSigin
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func data(withResponse response: Any!) -> Any! {
        if let dictionary = response as? [String: Any] {
            let avatardefault = dictionary["image_default_avatar"] as? String ?? ""
            let backgroundImage = dictionary["image_default_cover"] as? String ?? ""
            let limitAudio = dictionary["limit_second_audio"] as? Int ?? 0
            let limitVideo = dictionary["limit_second_video"] as? Int ?? 0
            let linitWord = dictionary["limit_word"] as? Int ?? 0
            let suport  = dictionary["support"] as? String ?? ""
            DefaultApp.sharedInstance.limitAudio = limitAudio
            DefaultApp.sharedInstance.limitVideo = limitVideo
            DefaultApp.sharedInstance.limitWord = linitWord
            DefaultApp.sharedInstance.defaultAvatar = avatardefault
            DefaultApp.sharedInstance.defaultBackground = backgroundImage
            DefaultApp.sharedInstance.suporter = suport
        }
        return response
    }
}
