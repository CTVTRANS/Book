//
//  GetCodeConfirm.swift
//  BookApp
//
//  Created by kien le van on 10/4/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetCodeConfirmTask: BaseTaskNetwork {

    private var code: Int!
    private var phone: Int!
    
    init(countryCode: Int, phoneNumber: Int) {
        code = countryCode
        phone = phoneNumber
    }
    
    override func method() -> String! {
        return POST
    }
    
    override func path() -> String! {
        return getCodeURL
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["country_code": code, "phone_number": phone]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        return response
    }
}
