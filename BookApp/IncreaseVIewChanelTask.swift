//
//  IncreaseVIewChanelTask.swift
//  BookApp
//
//  Created by kien le van on 9/5/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class IncreaseVIewChanelTask: BaseTaskNetwork {
    
    private var _lessonID: Int
    
    init(lessonID: Int) {
        _lessonID = lessonID
    }
    
    override func path() -> String! {
        return increaseViewChanelURL
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["lesson_id": _lessonID]
    }
    
    override func method() -> String! {
        return POST
    }
    
    override func data(withResponse response: Any!) -> Any! {
        var status = "fail"
        if let dictionary = response as? [String: Any] {
            status = dictionary["status"] as? String ?? "fail"
        }
        return status
    }

}
