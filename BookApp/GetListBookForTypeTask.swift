//
//  GetListBookForTypeTask.swift
//  BookApp
//
//  Created by kien le van on 8/25/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetListBookForTypeTask: BaseTaskNetwork {
    
    private let _category: Int!
    private let _page: Int!
    private let _orderBy: String!
    
    init(category: Int, page: Int, orderBy: String) {
        _category = category
        _page = page
        _orderBy = orderBy
    }

    override func path() -> String! {
        return getBookForEachTypeURL
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["category": _category, "limit": 30, "page": _page, "orderby": _orderBy]
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func data(withResponse response: Any!) -> Any! {
        var listBook: [Book] = []
        if let listObject = response as? [[String: Any]] {
            for dictionary in listObject {
                let book = self.parseBook(dictionary: dictionary)
                listBook.append(book)
            }
        }
        return listBook
    }
}
