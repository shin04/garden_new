//
//  AppDelegate.swift
//  garden_new
//
//  Created by 梶原大進 on 2018/03/16.
//  Copyright © 2018年 梶原大進. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var objectId: String!
    var waterDate: NSDate!
    var notice: Bool!

    let ncmb_applicationkey = "c231f959d5ce81ab5e5cd4588fbf9e0a67fd8b3fbd61b1d85b4ee8ea4b5ee446"
    let ncmb_clientkey = "ad58ac82aac74919e928dcc31fac4bf453e5e7067e59b49e4c0a9cc36a6c122b"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        NCMB.setApplicationKey(ncmb_applicationkey, clientKey: ncmb_clientkey)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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

