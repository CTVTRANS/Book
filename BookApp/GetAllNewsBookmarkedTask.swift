//
//  GetAllNewsBookmarkedTask.swift
//  BookApp
//
//  Created by kien le van on 9/20/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetAllNewsBookmarkedTask: BaseTaskNetwork {

    private var _page: Int!
    private var _memberID: Int!
    
    init(memberId: Int, page: Int) {
        _memberID = memberId
        _page = page
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func path() -> String! {
        return getAllNewsBookmarkedURL
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["member_id": _memberID,
                "limit": 30,
                "page": _page]
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
