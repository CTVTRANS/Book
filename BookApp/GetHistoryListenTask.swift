//
//  GetHistoryListenTask.swift
//  BookApp
//
//  Created by kien le van on 10/23/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetHistoryListenTask: BaseTaskNetwork {
    
    private let _memberID: Int!
    private let _token: String!
    
    init(memberID: Int, token: String) {
        _memberID = memberID
        _token = token
    }

    override func path() -> String! {
        return getHistoryLessonURL
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["member_id": _memberID, "access_token": _token]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        var listLesson: [Lesson] = []
        if let responseObject = response as? [String: Any] {
            if let data = responseObject["data"] as? [[String: Any]] {
                for dictionary in data {
                    let lesson = parseLesson(dictionary: dictionary)
                    listLesson.append(lesson)
                }
            }
        }
        return listLesson
    }
}
