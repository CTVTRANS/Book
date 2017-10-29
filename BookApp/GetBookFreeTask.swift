//
//  GetBookFree.swift
//  BookApp
//
//  Created by kien le van on 8/30/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetBookFreeTask: BaseTaskNetwork {
    
    private let _limit: Int!
    private let _page: Int!
    
    init(limit: Int, page: Int) {
        _limit = limit
        _page = page
    }
    
    override func path() -> String! {
        return getAllBookFreeURL
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["lang": Constants.sharedInstance.language,
                "limit": _limit,
                "page": _page]
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func data(withResponse response: Any!) -> Any! {
        var listBook: [Book] = []
        if let object = response as? [[String: Any]] {
            for dictionary in object {
                let book = self.parseBook(dictionary: dictionary)
                listBook.append(book)
            }
        }
        return listBook
    }
}
