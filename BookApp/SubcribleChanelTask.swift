//
//  SubcribleChanelTask.swift
//  BookApp
//
//  Created by kien le van on 9/5/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class SubcribleChanelTask: BaseTaskNetwork {
    
    private let _memberID: Int!
    private let _chanelID: Int!
    private let _token: String!
    
    init(memberID: Int, chanelID: Int, token: String) {
        _memberID = memberID
        _chanelID = chanelID
        _token = token
    }
    
    override func path() -> String! {
        return subcribleURL
    }
    
    override func method() -> String! {
        return POST
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["member_id": _memberID,
                "object_id": _chanelID,
                "access_token": _token]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        if let dictionary = response as? [String: Any] {
            if dictionary["data"] != nil {
                return Subcrible.subcrible
            } else {
                return Subcrible.unSubcrible
            }
        }
        return response
    }
}
