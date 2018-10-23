//
//  AppDelegate.swift
//  garden_new
//
//  Created by 梶原大進 on 2018/03/16.
//  Copyright © 2018年 梶原大進. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var objectId: String!
    var waterDate: NSDate!
    var notice: Bool!

    let ncmb_applicationkey = "8ae0a77cb6f8ba960952dee5b38130a66be7e1fc9a67a7e09595924598dd9044"
    let ncmb_clientkey = "137a3644f40c1ded9db464ceedc2bc43c30d0c3f406d6fbabd7ec4a53a04890f"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        NCMB.setApplicationKey(ncmb_applicationkey, clientKey: ncmb_clientkey)
        
        //通知許可の確認
        if #available(iOS 10.0, *) {
            // iOS 10
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
                if error != nil {
                    return
                }
                if granted {
                    print("通知許可")
                    let center = UNUserNotificationCenter.current()
                    center.delegate = self as? UNUserNotificationCenterDelegate
                } else {
                    print("通知拒否")
                }
            })
            
        } else {
            // iOS 9以下
            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        //通知設定
        let trigger: UNNotificationTrigger
        var dateComponents = Calendar.current.dateComponents([.calendar, .hour, .minute], from: self.waterDate as Date)
        dateComponents.minute = dateComponents.minute!
        trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "通知"
        content.body = "水やりの時間です"
        content.sound = UNNotificationSound.default()
        let request = UNNotificationRequest(identifier: "normal", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }

    //waterdateクラスだけここで読み込む
    func loadWaterData() {
        let query = NCMBQuery(className: "WaterData")
        query?.whereKey("createdBy", equalTo: NCMBUser.current().userName!)
        query?.findObjectsInBackground({(objects, error) in
            if error != nil {
                print("setting error : \(error!)")
            } else {
                if objects!.count > 0 {
                    for object in objects! {
                        self.objectId = (object as AnyObject).objectId
                        self.waterDate = (object as AnyObject).object(forKey: "waterDate") as? NSDate
                        self.notice = (object as AnyObject).object(forKey: "notice") as? Bool
                    }
                }
            }
        })
    }

}

