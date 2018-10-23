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
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.objectId = appDelegate.objectId
        self.waterDate = appDelegate.waterDate
        self.notice = appDelegate.notice
    }
    
    override func viewWillAppear(_ animated: Bool) {
        form +++ Section("通知の設定")
            <<< SwitchRow("switch") {
                $0.title = "水やりの時間を通知"
                $0.value = self.notice
                }.onChange { row in
                    self.notice = row.value
            }
            <<< TimeRow() {
                //スイッチ押したら出るようにしたいけどできない
                //                $0.hidden = Condition.function(["switch"], { form in
                //                    return !((form.rowBy(tag: "switch") as? SwitchRow)?.value ?? false)
                //                })
                $0.title = "水やりの時間"
                $0.value = self.waterDate as Date?
                }.onChange { row in
                    self.waterDate = row.value! as NSDate
            }
            <<< ButtonRow() {
                $0.title = "save"
                }.onCellSelection{ cell, row in
                    self.saveData()
                    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.waterDate = self.waterDate
        }
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
                let alert: UIAlertController = UIAlertController(title: "", message: "保存しました", preferredStyle: UIAlertControllerStyle.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
                alert.addAction(defaultAction)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }

}
