//
//  GetAllNewsTask.swift
//  BookApp
//
//  Created by kien le van on 8/29/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetAllNewsTask: BaseTaskNetwork {
    
    private let _page: Int!
    
    init(page: Int) {
        _page = page
    }

    override func path() -> String! {
        return getAllNewsURL
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["lang": Constants.sharedInstance.language,
                "limit": 30,
                "page": _page]
    }
    
    override func method() -> String! {
        return GET
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
