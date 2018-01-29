//
//  DefineURL.swift
//  BookApp
//
//  Created by kien le van on 8/25/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

let defaultNonSigin = "/api/setting/get_setting"

// MARK: Book
let getBookTypeURL = "/api/book/list_category"
let getBookForEachTypeURL = "/api/book/list_post_by_category"
let getBookSuggestForTypeURL = "/api/book/list_suggest_posts_by_category"
let getBookNewestURL = "/api/book/list_latest_posts"
let getAllBookSuggestURL = "/api/book/list_all_suggest_posts"
let getAllBookFreeURL = "/api/book/list_free"
let getAllBookBookmarkedURL = "/api/collection/collection_book"
let increaseViewBokoURL = "/api/book/views"

// MARK: Chanel
let getAllChanelSuggestURL = "/api/teacher/list_all_suggest_teacher"
let getChanelFreeURL = "/api/teacher/list_free"
let getListLessonOfChanelURL = "/api/teacher/list_lesson"
let getTotalViewOfChanelURL = "/api/teacher/number_of_play"
let getAllSubcribled = "/api/teacher/list_subscribe"
let getHotChanel = "/api/teacher/list_hot"
let subcribleURL = "/api/teacher/subscribe"
let increaseViewChanelURL = "/api/teacher/play_lesson"
let addToHistoryURL = "/api/history/add_audio_to_history"
let getHistoryLessonURL = "/api/history/get_history_play"
let removeHistoryaudioURL = "/api/history/delete_history"

// MARK: News
let getAllNewsURL = "/api/post/list_latest_post"
let getAllTypeNewsURL = "/api/post/list_category"
let getAllNewsBookmarkedURL = "/api/collection/collection_news"
let getNewRelatedURL = "/api/post/get_related_post"
let getNewsForTypeURL = "/api/post/list_post_by_category"

// MARK: Coment, Like, Book,ark
let sendCommentURL = "/api/comment/add"
let checkLikeedURL = "/api/like/check_like"
let likeUnlikeURL = "/api/like/like"
let bookMarkURL = "/api/collection/collect"
let checkBookMarkedURL = "/api/collection/check_collect"
let getAllCommentURL = "/api/comment/latest"
let getAllCommentHotURL = "/api/comment/hot"
let buyBookURL = "/api/orders/orders_book"

// MARK: Golobal
let searchBookURL = "/api/search/book"
let searchNewsURL = "/api/search/news"
let getNotification = "/api/notification/get"
let markReadNoticeURL = "/api/notification/mark_read"
let getHotKeyWordURL = "/api/search/hot_keyword"
let removeNoticeURL = "/api/notification/delete"

// MARK: Member
let sendDeviceTokenURL = "/api/member/update_phone_id"
let getProfileMemberURL = "/api/member/detail"
let getCodeURL = "/api/member/generate_confirm_code"
let registerURL = "/api/member/register"
let sigInURL = "/api/member/login"
let forgetPasswordURL = "/api/member/forgot_password"
let upDateInfomationMemberURL = "/api/member/update_profile"
let upDatePasswordURL = "/api/member/change_password"
let upAvaterURL = "/api/member/update_avatar"
let upDatePointURL = "/api/member/add_point"

// MARK: Group
let getSlidershowURL = "/api/slide/get?screen_show"
let getAllGroupURL = "/api/group/list_group"
let getAllGroupJoinedURL = "/api/group/list_subscribe"
let getListNewsInGroupURL = "/api/group/list_post_by_group"
let subcribleGroupURL = "/api/group/multi_subscribe"
let subcribleOneGroupURL = "/api/group/subscribe"
let getListNewsForAllGroupURL = "/api/group/list_post_by_group_subscribed"

// MARK: Product
let getAllProductByPointURL = "/api/product/list_product_point"
let getAllProductByPointAndMoneyURL = "/api/product/list_product_price_mix"
let getAllProductURL = "/api/product/list_all_product"
let getAllVipProductURL = "/api/product/list_package"
let buyVipPointURL = "/api/orders/orders_vip"
let getHistoryBuyBookURL = "/api/member/orders_history/orders_book"
let getHistoryVipURL = "/api/member/orders_history/orders_vip"

let css: String = "<style> img{max-width:100%} </style>"
let appDownload = "https://itunes.apple.com/us/app/instant-heart-rate-hr-monitor/id409625068?mt=8"

enum ErrorCode: Int {
    case success = 200
    case emailError = 201
    case imageFormatError = 202
    case imageTooBig = 203
    case passwordShort = 204
    case confirmPassError = 205
    case passwordConfirmEmty = 206
    case passwordError = 207
    case numberPhoneError = 208
    case confirmCodeError = 209
    case confirmCodeEmty = 210
    case numberPhoneEmty = 211
    case nameEmty = 212
    case passwordEmty = 213
    case numberPhoneExists = 214
    case accountError = 215
    case limitBuyVip = 216
    case passwordHasSpace = 88
}

extension ErrorCode {
    func decodeError() -> String {
        switch self {
        case .success:
            return "success!".localized
        case .emailError:
            return "E-mail format is wrong".localized
        case .imageFormatError:
            return "Image category is not right".localized
        case .imageTooBig:
            return "Picture capacity exceeds the requirement".localized
        case .passwordShort:
            return "Password is too short (must be more than 8 symbols)".localized
        case .confirmPassError:
            return "Password and password do not overlap".localized
        case .passwordConfirmEmty:
            return "Password confirm can not be blank".localized
        case .passwordError:
            return "password wrong".localized
        case .numberPhoneError:
            return "The phone number is wrong".localized
        case .confirmCodeError:
            return "Verification code wrong".localized
        case .confirmCodeEmty:
            return "Verification code can not be blank".localized
        case .numberPhoneEmty:
            return "Phone number can not be blank".localized
        case .nameEmty:
            return "Name can not be blank".localized
        case .passwordEmty:
            return "Password can not be blank".localized
        case .numberPhoneExists:
            return "Phone number has been registered".localized
        case .accountError:
            return "account does not exist".localized
        case .limitBuyVip:
            return "Use points to upgrade VIP number to be limited".localized
        case .passwordHasSpace:
            return "Password can not have a space".localized
        }
    }
}

class DefineURL: NSObject {
    
}
