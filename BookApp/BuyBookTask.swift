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
    private let type: Int
    private let bookID: Int
    private let nameUser: String
    private let phone: Int
    private let address: String
    
    init(idMember: Int, token: String, type: Int, bookID: Int, nameUser: String, phone: Int, address: String) {
        self.idMember = idMember
        self.token = token
        self.type = type
        self.bookID = bookID
        self.nameUser = nameUser
        self.phone = phone
        self.address = address
    }

    override func path() -> String! {
        return buyBookURL
    }
    
    override func method() -> String! {
        return POST
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["member_id": idMember,
                "access_token": token,
                "payment_type": type,
                "book_id": bookID,
                "recipient_name": nameUser,
                "recipient_phone": phone,
                "recipient_address": address]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        return response
    }
}
