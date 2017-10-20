//
//  SubcribleOneGroupTask.swift
//  BookApp
//
//  Created by kien le van on 10/11/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class SubcribleOneGroupTask: BaseTaskNetwork {

    private var _memberID: Int!
    private var _groupID: Int!
    private var _token: String!
    
    init(memberID: Int, groupID: Int, token: String) {
        _memberID = memberID
        _groupID = groupID
        _token = token
    }
    
    override func path() -> String! {
        return subcribleOneGroupURL
    }
    
    override func method() -> String! {
        return POST
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["member_id": _memberID, "object_id": _groupID, "access_token": _token]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        if let dictionary = response as? [String: Any] {
            let isSubcrible = dictionary["is_subscribe"] as? Bool ?? false
            if isSubcrible {
                return true
            }
        }
        return false
    }
}
