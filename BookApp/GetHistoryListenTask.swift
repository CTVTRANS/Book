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
    private let _type: Int!
    
    init(memberID: Int, token: String, type: Int) {
        _memberID = memberID
        _token = token
        _type = type
    }

    override func path() -> String! {
        return getHistoryLessonURL
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["member_id": _memberID,
                "access_token": _token,
                "history_type": _type]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        var listLesson: [Lesson] = []
        var listBook: [Book] = []
        var isLesson = false
        if let responseObject = response as? [String: Any] {
            if let data = responseObject["data"] as? [[String: Any]] {
                for dictionary in data {
                    let chapter = dictionary["chapter"]
                    if chapter != nil {
                        isLesson = true
                        let lesson = parseLesson(dictionary: dictionary)
                        listLesson.append(lesson)
                    } else {
                        let book = parseBook(dictionary: dictionary)
                        listBook.append(book)
                    }
                }
            }
        }
        if isLesson {
            return listLesson
        } else {
            return listBook
        }
    }
}
