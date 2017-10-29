//
//  GetGroupJoinedTask.swift
//  BookApp
//
//  Created by kien le van on 9/12/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetGroupJoinedTask: BaseTaskNetwork {
    
    private var _idMember: Int!
    
    init(idMember: Int) {
        _idMember = idMember
    }

    override func path() -> String! {
        return getAllGroupJoinedURL
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["member_id": _idMember]
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
