//
//  UploadAvatarTask.swift
//  BookApp
//
//  Created by kien le van on 10/5/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class UploadAvatarTask: BaseTaskNetwork {

    private var _memberID: Int!
    private var _token: String!
    private var _data: Data
    
    init(memberID: Int, token: String, data: Data) {
        _memberID = memberID
        _token = token
        _data = data
    }
    
    override func path() -> String! {
        return upAvaterURL
    }
    
    override func method() -> String! {
        return POST
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["member_id": _memberID, "access_token": _token]
    }
    
    override func parameterOfFile() -> String! {
        return "image"
    }
    
    override func imageUpload() -> Data! {
        return _data
    }
    
    override func data(withResponse response: Any!) -> Any! {
        if let dictionary = response as? [String: Any] {
            let avaterURL = dictionary["avatar_path"] as? String ?? ""
            let status = dictionary["status"] as? String ?? ""
            let statusCode = dictionary["status_code"] as? Int ?? 0
            if statusCode != 200 && statusCode != 0 {
                let error = ErrorCode(rawValue: statusCode)
                return (false, error)
            }
            if status == "success" {
                return (true, avaterURL)
            }
        }
        return response
    }
}
