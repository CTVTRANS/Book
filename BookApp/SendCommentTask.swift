//
//  SendCommentTask.swift
//  BookApp
//
//  Created by kien le van on 8/29/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class SendCommentTask: BaseTaskNetwork {
    private let _commentType: Int
    private let _memberID: Int
    private let _objectID: Int
    private let _content: String
    private let _token: String
    
    init(commentType: Int, memberID: Int, objectId: Int, content: String, token: String) {
        _commentType = commentType
        _memberID = memberID
        _objectID = objectId
        _content = content
        _token = token
    }

    override func path() -> String! {
        return sendCommentURL
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["comment_type": _commentType,
                "member_id": _memberID,
                "object_id": _objectID,
                "content": _content,
                "access_token": _token]
    }
    
    override func method() -> String! {
        return POST
    }
    
    override func data(withResponse response: Any!) -> Any! {
        return response
    }
}
