//
//  contentViewController.swift
//  garden_new
//
//  Created by 梶原大進 on 2018/04/27.
//  Copyright © 2018年 梶原大進. All rights reserved.
//

import UIKit

class contentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var button: UIButton!
    
    var diaryView: UIView!
    
    var farmName: String!
    var cellNumber: Int!
    var objectIds: [String] = []
    var imageNames: [String] = []
    var comments: [String] = []
    var createDate: [NSDate] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationItem.title = "日記一覧"
        
        let tableBackground = UIColor(red: 255, green: 255, blue: 255, alpha: 0.5)
        self.tableView.backgroundColor = tableBackground
        
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.objectIds.removeAll()
        self.imageNames.removeAll()
        self.comments.removeAll()
        self.createDate.removeAll()
        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return createDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = self.stringFromDate(date:createDate[indexPath.row], format: "yyyy年MM月dd日")
        
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellNumber = indexPath.row
        
        diaryView = UIView(frame: CGRect(x:self.view.frame.width / 2 - 150, y:50, width:300, height:400))
        
        let imageView = UIImageView(frame: CGRect(x:25, y:10, width:250, height:200))
        self.loadFile(imageName: imageNames[indexPath.row], imageView: imageView)
        
        let comment = UITextField(frame: CGRect(x:50, y:220, width:200, height:40))
        comment.text = comments[indexPath.row]
        comment.textColor = UIColor.black
        comment.delegate = self as? UITextFieldDelegate
        
        let closeBtn = UIButton(frame: CGRect(x:50, y:270, width:200, height:40))
        //closeBtn.frame = CGRectMake(50, 220, 200, 40)
        closeBtn.setTitle("閉じる", for: [])
        closeBtn.setTitleColor(UIColor(red: 0.318, green: 1.00, blue: 0.702, alpha: 1), for: [])
        closeBtn.backgroundColor = UIColor(red: 0.216, green: 0.800, blue: 0.710, alpha: 1)
        closeBtn.layer.cornerRadius = 18
        closeBtn.addTarget(self, action: #selector(contentViewController.closeAc(sender:)), for: .touchUpInside)
        
        diaryView.addSubview(imageView)
        diaryView.addSubview(comment)
        diaryView.addSubview(closeBtn)
        self.view.addSubview(diaryView)
    }
    
    //NSDate >> String
    func stringFromDate(date: NSDate, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date as Date)
    }
    
    func loadFile(imageName: String!, imageView: UIImageView) {
        let imageFile = NCMBFile.file(withName: imageName, data: nil) as! NCMBFile
        imageFile.getDataInBackground({(imageData, error) -> Void in
            if error != nil {
                print("contentVIew loadData error : \(error!)")
            } else {
                imageView.image = UIImage(data: imageData!)
            }
        })
    }
    
    func saveFile(fileData: UIImage, objectId: String!) {
        let imageData = UIImagePNGRepresentation(fileData)
        let saveFile = NCMBFile.file(withName: objectId + ".ong", data: imageData) as! NCMBFile
        saveFile.saveInBackground({(error) in
            if error != nil {
                print("contentView saveFile erroe \(error!)")
            } else {
                print("success")
            }
        })
    }
    
    func loadData() {
        let query = NCMBQuery(className: "DiaryData")
        query?.whereKey("createdBy", equalTo: NCMBUser.current().userName!)
        query?.whereKey("farmName", equalTo: farmName)
        query?.order(byAscending: "createData")
        query?.findObjectsInBackground({(objects, error) in
            if error != nil {
                print("contentView loadData error : \(error!)")
            } else {
                if objects!.count > 0 {
                    for object in objects! {
                        self.objectIds.append((object as AnyObject).object(forKey: "objectId") as! String)
                        self.imageNames.append((object as AnyObject).object(forKey: "imageName") as! String)
                        self.comments.append((object as AnyObject).object(forKey: "comment") as! String)
                        self.createDate.append((object as AnyObject).object(forKey: "createDate") as! NSDate)
                    }
                }
                self.tableView.reloadData()
            }
        })
    }
    
    func saveData(objectId: String!, saveObject: AnyObject!, key: String!) {
        let object = NCMBObject(className: "DiaryData")
        object?.objectId = objectId
        object?.setObject(saveObject, forKey: key)
        object?.saveInBackground({(error) in
            if error != nil {
                print("content saveData error : \(error!)")
            } else {
                print("success")
            }
        })
    }
    
    func selectImage() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func takeImage() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.camera
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    //写真選択時に呼ばれる
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            let object = NCMBObject(className: "DiaryData")
            object?.setObject(NCMBUser.current().userName!, forKey: "createdBy")
            object?.setObject(self.farmName, forKey: "farmName")
            object?.setObject("コメント", forKey: "comment")
            object?.setObject("image", forKey: "imageName")
            object?.saveInBackground({(error) in
                if error != nil {
                    print("contentView imagepiker error : \(error!)")
                } else {
                    self.objectIds.append((object as AnyObject).objectId)
                    self.createDate.append((object as AnyObject).createDate!! as NSDate)
                    self.imageNames.append((object as AnyObject).objectId + ".png")
                    self.comments.append("コメント")
                    let size = CGSize(width: 300, height: 300)
                    UIGraphicsBeginImageContext(size)
                    info[UIImagePickerControllerOriginalImage]!.draw(CGRect(x:0, y:0, width:size.width, height:size.height))
                    let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
                    self.saveFile(fileData: resizeImage!, objectId: object?.objectId)
                    self.saveData(objectId: object!.objectId, saveObject: object!.objectId + ".png" as AnyObject, key: "imageName")
                    self.tableView.reloadData()
                }
            })
        }
        
        //カメラロールに保存
        UIImageWriteToSavedPhotosAlbum(info[UIImagePickerControllerOriginalImage] as! UIImage, self, nil, nil)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeAc(sender: UIButton) {
        diaryView.removeFromSuperview()
    }
    
    @IBAction func newDiary() {
        let alert : UIAlertController = UIAlertController(title: "Diary", message: "make new diary", preferredStyle: UIAlertControllerStyle.alert)
        let takeAction : UIAlertAction = UIAlertAction(title: "Take a photo", style: .default, handler:{
            (action:UIAlertAction!) -> Void in
            self.takeImage()
        })
        let selectAction : UIAlertAction = UIAlertAction(title: "select a photo", style: .default, handler:{
            (action:UIAlertAction!) -> Void in
            self.selectImage()
        })
        alert.addAction(takeAction)
        alert.addAction(selectAction)
        present(alert, animated: true, completion: nil)
    }

}
