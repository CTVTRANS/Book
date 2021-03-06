//
//  GetHotChanelTask.swift
//  BookApp
//
//  Created by kien le van on 9/6/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetHotChanelTask: BaseTaskNetwork {
    
    private let _page: Int!
    private let _idMember: Int
    
    init(idMember: Int, page: Int) {
        _page = page
        _idMember = idMember
    }
    
    override func path() -> String! {
        return getHotChanel
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["lang": Constants.sharedInstance.language, "limit": 30, "page": _page, "member_id": _idMember]
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
