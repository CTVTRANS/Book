//
//  BaseExtendtion.swift
//  Weding
//
//  Created by Le Cong on 8/10/17.
//  Copyright © 2017 kien le van. All rights reserved.
//

import UIKit
import DeviceKit
import LCNetwork

class BaseViewcontrollerExtend: NSObject {

}

extension BaseTaskNetwork {
    
    func parseMixPrice(arrayPrice: [[String: Any]]) -> [PriceMix] {
        var array: [PriceMix] = []
        for object in arrayPrice {
            let point = object["point"] as? Int ?? 0
            let money = object["money"] as? Int ?? 0
            let price = PriceMix(point: point, money: money)
            array.append(price)
        }
        return array
    }
    
    func parseBook(dictionary: [String: Any]) -> Book {
        let idBook = dictionary["post_id"] as? Int ?? 0
        let idTypeBook = dictionary["cat_id"] as? Int ?? 0
        let nameTypeBook = dictionary["cat_name"] as? String ?? ""
        let nameBook = dictionary["post_name"] as? String ?? ""
        let authorBook = dictionary["author"] as? String ?? ""
        let imageURLBook = dictionary["post_image"] as? String ?? ""
        let descriptionBook = dictionary["post_description"] as? String ?? ""
        let audioBook = dictionary["post_audio"] as? String ?? ""
        let videoBook = dictionary["post_video"] as? String ?? ""
        let contentBook = dictionary["post_content"] as? String ?? ""
        let timeUpBook = dictionary["updated_at"] as? String ?? ""
        let numberLikeBook = dictionary["number_of_likes"] as? Int ?? 0
        let numberCommentBook = dictionary["number_of_comments"] as? Int ?? 0
        let numberBookMark = dictionary["number_of_collection"] as? Int ?? 0
        let price = dictionary["price_by_point"] as? Int ?? 0
        let typePay = dictionary["type_pay"] as? String ?? ""
        let numberView = dictionary["number_of_views"] as? Int ?? 0
        
        var priceMixOfBook: [PriceMix] = []
        if let priceMixDictionay = dictionary["price_mix"] as? [[String: Any]] {
            priceMixOfBook = parseMixPrice(arrayPrice: priceMixDictionay)
        }
        let book: Book = Book(idBook: idBook,
                              type: idTypeBook,
                              typeName: nameTypeBook,
                              name: nameBook,
                              author: authorBook,
                              imageUrl: imageURLBook,
                              numberReaded: numberView,
                              timeUp: timeUpBook,
                              audio: audioBook,
                              video: videoBook,
                              content: contentBook,
                              numberLike: numberLikeBook,
                              numberComment: numberCommentBook,
                              numberBookMark: numberBookMark,
                              desCription: descriptionBook,
                              price: price,
                              priceMix: priceMixOfBook,
                              typePay: typePay)
        return book
    }
    
    func parseChanel(dictionary: [String: Any]) -> Chanel {
        let chanelName = dictionary["channel_title"] as? String ?? ""
        let chanelID = dictionary["post_id"] as? Int ?? 0
        let chanelType = dictionary["cat_name"] as? String ?? ""
        let chanelImage = dictionary["channel_image"] as? String ?? ""
        let teacherName = dictionary["teacher_name"] as? String ?? ""
        let teacherImage = dictionary["teacher_image"] as? String ?? ""
        let numberLike = dictionary["number_of_likes"] as? Int ?? 0
        let numberComment = dictionary["number_of_comments"] as? Int ?? 0
        let numberSubcrible = dictionary["number_of_subscribe"] as? Int ?? 0
        let isSubcrible = dictionary["is_subscribe"] as? Bool ?? false
        let chanelTimeUp = dictionary[""] as? String ?? ""
        let chanel: Chanel = Chanel(idChanel: chanelID,
                                    nameChanel: chanelName,
                                    imageChanelURL: chanelImage,
                                    typeChanel: chanelType,
                                    nameTeacher: teacherName,
                                    imageTeacherURL: teacherImage,
                                    numberView: 0,
                                    time: chanelTimeUp,
                                    numberLike: numberLike,
                                    numberComment: numberComment,
                                    numberSubcrible: numberSubcrible,
                                    isSubcrible: isSubcrible)
        return chanel
    }
    
    func parseLesson(dictionary: [String: Any]) -> Lesson {
        let lessonID = dictionary["id"] as? Int ?? 0
        let lessonChapter = dictionary["chapter"] as? Int ?? 0
        let lessonName = dictionary["title"] as? String ?? ""
        let lessonDescription = dictionary["description"] as? String ?? ""
        let lessonContent = dictionary["audio"] as? String ?? ""
        let lessonTimeup = dictionary["created_at"] as? String ?? ""
        let lesonTimeRead = dictionary["updated_at"] as? String ?? ""
        let imageLesson = dictionary["image"] as? String ?? ""
        let chanelOwner = dictionary["channel_title"] as? String ?? ""
        let lesson: Lesson = Lesson(idLesson: lessonID,
                                    chaper: lessonChapter,
                                    time: lessonTimeup,
                                    timeRead: lesonTimeRead,
                                    name: lessonName,
                                    description: lessonDescription,
                                    imageURL: imageLesson,
                                    contentURL: lessonContent,
                                    chanelOwner: chanelOwner)
        return lesson
    }
    
    func parseGroup(dictionary: [String: Any]) -> SecrectGroup {
        let idGroup = dictionary["id"] as? Int ?? 0
        let titleGroup = dictionary["title"] as? String ?? ""
        let imageGroup = dictionary["image"] as? String ?? ""
        let idWechatGroup = dictionary["wechat"] as? String ?? ""
        let adressGroup = dictionary["address"] as? String ?? ""
        let isSubcrible = dictionary["is_subscribe"] as? Bool ?? false
        let charater = dictionary["group_by"] as? String ?? ""
        let group = SecrectGroup(idGroup: idGroup,
                                 name: titleGroup,
                                 imageURL: imageGroup,
                                 idWechat: idWechatGroup,
                                 adress: adressGroup,
                                 isSubcrible: isSubcrible,
                                 charaterGroup: charater)
        return group
    }
    
    func parseNews(dictionary: [String: Any]) -> NewsModel {
        let newsID = dictionary["post_id"] as? Int ?? 0
        let newsAuthor = dictionary["author"] as? String ?? ""
        let newsName = dictionary["post_name"] as? String ?? ""
        let newsImage = dictionary["post_image"] as? String ?? ""
        let newsDescription = dictionary["post_description"] as? String ?? ""
        let newsContent = dictionary["post_content"] as? String ?? ""
        let newsNote = dictionary["post_note"] as? String ?? ""
        let newsTimeup = dictionary["updated_at"] as? String ?? ""
        let newsType = dictionary["post_display_type"] as? Int ?? 1
        let newsNameType = dictionary["cat_name"] as? String ?? ""
        let newsNumberLike = dictionary["number_of_likes"] as? Int ?? 0
        let newsNumberComment = dictionary["number_of_comments"] as? Int ?? 0
        let newsNumberBookMark = dictionary["number_of_collection"] as? Int ?? 0
        let category = dictionary["cat_id"] as? Int ?? 0
        
        let news: NewsModel = NewsModel(idNews: newsID,
                                        author: newsAuthor,
                                        imageUrl: newsImage,
                                        title: newsName,
                                        detail: newsDescription,
                                        type: newsType,
                                        nameType: newsNameType,
                                        content: newsContent,
                                        note: newsNote,
                                        timeUp: newsTimeup,
                                        numberView: 0,
                                        numberLike: newsNumberLike,
                                        numberComment: newsNumberComment,
                                        numberBookMark: newsNumberBookMark,
                                        category: category)
        return news
    }
    
    func parseVip(dictionary: [String: Any]) -> Vip {
        let idVip = dictionary["id"] as? Int ?? 0
        let titleVip = dictionary["title"] as? String ?? ""
        let imageVip = dictionary["image"] as? String ?? ""
        let descriptionVip = dictionary["description"] as? String ?? ""
        let contentVip = dictionary["content"] as? String ?? ""
        let priceVip = dictionary["price_money"] as? Int ?? 0
        let point = dictionary["price_point"] as? Int ?? 0
        let vip = Vip(idVip: idVip,
                  title: titleVip,
                  imageURL: imageVip,
                  description: descriptionVip,
                  content: contentVip,
                  price: priceVip,
                  point: point)
        return vip
    }
}

extension UIAlertController {
    static func showAler(title: String, message: String, inViewController: UIViewController) {
        let alertView = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
        let action = UIAlertAction(title: "确认",
                                   style: UIAlertActionStyle.default) { (_) in
                                    alertView.dismiss(animated: true, completion: nil)
        }
        alertView.addAction(action)
        inViewController.present(alertView, animated: true, completion: nil)
    }
    
    static func showActionSheetWith(arrayTitle: [String],
                                    handlerAction: @escaping ((_ index: Int) -> Void),
                                    in viewController: UIViewController) {
        let alertView = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for index in 0..<arrayTitle.count {
            let action = UIAlertAction(title: arrayTitle[index],
                                       style: .default,
                                       handler: { (_) in
                handlerAction(index)
            })
            alertView.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "取消",
                                         style: .cancel) { (_) in
        }
        alertView.addAction(cancelAction)
        viewController.present(alertView, animated: true, completion: nil)
    }
}

extension Array where Element: Equatable {
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

extension UILabel {
    @IBInspectable
    var adjustFontToRealIPhoneSize: Bool {
        set {
            if newValue {
                let currentFont = self.font
                var sizeScale: CGFloat = 1
                let device = Device()
                if device == .simulator(.iPhone7) || device == .simulator(.iPhone6) || device == .iPhone6
                    || device == .iPhone7 || device == .iPhone6s || device == .simulator(.iPhone8)
                    || device == .iPhone8 {
                    sizeScale = 1.2
                } else if device == .simulator(.iPhone6Plus) || device == .simulator(.iPhone7Plus)
                    || device == .iPhone6Plus || device == .iPhone7Plus || device == .iPhone8Plus
                    || device == .simulator(.iPhone8Plus) || device == .iPhone6sPlus {
                    sizeScale = 1.3
                }
                self.font = currentFont?.withSize((currentFont?.pointSize)! * sizeScale)
            }
        }
        get {
            return false
        }
    }
}

extension UITextField {
    @IBInspectable
    var adjustFontToRealIPhoneSize: Bool {
        set {
            if newValue {
                let currentFont = self.font
                var sizeScale: CGFloat = 1
                let device = Device()
                if device == .simulator(.iPhone7) || device == .simulator(.iPhone6) || device == .iPhone6
                    || device == .iPhone7 || device == .iPhone6s || device == .simulator(.iPhone8)
                    || device == .iPhone8 {
                    sizeScale = 1.2
                } else if device == .simulator(.iPhone6Plus) || device == .simulator(.iPhone7Plus)
                    || device == .iPhone6Plus || device == .iPhone7Plus || device == .iPhone8Plus
                    || device == .simulator(.iPhone8Plus) || device == .iPhone6sPlus {
                    sizeScale = 1.3
                }
                self.font = currentFont?.withSize((currentFont?.pointSize)! * sizeScale)
            }
        }
        get {
            return false
        }
    }
}

extension NSLayoutConstraint {
    @IBInspectable
    var adjustConstantToRealIPhoneSize: Bool {
        set {
            if newValue {
                let currentConstant = self.constant
                var sizeScale: CGFloat = 1
                let device = Device()
                if device == .simulator(.iPhone7) || device == .simulator(.iPhone6) || device == .iPhone6
                    || device == .iPhone7 || device == .iPhone6s || device == .simulator(.iPhone8)
                    || device == .iPhone8 {
                    sizeScale = 1.2
                } else if device == .simulator(.iPhone6Plus) || device == .simulator(.iPhone7Plus)
                    || device == .iPhone6Plus || device == .iPhone7Plus || device == .iPhone8Plus
                    || device == .simulator(.iPhone8Plus) || device == .iPhone6sPlus {
                    sizeScale = 1.3
                }
                self.constant = currentConstant * sizeScale
            }
        }
        get {
            return false
        }
    }
}

extension UIButton {
    @IBInspectable
    var adjustFontToRealIPhoneSize: Bool {
        set {
            if newValue {
                let currentFont = self.titleLabel?.font
                var sizeScale: CGFloat = 1
                let device = Device()
                if device == .simulator(.iPhone7) || device == .simulator(.iPhone6) || device == .iPhone6
                    || device == .iPhone7 || device == .iPhone6s || device == .simulator(.iPhone8)
                    || device == .iPhone8 {
                    sizeScale = 1.2
                } else if device == .simulator(.iPhone6Plus) || device == .simulator(.iPhone7Plus)
                    || device == .iPhone6Plus || device == .iPhone7Plus || device == .iPhone8Plus
                    || device == .simulator(.iPhone8Plus) || device == .iPhone6sPlus {
                    sizeScale = 1.3
                }
                self.titleLabel?.font = currentFont?.withSize((currentFont?.pointSize)! * sizeScale)
            }
        }
        get {
            return false
        }
    }
}

extension CGFloat {
    var adjustsSizeToRealIPhoneSize: CGFloat {
        set {
            var sizeScale: CGFloat = 1
            let device = Device()
            if device == .simulator(.iPhone7) || device == .simulator(.iPhone6) || device == .iPhone6
                || device == .iPhone7 || device == .iPhone6s || device == .simulator(.iPhone8)
                || device == .iPhone8 {
                sizeScale = 1.2
            } else if device == .simulator(.iPhone6Plus) || device == .simulator(.iPhone7Plus)
                || device == .iPhone6Plus || device == .iPhone7Plus || device == .iPhone8Plus
                || device == .simulator(.iPhone8Plus) || device == .iPhone6sPlus {
                sizeScale = 1.3
            }
            self = newValue * sizeScale
        }
        get {
            return self
        }
    }
}

extension UITabBarControllerDelegate {
    public func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        let fromView: UIView = tabBarController.selectedViewController!.view
        let toView: UIView = viewController.view
        if fromView == toView {
            return false
        }
        
        UIView.transition(from: fromView, to: toView, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve) { (_: Bool) in
        }
        return true
    }
}

extension UIColor {
    class func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
}
