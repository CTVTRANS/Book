//
//  GetNewsInGroupTask.swift
//  BookApp
//
//  Created by kien le van on 9/12/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetNewsInGroupTask: BaseTaskNetwork {
    
    private var _idGroup: Int!
    private var _page: Int!
    private var _limit: Int!
    
    init(idGroup: Int, limit: Int, page: Int) {
        _idGroup = idGroup
        _page = page
        _limit = limit
    }
    
    override func path() -> String! {
        return getListNewsInGroupURL
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["group_id": _idGroup, "limit": _limit, "page": _page]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        var listPost: [NewsInGroups] = []
        if let object = response as? [[String: Any]] {
            for dictionary in object {
                let news = parseNewsGroup(dictionary: dictionary)
                listPost.append(news)
            }
        }
        return listPost
    }
}

extension BaseTaskNetwork {
    func parseNewsGroup(dictionary: [String: Any]) -> NewsInGroups {
        let idNews = dictionary["id"] as? Int ?? 0
        let imageURL = dictionary["image"] as? String ?? ""
        let title = dictionary["title"] as? String ?? ""
        let descriptionNews = dictionary["description"] as? String ?? ""
        let content = dictionary["content"] as? String ?? ""
        let time = dictionary["updated_at"] as? String ?? ""
        
        let news = NewsInGroups(idNews: idNews,
                                image: imageURL,
                                title: title,
                                descriptionNews: descriptionNews,
                                content: content, time: time)
        return news
    }
}
