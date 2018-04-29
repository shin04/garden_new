//
//  wateringViewController.swift
//  garden_v3
//
//  Created by 梶原大進 on 2018/03/11.
//  Copyright © 2018年 梶原大進. All rights reserved.
//

import UIKit

class wateringViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView : UITableView!
    @IBOutlet var button: UIButton!
    
    var waters: [Water] = [Water]()
    var objectId: [String] = []
    var farmNames: [String] = []
    var waterStates: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let tableBackground = UIColor(red: 255, green: 255, blue: 255, alpha: 0.5)
        self.tableView.backgroundColor = tableBackground
        
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        waters.removeAll()
        objectId.removeAll()
        farmNames.removeAll()
        waterStates.removeAll()
        
        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return farmNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomCell2 = tableView.dequeueReusableCell(withIdentifier: "CustomCell2", for: indexPath) as! CustomCell2
        cell.setCell(water: waters[indexPath.row])
        
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        
        cell.waterSwitch.tag = indexPath.row
        cell.waterSwitch.addTarget(self, action: #selector(wateringViewController.waterSwitchAction(sender:)), for: UIControlEvents.valueChanged)
        if waterStates[indexPath.row] == true {
            cell.waterSwitch.isOn = true
        } else {
            cell.waterSwitch.isOn = false
        }
        
        return cell
    }
    
    func saveData(objectId: String!, waterState: Bool!) {
        let object = NCMBObject(className: "FarmsData")
        object?.objectId = objectId
        object?.setObject(waterState, forKey: "waterState")
        object?.saveInBackground({(error) in
            if error != nil {
                print("watering saveData error : \(error!)")
            } else {
                print("success")
                print("water state : \(String(describing: object?.object(forKey: "waterState")))")
            }
        })
    }
    
    func loadData() {
        let query = NCMBQuery(className: "FarmsData")
        query?.whereKey("createdBy", equalTo: NCMBUser.current().userName!)
        query?.order(byDescending: "createData")
        query?.findObjectsInBackground({(objects, error) in
            if error != nil {
                print("watering loadData error : \(error!)")
            } else {
                if objects!.count > 0 {
                    for object in objects! {
                        self.objectId.append((object as AnyObject).object(forKey: "objectId") as! String)
                        self.farmNames.append((object as AnyObject).object(forKey: "farmName") as! String)
                        self.waterStates.append((object as AnyObject).object(forKey: "waterState") as! Bool)
                    }
                }
            }
            self.setUpWater()
        })
    }
    
    func setUpWater() {
        for i in 0 ..< waterStates.count {
            //for object in waterStates {
            let newWater = Water(waterState: waterStates[i], farmName: farmNames[i])
            self.waters.append(newWater)
        }
        self.tableView.reloadData()
    }
    
    @IBAction func waterSwitchAction(sender: AnyObject) {
        if waterStates[sender.tag] == true {
            waterStates[sender.tag] = false
        } else {
            waterStates[sender.tag] = true
        }
        self.saveData(objectId: objectId[sender.tag], waterState: waterStates[sender.tag])
    }
    
    @IBAction func allswitchAction() {
        for object in objectId {
            self.saveData(objectId: object, waterState: true)
        }
        waters.removeAll()
        objectId.removeAll()
        farmNames.removeAll()
        waterStates.removeAll()
        self.loadData()
    }
    
}
