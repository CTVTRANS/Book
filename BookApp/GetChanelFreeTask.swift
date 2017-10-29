//
//  GetChanelFreeTask.swift
//  BookApp
//
//  Created by kien le van on 9/5/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetChanelFreeTask: BaseTaskNetwork {
    
    private let _lang: Int!
    private let _limit: Int!
    private let _page: Int!
    
    init(lang: Int, limit: Int, page: Int) {
        _lang = lang
        _limit = limit
        _page = page
    }
    
    override func path() -> String! {
        return getChanelFreeURL
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["lang": _lang, "limit": _limit, "page": _page]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        var listChanel: [Chanel] = []
        if let object = response as? [[String: Any]] {
            for dictionary in object {
                let chanel = parseChanel(dictionary: dictionary)
                listChanel.append(chanel)
            }
        }
        return listChanel
    }
}
