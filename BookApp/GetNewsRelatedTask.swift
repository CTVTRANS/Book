//
//  GetNewsRelatedTask.swift
//  BookApp
//
//  Created by kien le van on 10/10/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetNewsRelatedTask: BaseTaskNetwork {
    
    private var _idNew: Int!
    
    init(idCurrentNews: Int) {
        _idNew = idCurrentNews
    }

    override func path() -> String! {
        return getNewRelatedURL
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["post_id": _idNew]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        if let dictionary = response as? [String: Any] {
            let news = parseNews(dictionary: dictionary)
            return news
        }
        return response
    }
}
