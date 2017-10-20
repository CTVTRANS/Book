//
//  SearchTask.swift
//  BookApp
//
//  Created by kien le van on 9/18/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class SearchBookTask: BaseTaskNetwork {

    private var _keyWord: String!
    private var _page: Int!
    
    init(keyWord: String, page: Int) {
        _keyWord = keyWord
        _page = page
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["keyword": _keyWord,
                "lang": Constants.sharedInstance.language,
                "limit": 30,
                "page": _page]
    }
    
    override func path() -> String! {
        return searchBookURL
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func data(withResponse response: Any!) -> Any! {
        var listBook: [Book] = []
        if let object = response as? [[String: Any]] {
            for dictionary in object {
                let book = parseBook(dictionary: dictionary)
                listBook.append(book)
            }
        }
        return listBook
    }
}
