//
//  BuyVipPointTask.swift
//  BookApp
//
//  Created by kien le van on 10/18/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class BuyVipPointTask: BaseTaskNetwork {
    
    private let _memberID: Int!
    private let _token: String!
    private let _type: Int!
    private let _idVip: Int!
    private let _numberYear: Int!
    
    init(memberiD: Int, token: String, type: Int, idVip: Int, numberYear: Int) {
        _memberID = memberiD
        _token = token
        _type = type
        _idVip = idVip
        _numberYear = numberYear
    }

    override func path() -> String! {
        return buyVipPointURL
    }
    
    override func method() -> String! {
        return POST
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["member_id": _memberID,
                "access_token": _token,
                "payment_type": _type,
                "package_id": _idVip,
                "period": _numberYear]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        if let dictionary = response as? [String: Any] {
            let status = dictionary[""] as? String ?? ""
            if status == "success" {
                return true
            }
        }
        return false
    }
}
