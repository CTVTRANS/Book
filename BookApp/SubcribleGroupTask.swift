//
//  SubcribleGroupTask.swift
//  BookApp
//
//  Created by kien le van on 9/15/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class SubcribleGroupTask: BaseTaskNetwork {
    
    private var _arrayIDGroup: String!
    private var _memberID: Int
    private var _token: String!
    
    init(memberID: Int, arryID: String, token: String) {
        _memberID = memberID
        _arrayIDGroup = arryID
        _token = token
    }
    
    override func path() -> String! {
        return subcribleGroupURL
    }
    
    override func method() -> String! {
        return POST
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["member_id": _memberID, "object_id": _arrayIDGroup, "access_token": _token]
    }

    override func data(withResponse response: Any!) -> Any! {
        if let dictionary = response as? [String: Any] {
            let status = dictionary["status"] as? String ?? ""
            if status == "success" {
                return true
            }
        }
        return false
    }
}
