//
//  LikeTask.swift
//  BookApp
//
//  Created by kien le van on 8/29/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class LikeTask: BaseTaskNetwork {
    
    private let _likeType: Int
    private let _memberID: Int
    private let _objectID: Int
    private let _token: String
    
    init(likeType: Int, memberID: Int, objectId: Int, token: String) {
        _likeType = likeType
        _memberID = memberID
        _objectID = objectId
        _token = token
    }
    
    override func path() -> String! {
        return likeUnlikeURL
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["like_type": _likeType,
                "member_id": _memberID,
                "object_id": _objectID,
                "access_token": _token]
    }
    
    override func method() -> String! {
        return POST
    }
    
    override func data(withResponse response: Any!) -> Any! {
        if let dictionary = response as? [String: Any] {
            if dictionary["data"] != nil {
                return Like.like
            } else {
                return Like.unLike
            }
        }
        return response
    }
}
