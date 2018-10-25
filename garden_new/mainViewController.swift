//
//  mainViewController.swift
//  garden_v3
//
//  Created by 梶原大進 on 2018/03/11.
//  Copyright © 2018年 梶原大進. All rights reserved.
//

import UIKit

class mainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView : UITableView!
    @IBOutlet var button : UIButton!
    
    var farms:[Farm] = [Farm]()
    var objectIds: [String] = []
    var createDates: [NSDate] = []
    var waterStates: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 120 //height of cell
        
        //setting of button
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        
        //color of tableView
        let tableBackground = UIColor(red: 255, green: 255, blue: 255, alpha: 0.5)
        self.tableView.backgroundColor = tableBackground
        
        //make navigationBar transparent
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        farms.removeAll()
        objectIds.removeAll()
        waterStates.removeAll()
        createDates.removeAll()
        
        //NCMBUser.logOut()

        if NCMBUser.current() != nil {
            print("Welcome to Your Gerden, \(String(describing: NCMBUser.current().userName))!!")
            self.loadData()
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.loadWaterData()
        } else {
            let segue : introViewController = self.storyboard?.instantiateViewController(withIdentifier: "intro") as! introViewController
            self.present(segue, animated:true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return farms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomCell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.setCell(farm: farms[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let segue = self.storyboard?.instantiateViewController(withIdentifier: "farm") as! farmViewController
        segue.selectCell = indexPath.row
        segue.farmName = farms[indexPath.row].farmName
        segue.imageName = farms[indexPath.row].imageName
        segue.objectId = objectIds[indexPath.row]
        segue.waterState = waterStates[indexPath.row]
        segue.createDate = createDates[indexPath.row]
        self.navigationController?.pushViewController(segue, animated: true)
    }
    
    func loadData() {
        let query = NCMBQuery(className: "FarmsData")
        query?.whereKey("createdBy", equalTo: NCMBUser.current().userName!)
        query?.order(byDescending: "createDate")
        query?.findObjectsInBackground({(objects, error) in
            if error != nil {
                print("loadData error : \(error!)")
            } else {
                let object_count : Int = (objects?.count)!
                if object_count > 0 {
                    for object in objects! {
                        self.makeFarm(farmName: (object as AnyObject).object(forKey: "farmName") as? String, farmImage: (object as AnyObject).object(forKey: "farmImage") as? String)
                        self.objectIds.append((object as AnyObject).object(forKey: "objectId") as! String)
                        self.waterStates.append((object as AnyObject).object(forKey: "waterState") as! Bool)
                        self.createDates.append((object as AnyObject).createDate!! as NSDate)
                    }
                }
            }
        })
    }
    
    func saveData(farmName: String!) {
        let object = NCMBObject(className: "FarmsData")
        object?.setObject(farmName, forKey: "farmName")
        object?.setObject("futaba.png", forKey: "farmImage")
        object?.setObject(NCMBUser.current().userName, forKey: "createdBy")
        object?.setObject(false, forKey: "waterState")
        object?.setObject(0, forKey: "imageCount")
        object?.saveInBackground({(error) in
            if error != nil {
                print("saveData error : \(error!)")
            } else {
                self.objectIds.append((object as AnyObject).objectId)
                self.waterStates.append(((object as AnyObject).object(forKey: "waterState") != nil))
                self.createDates.append((object as AnyObject).createDate!! as NSDate)
            }
        })
    }

    func makeFarm(farmName: String!, farmImage: String!) {
        let newFarm = Farm(farm: farmName, image: farmImage)
        self.farms.append(newFarm)
        self.tableView.reloadData()
    }
    
    @IBAction func make_newfarm() {
        let alert : UIAlertController = UIAlertController(title: "Make New Farm", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction : UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let defaultAction : UIAlertAction = UIAlertAction(title: "Create", style: .default, handler:{
            (action:UIAlertAction!) -> Void in
            //access to TextField in AlerController
            if let textFields = alert.textFields {
                for textField in textFields {
                    self.makeFarm(farmName: textField.text!, farmImage: "futaba.png")
                    self.saveData(farmName: textField.text!)
                }
            }
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        alert.addTextField(configurationHandler: {(text:UITextField!) -> Void in
            text.placeholder = "input name of your farm"
        })
        
        present(alert, animated: true, completion: nil)
    }

}
