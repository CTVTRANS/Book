//
//  UpdateMemberTask.swift
//  BookApp
//
//  Created by kien le van on 10/4/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class UpdateMemberTask: BaseTaskNetwork {

    private var _memberID: Int!
    private var _token: String!
    private var _nameMemner: String
    private var _email: String
    private var _sex: Int
    private var _birthDay: String
    private var _job: String
    private var _status: Int
    private var _hobby: String
    
    init(memberID: Int!, token: String!, nameMember: String, email: String, sex: Int, birthDay: String, job: String, status: Int, hobby: String) {
        _memberID = memberID
        _token = token
        _nameMemner = nameMember
        _email = email
        _sex = sex
        _birthDay = birthDay
        _job = job
        _status = status
        _hobby = hobby
    }
    
    override func method() -> String! {
         return POST
    }
    
    override func path() -> String! {
         return upDateInfomationMemberURL
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["member_id": _memberID, "access_token": _token,
                "name": _nameMemner, "email": _email, "gender": _sex,
                "birthday": _birthDay, "job": _job,
                "marriage": _status, "hobby": _hobby]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        return response
    }
}
