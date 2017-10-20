//
//  RegisterTask.swift
//  BookApp
//
//  Created by kien le van on 10/4/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class RegisterTask: BaseTaskNetwork {
    
    private var country: Int!
    private var phone: Int!
    private var code: Int!
    private var pass: String!
    private var name: String!
    
    init(countryCode: Int, phoneNumber: Int, codeConfirm: Int, name: String, password: String) {
        country = countryCode
        phone = phoneNumber
        code = codeConfirm
        pass = password
        self.name = name
    }

    override func method() -> String! {
        return POST
    }
    
    override func path() -> String! {
        return registerURL
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["country_code": country, "phone_number": phone,
                "confirm_code": code, "name": name, "password": pass]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        if let dictionary = response as? [String: Any] {
            let status = dictionary["status"] as? String ?? ""
            let statusCode = dictionary["status_code"] as? Int ?? 0
            let error = ErrorCode(rawValue: statusCode)
            if status == "success" {
                return (true, error)
            }
            return (false, error)
        }
        return response
    }
}
