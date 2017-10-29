//
//  BookMark.swift
//  BookApp
//
//  Created by kien le van on 9/4/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class BookMarkTask: BaseTaskNetwork {
    
    private let _bookMarkType: Int
    private let _memberID: Int
    private let _objectID: Int
    private let _token: String
    
    init(bookMarkType: Int, memberID: Int, objectId: Int, token: String) {
        _bookMarkType = bookMarkType
        _memberID = memberID
        _objectID = objectId
        _token = token
    }
    
    override func path() -> String! {
        return bookMarkURL
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["collection_type": _bookMarkType,
                "member_id": _memberID,
                "object_id": _objectID,
                "access_token": _token]
    }
    
    override func method() -> String! {
        return POST
    }
    
    override func data(withResponse response: Any!) -> Any! {
        if let dictionary = response as? [String: Any] {
            if dictionary["data"] != nil {
                return BookMark.bookMark
            } else {
                return BookMark.unBookMark
            }
        }
        return response
    }

}
