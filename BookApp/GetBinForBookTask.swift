//
//  GetBinForBookTask.swift
//  BookApp
//
//  Created by le kien on 2/1/18.
//

import UIKit
import LCNetwork

class GetBinForBookTask: BaseTaskNetwork {
    
    private let idMember: Int
    private let token: String
    private let bookID: Int
    private let nameUser: String
    private let phone: Int
    private let address: String
    private let mark: String
    private let point: String
    
    init(idMember: Int, token: String, bookID: Int, point: String, mark: String, nameUser: String, phone: Int, address: String) {
        self.idMember = idMember
        self.token = token
        self.bookID = bookID
        self.nameUser = nameUser
        self.phone = phone
        self.address = address
        self.mark = mark
        self.point = point
    }

    override func path() -> String! {
        return getBinForBookURL
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
                "recipient_address": address,
                "point": point,
                "money": mark]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        if let dictionary = response as? [String: Any] {
            let data = dictionary["data"] as? [String: Any] ?? ["": ""]
            let orderNo = data["order_no"] as? String ?? ""
            let oderSign = data["orders_sign"] as? String ?? ""
            return (orderNo, oderSign)
        }
        return response
    }
}
