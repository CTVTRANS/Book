//
//  ListBookType.swift
//  BookApp
//
//  Created by kien le van on 8/25/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class ListBookType: NSObject {
    
    private var _listBookType = [BookType]()
    
    init(typeBook: BookType) {
        _listBookType.append(typeBook)
    }
}
