//
//  GetHistoryBuyVipTask.swift
//  BookApp
//
//  Created by kien le van on 10/23/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetHistoryBuyVipTask: BaseTaskNetwork {

    private let _idmember: Int!
    private let _token: String!
    
    init(idmember: Int, token: String) {
        _idmember = idmember
        _token = token
    }
    
    override func path() -> String! {
        return getHistoryVipURL
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["member_id": _idmember, "access_token": _token]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        var historyBuyVip: [HistoryBuy] = []
        if let responseObject = response as? [[String: Any]] {
            for historyBin in responseObject {
                let idBin = historyBin["id"] as? Int ?? 0
                let paymentType = historyBin["payment_type"] as? Int ?? 0
                let amount = historyBin["amount"] as? Int ?? 0
                let point = historyBin["point"] as? Int ?? 0
                let money = historyBin["money"] as? Int ?? 0
                let time = historyBin["created_at"] as? String ?? ""
                let status = historyBin["payment_status"] as? Int ?? 0
                let dictionay = historyBin["product"] as? [String: Any] ?? ["": ""]
                let product = parseVip(dictionary: dictionay)
                let history = HistoryBuy(idBin: idBin,
                                            paymemType: paymentType,
                                            status: status,
                                            time: time,
                                            amount: amount,
                                            point: point,
                                            money: money,
                                            prouct: product,
                                            book: nil)
                historyBuyVip.append(history)
            }
        }
        return historyBuyVip
    }
}
