//
//  ChangePasswordTask.swift
//  BookApp
//
//  Created by kien le van on 10/9/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class ChangePasswordTask: BaseTaskNetwork {
    
    private var _memberID: Int!
    private var _oldPass: String!
    private var _newPass: String!
    private var _confimPass: String!
    private var _token: String!
    
    init(memberID: Int, oldPass: String, newPass: String, confirmPass: String, token: String) {
        _memberID = memberID
        _oldPass = oldPass
        _newPass = newPass
        _confimPass = confirmPass
        _token = token
    }
    
    override func method() -> String! {
        return POST
    }
    
    override func path() -> String! {
        return upDatePasswordURL
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["member_id": _memberID,
                "old_password": _oldPass,
                "new_password": _newPass,
                "confirm_password": _confimPass,
                "access_token": _token]
    }
    override func data(withResponse response: Any!) -> Any! {
        if let dictionary = response as? [String: Any] {
            let status = dictionary["status"] as? String ?? ""
            let statusCode = dictionary["status_code"] as? Int ?? 0
            let token = dictionary["new_access_token"] as? String ?? ""
            if status == "success" {
                ProfileMember.saveToken(token: token)
                return (true, "success")
            }
            return (false, String(statusCode))
        }
        return response
    }
}
