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
    
    private let _idMember: Int
    private let _page: Int!
    
    init(idMember: Int, page: Int) {
        _idMember = idMember
        _page = page
    }
    
    override func path() -> String! {
        return getChanelFreeURL
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["lang": Constants.sharedInstance.language, "limit": 3,
                "page": _page, "member_id": _idMember]
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
