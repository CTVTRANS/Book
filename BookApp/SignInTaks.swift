//
//  SignInTaks.swift
//  BookApp
//
//  Created by kien le van on 10/4/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class SignInTaks: BaseTaskNetwork {

    private var country: Int!
    private var phone: Int!
    private var pass: String!
    private var _deviceToken: String!
    private var _device: Int!
    
    init(countryCode: Int, phoneNumerber: Int, password: String) {
        country = countryCode
        phone = phoneNumerber
        pass = password
    }
    
    override func method() -> String! {
        return POST
    }
    
    override func path() -> String! {
        return sigInURL
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        _deviceToken = ProfileMember.getDeviceToken()
        if _deviceToken == "" || _deviceToken == nil {
            _deviceToken = "kjahsdjfhskjdhfkasjdhfkajsdfkljasdkjfasdfadsf"
        }
        return ["country_code": country,
                "phone_number": phone,
                "password": pass,
                "phone_id": _deviceToken,
                "platform": 1]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        if let dictionary = response as? [String: Any] {
            print(dictionary)
            let status = dictionary["status"] as? String ?? ""
            let statusCode = dictionary["status_code"] as? Int ?? 0
            if status == "success" {
                let data = dictionary["data"] as? [String: Any]
                let tokenMember = data?["access_token"] as? String ?? ""
                var profile = ProfileMember.getProfile()
                profile = paresMember(dictionary: data!)
                profile?.token = tokenMember
                ProfileMember.saveToken(token: tokenMember)
                ProfileMember.saveProfile(myProfile: profile!)
                return (true, ErrorCode.success)
            } else {
                let error = ErrorCode(rawValue: statusCode)
                return (false, error)
            }
        }
        return response
    }
}
