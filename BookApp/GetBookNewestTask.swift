//
//  GetBookNewestTask.swift
//  BookApp
//
//  Created by kien le van on 8/28/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetBookNewestTask: BaseTaskNetwork {
    
    private let _limit: Int!
    
    init(limit: Int) {
        _limit = limit
    }
    
    override func path() -> String! {
        return getBookNewestURL
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["lang": Constants.sharedInstance.language, "limit": _limit]
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func data(withResponse response: Any!) -> Any! {
        var bookNewest: Book?
        if let object = response as? [[String: Any]] {
            if object.count > 0 {
                let dictionary = object[0]
                bookNewest = self.parseBook(dictionary: dictionary)
                return bookNewest
            }
        }
        return response
    }
}
