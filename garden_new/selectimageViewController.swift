//
//  selectimageViewController.swift
//  garden_new
//
//  Created by 梶原大進 on 2018/03/18.
//  Copyright © 2018年 梶原大進. All rights reserved.
//

import UIKit

class selectimageViewController: UIViewController {

    var objectId : String!
    var imageName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.title = "イラストを選択"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func alert() {
        let alert : UIAlertController = UIAlertController(title: "CHECK", message: "USE THIS PHOT", preferredStyle: UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            self.saveData()
        })
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    func saveData() {
        let object = NCMBObject(className: "FarmsData")
        object?.objectId = self.objectId
        object?.setObject(self.imageName, forKey: "farmImage")
        object?.saveInBackground({(error) in
            if error != nil {
                print("select image save data error \(error!)")
            } else {
                print("succes")
            }
        })
    }
    
    @IBAction func hatugaAction() {
        imageName = "hatuga.png"
        self.alert()
    }
    
    @IBAction func futabaAction() {
        imageName = "futaba.png"
        self.alert()
    }
    
    @IBAction func sukoshiAction() {
        imageName = "sukoshi.png"
        self.alert()
    }
    
    @IBAction func tubomiAction() {
        imageName = "tubomi.png"
        self.alert()
    }
    
    @IBAction func hanaAction() {
        imageName = "hana.png"
        self.alert()
    }
    
    @IBAction func miAction() {
        imageName = "mi.png"
        self.alert()
    }
}
