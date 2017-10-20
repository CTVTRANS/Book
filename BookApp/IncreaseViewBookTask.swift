//
//  IncreaseViewBookTask.swift
//  BookApp
//
//  Created by kien le van on 10/16/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class IncreaseViewBookTask: BaseTaskNetwork {
    
    private var _idBook: Int!
    
    init(idBook: Int) {
        _idBook = idBook
    }
    
    override func path() -> String! {
        return increaseViewBokoURL
    }

    override func method() -> String! {
        return GET
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["book_id": _idBook]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        return response
    }
}
