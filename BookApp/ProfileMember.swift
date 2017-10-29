//
//  ProfileMember.swift
//  BookApp
//
//  Created by kien le van on 9/12/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class ProfileMember: NSObject, NSCoding {

    private var _idMember, _level, _sex, _point: Int?
    private var _memberCode, _name: String?
    private var _phoneNumber, _country, _marriage: Int?
    private var _email, _avatar: String?
    private var _dateOfBirth, _job, _hobby: String?
    private var _token, _dateExpired: String?
    
    init(idMember: Int, memberCode: String, level: Int, name: String, country: Int,
         phoneNumber: Int, email: String, avatar: String, sex: Int, birDay: String,
         job: String, marriage: Int, hobby: String, point: Int, token: String, dateExpired: String) {
        _idMember = idMember
        _memberCode = memberCode
        _level = level
        _name = name
        _country = country
        _phoneNumber = phoneNumber
        _email = email
        _avatar = avatar
        _sex = sex
        _dateOfBirth = birDay
        _job = job
        _marriage = marriage
        _hobby = hobby
        _point = point
        _token = token
        _dateExpired = dateExpired
    }
    
    required init(coder decoder: NSCoder) {
        _idMember = decoder.decodeObject(forKey: "_idMember") as? Int
        _memberCode = decoder.decodeObject(forKey: "_memberCode") as? String
        _level = decoder.decodeObject(forKey: "_level") as? Int
        _name = decoder.decodeObject(forKey: "_name") as? String
        _country = decoder.decodeObject(forKey: "_country") as? Int
        _phoneNumber = decoder.decodeObject(forKey: "_phoneNumber") as? Int
        _email = decoder.decodeObject(forKey: "_email") as? String
        _avatar = decoder.decodeObject(forKey: "_avatar") as? String
        _sex = decoder.decodeObject(forKey: "_sex") as? Int
        _dateOfBirth = decoder.decodeObject(forKey: "_dateOfBirth") as? String
        _job = decoder.decodeObject(forKey: "_job") as? String
        _marriage = decoder.decodeObject(forKey: "_marriage") as? Int
        _hobby = decoder.decodeObject(forKey: "_hobby") as? String
        _point = decoder.decodeObject(forKey: "_point") as? Int
        _token = decoder.decodeObject(forKey: "_token") as? String
        _dateExpired = decoder.decodeObject(forKey: "_dateExpired") as? String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(_idMember, forKey: "_idMember")
        coder.encode(_memberCode, forKey: "_memberCode")
        coder.encode(_level, forKey: "_level")
        coder.encode(_name, forKey: "_name")
        coder.encode(_country, forKey: "_country")
        coder.encode(_phoneNumber, forKey: "_phoneNumber")
        coder.encode(_email, forKey: "_email")
        coder.encode(_avatar, forKey: "_avatar")
        coder.encode(_sex, forKey: "_sex")
        coder.encode(_dateOfBirth, forKey: "_dateOfBirth")
        coder.encode(_job, forKey: "_job")
        coder.encode(_marriage, forKey: "_marriage")
        coder.encode(_hobby, forKey: "_hobby")
        coder.encode(_point, forKey: "_point")
        coder.encode(_token, forKey: "_token")
        coder.encode(_dateExpired, forKey: "_dateExpired")
    }
    
    static func saveDeviceToken(token: String) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: token)
        UserDefaults.standard.set(encodedData, forKey: "DeviceToken")
    }
    
    static func getDeviceToken() -> String? {
        if let data = UserDefaults.standard.data(forKey: "DeviceToken"),
            let myToken = NSKeyedUnarchiver.unarchiveObject(with: data) as? String {
            return myToken
        }
        let myToken = ""
        return myToken
    }
    
    static func saveToken(token: String) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: token)
        UserDefaults.standard.set(encodedData, forKey: "myToken")
    }
    
    static func getToken() -> String? {
        if let data = UserDefaults.standard.data(forKey: "myToken"),
            let myToken = NSKeyedUnarchiver.unarchiveObject(with: data) as? String {
            return myToken
        }
        let myToken = ""
        return myToken
    }
    
    static func saveProfile(myProfile: ProfileMember) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: myProfile)
        UserDefaults.standard.set(encodedData, forKey: "myProfile")
    }
    
    static func getProfile() -> ProfileMember? {
        if let data = UserDefaults.standard.data(forKey: "myProfile"),
            let myProfile = NSKeyedUnarchiver.unarchiveObject(with: data) as? ProfileMember {
            return myProfile
        }
        let profile = ProfileMember(idMember: 0, memberCode: "", level: 0, name: "", country: 0, phoneNumber: 0, email: "", avatar: "", sex: 0, birDay: "", job: "", marriage: 0, hobby: "", point: 0, token: "", dateExpired: "")
        return profile
    }
    
    var idMember: Int {
        return _idMember!
    }
    var level: Int {
        return _level!
    }
    var sex: Int! {
        get { return _sex!}
        set { _sex = newValue}
    }
    var point: Int {
        get { return _point!}
        set { _point = newValue}
    }
    var memberCode: String? {
        return _memberCode
    }
    var name: String {
        get { return _name!}
        set { _name = newValue}
    }
    var country: Int? {
        get { return _country}
        set { _country = newValue}
    }
    var phoneNumber: Int {
        get { return _phoneNumber!}
        set { _phoneNumber = newValue}
    }
    var avatar: String? {
        get { return _avatar}
        set { _avatar = newValue}
    }
    var email: String? {
        get { return _email}
        set { _email = newValue}
    }
    var dateOfBirth: String? {
        get { return _dateOfBirth}
        set { _dateOfBirth = newValue}
    }
    var job: String? {
        get { return _job}
        set { _job = newValue}
    }
    var marriage: Int! {
        get { return _marriage!}
        set { _marriage = newValue}
    }
    var hobby: String? {
        get { return _hobby}
        set { _hobby = newValue}
    }
    var token: String? {
        get { return _token}
        set { _token = newValue}
    }
}
