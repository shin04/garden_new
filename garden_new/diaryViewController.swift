//
//  diaryViewController.swift
//  garden_v3
//
//  Created by 梶原大進 on 2018/03/11.
//  Copyright © 2018年 梶原大進. All rights reserved.
//

import UIKit

class diaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView : UITableView!
    
    var farmNames : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        
        let tableBackground = UIColor(red: 255, green: 255, blue: 255, alpha: 0.5)
        self.tableView.backgroundColor = tableBackground
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.farmNames.removeAll()
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
        let cell : UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = farmNames[indexPath.row]
        
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let segue = self.storyboard?.instantiateViewController(withIdentifier: "content") as! contentViewController
        segue.farmName = self.farmNames[indexPath.row]
        self.navigationController?.pushViewController(segue, animated: true)
    }
    
    func loadData() {
        let query = NCMBQuery(className: "FarmsData")
        query?.whereKey("createdBy", equalTo: NCMBUser.current().userName!)
        query?.order(byAscending: "createDate")
        query?.findObjectsInBackground({(objects, error) in
            if error != nil {
                print("diary loadData error : \(error!)")
            } else {
                if objects!.count > 0 {
                    for object in objects! {
                        self.farmNames.append((object as AnyObject).object(forKey: "farmName") as! String)
                    }
                }
                self.tableView.reloadData()
            }
        })
    }

}
