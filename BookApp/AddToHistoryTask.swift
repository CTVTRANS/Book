//
//  AddToHistoryTask.swift
//  BookApp
//
//  Created by kien le van on 10/23/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class AddToHistoryTask: BaseTaskNetwork {

    private let _idmember: Int!
    private let _token: String!
    private let _objectID: Int!
    private let _type: Int!
    
    init(memberid: Int, token: String, type: Int, lessonID: Int) {
        _idmember = memberid
        _token = token
        _type = type
        _objectID = lessonID
    }
    
    override func method() -> String! {
         return POST
    }
    
    override func path() -> String! {
        return addToHistoryURL
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["member_id": _idmember,
                "access_token": _token,
                "history_type": _type,
                "object_id": _objectID]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        return response
    }
}
