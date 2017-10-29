//
//  GetHotKeyWordTask.swift
//  BookApp
//
//  Created by kien le van on 10/6/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetHotKeyWordTask: BaseTaskNetwork {
    
    private var _type: Int!
    
    init(type: Int) {
        _type = type
    }
    
    override func path() -> String! {
         return getHotKeyWordURL
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["search_type": _type, "lang": Constants.sharedInstance.language, "limit": 15]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        var listKeyWord: [String] = []
        if let object = response as? [[String: Any]] {
            for dictionary in object {
                let keyword = dictionary["keyword"] as? String
                listKeyWord.append(keyword!)
            }
        }
        return listKeyWord
    }

}
