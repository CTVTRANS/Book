//
//  GetProfileMemberTask.swift
//  BookApp
//
//  Created by kien le van on 9/12/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetProfileMemberTask: BaseTaskNetwork {

    private var _memberID: Int!
    
    init(idMember: Int) {
        _memberID = idMember
    }
    
    override func path() -> String! {
        return getProfileMemberURL
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["member_id": _memberID]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        if let dictionary = response as? [String: Any] {
            var profile = ProfileMember.getProfile()
            profile = paresMember(dictionary: dictionary)
            ProfileMember.saveProfile(myProfile: profile!)
        }
        return true
    }
}

extension BaseTaskNetwork {
    func paresMember(dictionary: [String: Any]) -> ProfileMember {
        let memberID = dictionary["id"] as? Int ?? 0
        let memberCode = dictionary["member_code"] as? String ?? ""
        let memberLevel = dictionary["level"] as? Int ?? 0
        let memberName = dictionary["name"] as? String ?? ""
        let memberCountry = dictionary["country_code"] as? Int ?? 0
        let memberPhone = dictionary["phone_number"] as? Int ?? 0
        let memberEmail = dictionary["email"] as? String ?? ""
        let memberAvatar = dictionary["avatar"] as? String ?? ""
        let memberSex = dictionary["gender"] as? Int ?? 0
        let memberBirthDay = dictionary["date_of_birth"] as? String ?? ""
        let memberJob = dictionary["job"] as? String ?? ""
        let memberMarrige = dictionary["marriage"] as? Int ?? 0
        let memberHobby = dictionary["hobby"] as? String ?? ""
        let memberPoint = dictionary["point"] as? Int ?? 0
        let memberAcessToken = dictionary["access_token"] as? String ?? ""
        let vipExpired = dictionary["vip_expired"] as? String ?? ""
        
        let member: ProfileMember = ProfileMember(idMember: memberID,
                                                  memberCode: memberCode,
                                                  level: memberLevel,
                                                  name: memberName,
                                                  country: memberCountry,
                                                  phoneNumber: memberPhone,
                                                  email: memberEmail,
                                                  avatar: memberAvatar,
                                                  sex: memberSex,
                                                  birDay: memberBirthDay,
                                                  job: memberJob,
                                                  marriage: memberMarrige,
                                                  hobby: memberHobby,
                                                  point: memberPoint,
                                                  token: memberAcessToken,
                                                  dateExpired: vipExpired)
        return member
    }
}
