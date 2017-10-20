//
//  GetAllChanelSubcribledTask.swift
//  BookApp
//
//  Created by kien le van on 9/5/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetAllChanelSubcribledTask: BaseTaskNetwork {

    private let _memberID: Int!
    
    init(memberID: Int) {
        _memberID = memberID
    }
    
    override func path() -> String! {
        return getAllSubcribled
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["member_id": _memberID]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        var listChanel: [Chanel] = []
        if let object = response as? [[String: Any]] {
            for dictionary in object {
                let chanel = parseChanel(dictionary: dictionary)
                listChanel.append(chanel)
            }
            Constants.sharedInstance.listChanelSubcribled = listChanel
        }
        return true
    }
}
