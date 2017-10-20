//
//  GetAllGroupTask.swift
//  BookApp
//
//  Created by kien le van on 9/12/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetAllGroupTask: BaseTaskNetwork {
    
    private var _memberID: Int!
    
    init(memberID: Int) {
        _memberID = memberID
    }
    
    override func path() -> String! {
        return getAllGroupURL
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["lang": Constants.sharedInstance.language, "member_id": _memberID]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        var listGroup: [SecrectGroup] = []
        if let object = response as? [[String: Any]] {
            for dictionary in object {
                let group = parseGroup(dictionary: dictionary)
                listGroup.append(group)
            }
        }
        return listGroup
    }
}
