//
//  UpdatePointTask.swift
//  BookApp
//
//  Created by kien le van on 10/7/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class UpdatePointTask: BaseTaskNetwork {

    private var _memberID: Int!
    private var _token: String!
    private var _typePoint: Int!
    
    init(memberID: Int, token: String, type: Int) {
        _memberID = memberID
        _token = token
        _typePoint = type
    }
    
    override func path() -> String! {
        return upDatePointURL
    }
    
    override func method() -> String! {
        return POST
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["member_id": _memberID,
                "access_token": _token,
                "type_point": _typePoint]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        var statusUpdate: Bool = false
        var pointCurrent: Int = 0
        if let object = response as? [String: Any] {
            let status = object["status"] as? String ?? ""
            if status == "success" {
                statusUpdate = true
            }
            if let dictionary = object["point"] as? [String: Any] {
                if let point = dictionary["current_point"] as? Int {
                    pointCurrent = point
                    return (statusUpdate, pointCurrent)
                }
            }
        }
        return (statusUpdate, pointCurrent)
    }
}
