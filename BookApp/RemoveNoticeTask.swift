//
//  RemoveNoticeTask.swift
//  BookApp
//
//  Created by kien le van on 10/11/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class RemoveNoticeTask: BaseTaskNetwork {

    private var _memberID: Int!
    private var _noticeID: Int!
    private var _token: String!
    
    init(memberID: Int, noticeID: Int, token: String) {
        _memberID = memberID
        _noticeID = noticeID
        _token = token
    }
    
    override func path() -> String! {
        return removeNoticeURL
    }
    
    override func method() -> String! {
        return POST
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["member_id": _memberID, "object_id": _noticeID, "access_token": _token]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        return response
    }
}
