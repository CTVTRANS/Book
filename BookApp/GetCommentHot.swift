//
//  GetCommentHot.swift
//  BookApp
//
//  Created by kien le van on 8/31/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetCommentHot: BaseTaskNetwork {

    private let _commentType: Int!
    private let _idObject: Int!
    private let _memberId: Int!
    
    init(commentType: Int, idObject: Int, memberID: Int) {
        _commentType = commentType
        _idObject = idObject
        _memberId = memberID
    }
    
    override func path() -> String! {
        return getAllCommentHotURL
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["comment_type": _commentType,
                "object_id": _idObject,
                "member_id": _memberId]
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func data(withResponse response: Any!) -> Any! {
        var listComment: [Comment] = []
        if let object = response as? [[String: Any]] {
            for dictionary in object {
                let commentObject = parseComment(dictionary: dictionary)
                listComment.append(commentObject)
            }
        }
        return listComment
    }
}
