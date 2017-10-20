//
//  GetListProductByPoint.swift
//  BookApp
//
//  Created by kien le van on 9/15/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetListProductByPointTask: BaseTaskNetwork {
    
    private var _limit: Int!
    private var _page: Int!
    
    init(limit: Int, page: Int) {
        _limit = limit
        _page = page
    }
    
    override func path() -> String! {
        return getAllProductByPointURL
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["lang": Constants.sharedInstance.language, "limit": _limit, "page": _page]
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
