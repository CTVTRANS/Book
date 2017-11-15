//
//  GetAllTypeNewsTask.swift
//  BookApp
//
//  Created by kien le van on 9/18/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetAllTypeNewsTask: BaseTaskNetwork {

    override func path() -> String! {
        return getAllTypeNewsURL
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["lang": Constants.sharedInstance.language]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        if let object = response as? [[String: Any]] {
           Constants.sharedInstance.listNewsType = parseTypeMenu(object: object)
        }
        return response
    }
}
