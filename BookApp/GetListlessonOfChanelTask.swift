//
//  GetListlessonOfChanel.swift
//  BookApp
//
//  Created by kien le van on 9/5/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetListlessonOfChanelTask: BaseTaskNetwork {

    private let _chanelID: Int!
    private let _page: Int!
    
    init(chanelID: Int, page: Int) {
        _chanelID = chanelID
        _page = page
    }
    
    override func path() -> String! {
        return getListLessonOfChanelURL
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["teacher_id": _chanelID, "limit": 30, "page": _page]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        var listLesson: [Lesson] = []
        if let object = response as? [[String: Any]] {
            for dictionary in object {
                let lesson = parseLesson(dictionary: dictionary)
                listLesson.append(lesson)
            }
        }
        return listLesson
    }
}
