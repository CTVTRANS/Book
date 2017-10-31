//
//  RemoveHistoryAudioTask.swift
//  BookApp
//
//  Created by Kien on 10/30/17.
//
//

import UIKit
import LCNetwork

class RemoveHistoryAudioTask: BaseTaskNetwork {
    
    private let _idMember: Int!
    private let _token: String!
    private let _type: Int!
    private let _idObject: Int!
    
    init(memberID: Int, token: String, type: Int, idObject: Int) {
        _idMember = memberID
        _token = token
        _type = type
        _idObject = idObject
    }
    
    override func path() -> String! {
        return removeHistoryaudioURL
    }
    
    override func method() -> String! {
        return POST
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["member_id": _idMember,
                "access_token": _token,
                "history_type": _type,
                "object_id": _idObject]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        return response
    }
    
}
