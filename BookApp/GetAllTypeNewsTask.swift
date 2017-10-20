//
//  GetAllTypeNewsTask.swift
//  BookApp
//
//  Created by kien le van on 9/18/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetAllTypeNewsTask: BaseTaskNetwork {

    override func path() -> String! {
        return getAllTypeNewsURL
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["lang": Constants.sharedInstance.language]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        if let object = response as? [[String: Any]] {
           Constants.sharedInstance.listNewsType = parseTypeNews(object: object)
        }
        return response
    }
}

extension BaseTaskNetwork {
    func parseTypeNews(object: [[String: Any]]) -> [NewsType] {
        var listTypeNew: [NewsType] = []
        for dictionary in object {
            let idType = dictionary["cat_id"] as? Int ?? 0
            let parentID = dictionary["parent_id"] as? Int ?? 0
            let nameType = dictionary["cat_name"] as? String ?? ""
            let descriptionType = dictionary["cat_description"] as? String ?? ""
            let type: NewsType = NewsType(idType: idType,
                                          parentID: parentID,
                                          nameType: nameType,
                                          desciptionType: descriptionType)
            let miniArray = [type]
            listTypeNew += miniArray
            if let typeSun = dictionary["cat_children"] as? [[String: Any]] {
                listTypeNew += parseTypeNews(object: typeSun)
            }
        }
        return listTypeNew
    }
}
