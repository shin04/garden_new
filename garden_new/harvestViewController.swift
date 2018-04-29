//
//  harvestViewController.swift
//  garden_new
//
//  Created by 梶原大進 on 2018/03/18.
//  Copyright © 2018年 梶原大進. All rights reserved.
//

import UIKit
import Eureka

class harvestViewController: FormViewController, UINavigationControllerDelegate {
    
    var objectId : String!
    var harvestDate: NSDate!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        
        form +++ Section("when you harvest your plant?")
            <<< DatePickerRow() {
                //$0.value = harvestDate.addingTimeInterval(60*60*24) as Date?
                $0.value = harvestDate as Date?
                }.onChange { row in
                    print(row.value!)
                    self.harvestDate = row.value! as NSDate
        }
            <<< ButtonRow() {
                $0.title = "save"
                }.onCellSelection{ cell, row in
                    let object = NCMBObject(className: "FarmsData")
                    object?.objectId = self.objectId
                    object?.setObject(self.harvestDate, forKey: "harvestDate")
                    object?.saveInBackground({(error) in
                        if error != nil {
                            print("saveData error : \(error!)")
                        } else {
                            let a = self.navigationController?.viewControllers.count
                            let segue = self.navigationController?.viewControllers[a! - 2] as! farmViewController
                            segue.harvestDate = self.harvestDate
                            print("success : \(self.harvestDate)")
                            self.navigationController?.popViewController(animated: true)
                        }
                    })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //navi透過
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.title = "harvest time"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
