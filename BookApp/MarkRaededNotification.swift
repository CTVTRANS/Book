//
//  MarkRaededNotification.swift
//  BookApp
//
//  Created by kien le van on 10/10/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class MarkRaededNotification: BaseTaskNetwork {
    
    var idMember: Int!
    var arrayNoticeID: String!
    var token: String!
    
    init(memberID: Int, arrayID: String, token: String) {
        self.idMember = memberID
        self.arrayNoticeID = arrayID
        self.token = token
    }
    
    override func method() -> String! {
        return POST
    }
    
    override func path() -> String! {
        return markReadNoticeURL
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["member_id": idMember, "object_id": arrayNoticeID, "access_token": token]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        return response
    }
}
