//
//  CheckBookMarkedTask.swift
//  BookApp
//
//  Created by kien le van on 9/4/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class CheckBookMarkedTask: BaseTaskNetwork {

    private let _bookMarkType: Int
    private let _memberID: Int
    private let _objectID: Int
    
    init(bookMarkType: Int, memberID: Int, objectID: Int) {
        _bookMarkType = bookMarkType
        _memberID = memberID
        _objectID = objectID
    }
    
    override func path() -> String! {
        return checkBookMarkedURL
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["collection_type": _bookMarkType, "member_id": _memberID, "object_id": _objectID]
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func data(withResponse response: Any!) -> Any! {
        if let dictionary = response as? [String: Any] {
            let totalNumberBookMark = dictionary["total_collected"] as? Int ?? 0
            let status = dictionary["is_collected"] as? Bool
            if status! {
                return (true, totalNumberBookMark)
            } else {
                return (false, totalNumberBookMark)
            }
        }
        return false
    }
}
