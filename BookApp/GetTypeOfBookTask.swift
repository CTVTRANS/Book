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
        if let listObject = response as? [[String: Any]] {
            Constants.sharedInstance.listBookType = parseTypeMenu(object: listObject)
        }
        return response
    }
}

extension BaseTaskNetwork {
    func parseTypeMenu(object: [[String: Any]]) -> [MenuType] {
        var listBookType: [MenuType] = []
        for dictionary in object {
            let parenID = dictionary["parent_id"] as? Int ?? 0
            let nameType = dictionary["cat_name"] as? String ?? ""
            let imageURLType = dictionary["cat_image"] as? String ?? ""
            let idType = dictionary["cat_id"] as? Int ?? 0
            let descriptionType = dictionary["cat_description"] as? String ?? ""
            let typeBook: MenuType = MenuType(name: nameType,
                                              image: imageURLType,
                                              typeID: idType,
                                              description: descriptionType,
                                              parentID: parenID)
            let types = [typeBook]
            listBookType += types
            if let x = dictionary["cat_children"] as? [[String: Any]] {
                listBookType += parseTypeMenu(object: x)
            }
        }
        return listBookType
    }
}
