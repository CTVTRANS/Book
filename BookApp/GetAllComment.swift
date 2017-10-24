//
//  GetAllComment.swift
//  BookApp
//
//  Created by kien le van on 8/30/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetAllComment: BaseTaskNetwork {
   
    private let _commentType: Int!
    private let _idObject: Int!
    private let _page: Int!
    private let _idMember: Int
    
    init(commentType: Int, idObject: Int, page: Int, idMember: Int) {
        _commentType = commentType
        _idObject = idObject
        _page = page
        _idMember = idMember
    }
    
    override func path() -> String! {
        return getAllCommentURL
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["comment_type": _commentType,
                "object_id": _idObject,
                "limit": 10,
                "page": _page,
                "member_id": _idMember]
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func data(withResponse response: Any!) -> Any! {
        var listComment: [Comment] = []
        if let object = response as? [[String: Any]] {
            for dictionary in object {
                let iDComment = dictionary["comment_id"] as? Int ?? 0
                let hotComment = Constants.sharedInstance.listCommentHot.filter({ (obj) -> Bool in
                    return obj.idComment == iDComment
                })
                if hotComment.count > 0 {
                    continue
                }
                let commentObject = parseComment(dictionary: dictionary)
                listComment.append(commentObject)
            }
        }
        return listComment
    }
}

extension BaseTaskNetwork {
    func parseComment(dictionary: [String: Any]) -> Comment {
        let iDComment = dictionary["comment_id"] as? Int ?? 0
        let contentcomment = dictionary["comment_content"] as? String ?? ""
        let timeComment = dictionary["comment_time"] as? String ?? ""
        let numberLikeComment = dictionary["number_of_likes"] as? Int ?? 0
        let userName = dictionary["author_name"] as? String ?? ""
        let userAvata = dictionary["author_avatar"] as? String ?? ""
        let status = dictionary["like_status"] as? Int ?? 0
        
        let user: User = User(name: userName, age: 18, sex: 1, avata: userAvata)
        let commentObject: Comment = Comment(idComment: iDComment,
                                             user: user,
                                             time: timeComment,
                                             numberlikeComment: numberLikeComment,
                                             content: contentcomment, status: status)
        return commentObject
    }
}
