//
//  GetNotificationTask.swift
//  BookApp
//
//  Created by kien le van on 10/3/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetNotificationTask: BaseTaskNetwork {
    
    private var _limit: Int!
    private var _page: Int!
    private var _memberID: Int!
    
    init(limit: Int, page: Int, memberID: Int) {
        _limit = limit
        _page = page
        _memberID = memberID
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func path() -> String! {
        return getNotification
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["lang": Constants.sharedInstance.language,
                "limit": _limit,
                "page": _page,
                "member_id": _memberID]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        var listNotification: [NotificationApp] = []
        if let object = response as? [[String: Any]] {
            for dictionary in object {
                let idNotification = dictionary["id"] as? Int ?? 0
                let title = dictionary["title"] as? String ?? ""
                let image = dictionary["image"] as? String ?? ""
                let detail = dictionary["notification_text"] as? String ?? ""
//                let appName = dictionary["description"] as? String ?? ""
                let appName = "BookApp"
                let isRead = dictionary["is_read"] as? Bool ?? false
                let time = dictionary["updated_at"] as? String ?? ""
                let notification = NotificationApp.init(idNotification, title: title, image: image, detailText: detail, appName: appName, readed: isRead, time: time)
                listNotification.append(notification)
            }
            return (listNotification.count, listNotification)
        }
        return false
    }
}
