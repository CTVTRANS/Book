//
//  ForgetPasswordTask.swift
//  BookApp
//
//  Created by kien le van on 10/9/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class ForgetPasswordTask: BaseTaskNetwork {

    private var _countryCode: Int!
    private var _phoneNumber: Int!
    private var _code: Int!
    private var _newPass: String!
    private var _confirmPass: String!
    
    init(country: Int, phone: Int, code: Int, newPass: String, confirmPass: String) {
        _countryCode = country
        _phoneNumber = phone
        _code = code
        _newPass = newPass
        _confirmPass = confirmPass
    }
    
    override func path() -> String! {
        return forgetPasswordURL
    }
    
    override func method() -> String! {
        return POST
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["country_code": _countryCode,
                "phone_number": _phoneNumber,
                "confirm_code": _code,
                "new_password": _newPass,
                "confirm_password": _confirmPass]
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
