//
//  setViewController.swift
//  garden_new
//
//  Created by 梶原大進 on 2018/05/07.
//  Copyright © 2018年 梶原大進. All rights reserved.
//

import UIKit
import Eureka

class setViewController: FormViewController {
    
    var objectId: String!
    var waterDate: NSDate!
    var notice: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.form +++ Section("通知の設定")
            <<< SwitchRow("switch") {
                $0.title = "水やりの時間を設定"
                $0.value = self.notice
        }

        let query = NCMBQuery(className: "waterDate")
        query?.whereKey("createdBy", equalTo: NCMBUser.current())
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
