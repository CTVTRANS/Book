//
//  GetTotaViewOfChanel.swift
//  BookApp
//
//  Created by kien le van on 9/5/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetTotaViewOfChanel: BaseTaskNetwork {
    
    private let _chanelID: Int
    
    init(chanelID: Int) {
        _chanelID = chanelID
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["channel_id": _chanelID]
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func path() -> String! {
        return getTotalViewOfChanelURL
    }
    
    override func data(withResponse response: Any!) -> Any! {
        var numberView = 0
        if let dictionary = response as? [String: Any] {
            numberView = dictionary["number_of_play"] as? Int ?? 0
        }
        return numberView
    }

}
