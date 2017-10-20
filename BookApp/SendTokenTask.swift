//
//  SendTokenTask.swift
//  BookApp
//
//  Created by kien le van on 10/13/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class SendTokenTask: BaseTaskNetwork {
    
    private let lang = Constants.sharedInstance.language
    
    override func path() -> String! {
        return sendDeviceTokenURL
    }

    override func method() -> String! {
        return POST
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        var token = ProfileMember.getDeviceToken()!
        if token == "" {
            token = "2ca6ac47473e93145715cd1df8dfc939e00616c77"
        }
        return ["platform": 1, "phone_id": token, "lang": lang]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        return response
    }
}
