//
//  GetProductVip.swift
//  BookApp
//
//  Created by kien le van on 9/15/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetProductVipTask: BaseTaskNetwork {
    
    override func path() -> String! {
        return getAllVipProductURL
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["lang": Constants.sharedInstance.language]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        var listVip: [Vip] = []
        if let object = response as? [[String: Any]] {
            for dictionary in object {
                let vip = self.parseVip(dictionary: dictionary)
                listVip.append(vip)
            }
        }
        return listVip
    }

}
