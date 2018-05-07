//
//  settingViewController.swift
//  garden_v3
//
//  Created by 梶原大進 on 2018/03/11.
//  Copyright © 2018年 梶原大進. All rights reserved.
//

import UIKit
import Eureka

class settingViewController: FormViewController {
    
    var waterDate: NSDate!
    var notice: Bool!
    var objectId: String! //WaterDataのID

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
            
            self.form +++ Section("通知の設定")
                <<< SwitchRow("switch"){
                    $0.title = "水やりの時間を通知"
                    $0.value = self.notice
                    }.onChange { row in
                        self.notice = row.value
                }
                <<< TimeRow() {
                    $0.hidden = Condition.function(["switch"], { form in
                        return !((form.rowBy(tag: "switch") as? SwitchRow)?.value ?? false)
                    })
                    $0.title = "水やりの時間"
                    $0.value = self.waterDate as Date?
                    }.onChange { row in
                        self.waterDate = row.value! as NSDate
                        self.saveData()
            }
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.form.removeAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func saveData() {
        let object = NCMBObject(className: "WaterData")
        object?.objectId = self.objectId
        object?.setObject(waterDate, forKey: "waterDate")
        object?.setObject(notice, forKey: "notice")
        object?.saveInBackground({(error) in
            if error != nil {
                print("setting savedata error : \(error!)")
            } else {
                print("success")
            }
        })
    }

}
