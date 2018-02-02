//
//  BuyBookTask.swift
//  BookApp
//
//  Created by le kien on 1/26/18.
//

import UIKit
import LCNetwork

class BuyBookTask: BaseTaskNetwork {
    
    private let idMember: Int
    private let token: String
    private let bookID: Int
    private let nameUser: String
    private let phone: Int
    private let address: String
    
    init(idMember: Int, token: String, bookID: Int, nameUser: String, phone: Int, address: String) {
        self.idMember = idMember
        self.token = token
        self.bookID = bookID
        self.nameUser = nameUser
        self.phone = phone
        self.address = address
    }

    override func path() -> String! {
        return buyBookPointURL
    }
    
    override func method() -> String! {
        return POST
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["member_id": idMember,
                "access_token": token,
                "book_id": bookID,
                "recipient_name": nameUser,
                "recipient_phone": phone,
                "recipient_address": address]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        guard let dictionary = response as? [String: Any] else {
            return response
        }
        let statusCode = dictionary["status_code"] as? Int ?? 0
        if let status = ErrorCode(rawValue: statusCode), status == ErrorCode.success {
            return status
        }
        return response
    }
}
