//
//  GetNewsForTypeTask.swift
//  BookApp
//
//  Created by kien le van on 10/17/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetNewsForTypeTask: BaseTaskNetwork {

    private var _typeID: Int!
    private var _page: Int!
    
    init(typeID: Int, page: Int) {
        _typeID = typeID
        _page = page
    }
    
    override func path() -> String! {
        return getNewsForTypeURL
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["category": _typeID, "page": _page]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        var araayNews: [NewsModel] = []
        if let object = response as? [[String: Any]] {
            for dictionary in object {
                let news: NewsModel = parseNews(dictionary: dictionary)
                araayNews.append(news)
            }
        }
        return araayNews
    }
}
