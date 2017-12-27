//
//  AppDelegate.swift
//  BookApp
//
//  Created by Le Cong on 8/10/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import UserNotifications
import LCNetwork
import SWRevealViewController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate {

    var window: UIWindow?
    let notificationName = Notification.Name("reciveNotificaton")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        application.applicationIconBadgeNumber = 0
        UINavigationBar.appearance().tintColor = UIColor.rgb(82, 82, 82)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.rgb(82, 82, 82)]
        WXApi.registerApp("vn.conglv.BookApp", withDescription: "demo")
        
        registerForPushNotifications()
        
        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            Constants.sharedInstance.hasNotification = true
            let aps = notification["aps"] as? [String: AnyObject]
            print(aps!)
        }
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        let getData = GetNotificationTask(limit: 1000, page: 1, memberID: (ProfileMember.getProfile()?.idMember)!)
        getData.request(blockSucess: { (data) in
            if let arrayNotice = data as? (Int, [NotificationApp]) {
                let numberNotice = UserDefaults.standard.integer(forKey: "numberNotice")
                if arrayNotice.0 > numberNotice {
                    Constants.sharedInstance.hasNotification = true
                    NotificationCenter.default.post(name: self.notificationName, object: nil)
                }
            }
        }) { (_) in
            
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Constants.sharedInstance.hasNotification = true
        NotificationCenter.default.post(name: notificationName, object: nil)
        let aps = userInfo["aps"] as? [String: AnyObject]
        print(aps!)
    }
    
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, _) in
                print("Permission granted: \(granted)")
                guard granted else { return }
                self.getNotificationSettings()
            }
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8 support
        else if #available(iOS 8, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func getNotificationSettings() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                print("Notification settings: \(settings)")
                
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        ProfileMember.saveDeviceToken(token: token)
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
}
