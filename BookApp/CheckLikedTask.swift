//
//  CheckLikedTask.swift
//  BookApp
//
//  Created by kien le van on 9/4/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class CheckLikedTask: BaseTaskNetwork {
    
    private let _likeType: Int
    private let _memberID: Int
    private let _objectID: Int
    
    init(likeType: Int, memberID: Int, objectID: Int) {
        _likeType = likeType
        _memberID = memberID
        _objectID = objectID
    }
    
    override func path() -> String! {
        return checkLikeedURL
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["like_type": _likeType, "member_id": _memberID, "object_id": _objectID]
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func data(withResponse response: Any!) -> Any! {
        if let dictionary = response as? [String: Any] {
            let status = dictionary["is_like"] as? Bool ?? false
            let numberLike = dictionary["number_of_likes"] as? Int ?? 0
            if status {
                return (true, numberLike)
            } else {
                return (false, numberLike)
            }
        }
        return false
    }
}
