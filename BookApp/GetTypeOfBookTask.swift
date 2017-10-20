//
//  GetBookTask.swift
//  BookApp
//
//  Created by kien le van on 8/25/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetTypeOfBookTask: BaseTaskNetwork {

    override func path() -> String! {
        return getBookTypeURL
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["lang": Constants.sharedInstance.language]
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func data(withResponse response: Any!) -> Any! {
        var listType = [BookType]()
        if let listObject = response as? [[String: Any]] {
            for dictionary in listObject {
                let nameType = dictionary["cat_name"] as? String ?? "abc"
                let imageURLType = dictionary["cat_image"] as? String ?? "123"
                let idType = dictionary["cat_id"] as? Int ?? 0
                let descriptionType = dictionary["cat_description"] as? String ?? "123"
                let typeBook: BookType = BookType(name: nameType,
                                                  image: imageURLType,
                                                  typeID: idType,
                                                  description: descriptionType)
                listType.append(typeBook)
            }
        }
        Constants.sharedInstance.listBookType = listType
        return response
    }
}
