//
//  HIstoryBuyVip.swift
//  BookApp
//
//  Created by kien le van on 10/23/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class HistoryBuy: NSObject {
    
    var idBin: Int!
    var paymentType: Int!
    var status: Int!
    var time: String!
    var point: Int!
    var money: Int!
    var amount: Int!
    var productVip: Vip?
    var producBook: Book?
    
    init(idBin: Int, paymemType: Int, status: Int, time: String, amount: Int, point: Int, money: Int, prouct: Vip?, book: Book?) {
        self.idBin = idBin
        self.paymentType = paymemType
        self.status = status
        self.time = time
        self.amount = amount
        self.point = point
        self.money = money
        self.productVip = prouct
        self.producBook = book
    }
}
