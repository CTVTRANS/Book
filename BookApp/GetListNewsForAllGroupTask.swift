//
//  GetListNewsForAllGroupTask.swift
//  BookApp
//
//  Created by kien le van on 10/11/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetListNewsForAllGroupTask: BaseTaskNetwork {
    
    private var _memberID: Int!

    init(memberID: Int) {
        _memberID = memberID
    }
    
    override func path() -> String! {
        return getListNewsForAllGroupURL
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["limit": 1000, "page": 1, "member_id": _memberID]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        var listNews: [NewsInGroups] = []
        if let list = response as? [[String: Any]] {
            for objec in list {
                let newsDictionay = objec["news"] as? [String: Any]
                let news = parseNewsGroup(dictionary: newsDictionay!)
                let groupDictionay = objec["group"] as? [String: Any]
                let group = parseGroup(dictionary: groupDictionay!)
                news.groupOwner = group
                listNews.append(news)
            }
        }
        return listNews
    }
}
