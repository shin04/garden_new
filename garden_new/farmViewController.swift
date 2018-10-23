//
//  farmViewController.swift
//  garden_new
//
//  Created by 梶原大進 on 2018/03/17.
//  Copyright © 2018年 梶原大進. All rights reserved.
//

import UIKit

class farmViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var farmNameText: UITextField!
    @IBOutlet var farmImageView: UIImageView!
    @IBOutlet var dataLabel: UILabel!
    @IBOutlet var waterSwitch: RAMPaperSwitch!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var deleteBtn: UIButton!
    
    var selectCell: Int!
    var farmName: String!
    var imageName: String!
    var createData: String!
    var objectId: String!
    var waterState: Bool!
    var createDate: NSDate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.farmNameText.delegate = self
        
        saveBtn.layer.cornerRadius = 18
        saveBtn.layer.masksToBounds = true
        
        deleteBtn.layer.cornerRadius = 18
        deleteBtn.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //make navigationBar transparent
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.title = farmName
        self.farmNameText.text = farmName
        self.setImage(imageFileName: imageName)
        dataLabel.text = "作成日：" + stringFromDate(date: createDate, format: "yyyy年MM月dd日")
        if waterState == true {
            waterSwitch.isOn = true
        } else {
            waterSwitch.isOn = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        farmName = farmNameText.text!
        textField.resignFirstResponder()
        
        return true
    }
    
    //よくわからんコード
    func animateImageView(imageView: UIImageView, onAnimation: Bool, duration: TimeInterval) {
        UIView.transition(with: imageView, duration: duration, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            imageView.image = UIImage(named: onAnimation ? "img_phone_on" : "img_phone_off")
        }, completion:nil)
    }
    
    //NSDate >> String
    func stringFromDate(date: NSDate, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date as Date)
    }
    
    func saveData(saveObject: AnyObject!, key: String!) {
        let object = NCMBObject(className: "FarmsData")
        object?.objectId = objectId
        object?.setObject(saveObject, forKey: key)
        object?.saveInBackground({(error) in
            if error != nil {
                print("saveData error : \(error!)")
            } else {
                print("success")
            }
        })
    }
    
    func setImage(imageFileName: String) {
        let fileData = NCMBFile.file(withName: imageFileName, data: nil) as! NCMBFile
        fileData.getDataInBackground({(imageData, error) -> Void in
            if error != nil {
                print("setImage error : \(error!)")
            } else {
                self.farmImageView.image = UIImage(data: imageData!)
            }
        })
    }
    
    func saveFile(fileData: UIImage) {
        let imageData = UIImagePNGRepresentation(fileData)
        let saveFile = NCMBFile.file(withName: self.objectId + ".png", data: imageData) as! NCMBFile
        saveFile.saveInBackground({(error) in
            if error != nil {
                print("saveFile error : \(error!)")
            } else {
                print("success")
                self.saveData(saveObject: self.objectId + ".png" as AnyObject, key: "farmImage")
                self.imageName = self.objectId + ".png"
                self.farmImageView.image = fileData
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if info[UIImagePickerControllerOriginalImage] != nil {
//            let size = CGSize(width: 250, height: 200)
//            UIGraphicsBeginImageContext(size)
//            info[UIImagePickerControllerOriginalImage]!.draw(CGRect(x:0, y:0, width:size.width, height:size.height))
//            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
//
//            self.saveFile(fileData: resizeImage!)
//        }
//
//        //save photo in cameraroll
//        UIImageWriteToSavedPhotosAlbum(info[UIImagePickerControllerOriginalImage] as! UIImage, self, nil, nil)
//
//        picker.dismiss(animated: true, completion: nil)
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let reSize = CGSize(width: 250, height: 250)
        self.saveFile(fileData: image.reSizeImage(reSize: reSize))
        
        picker.dismiss(animated: true, completion: nil )
    }
    
    @IBAction func saveDataAction() {
        self.saveData(saveObject: farmName as AnyObject, key: "farmName")
    }
    
    @IBAction func deleteDataAction() {
        let object = NCMBObject(className: "FarmsData")
        object?.objectId = objectId
        object?.deleteInBackground({(error) in
            if error != nil {
                print("deleteDataAction error : \(error!)")
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
    }
    
    @IBAction func waterSwitchAction(sender: RAMPaperSwitch) {
        if waterSwitch.isOn {
            waterState = true
        } else {
            waterState = false
        }
        
        self.saveData(saveObject: waterState as AnyObject, key: "waterState")
    }
 
    @IBAction func plantCondition() {
        let alert : UIAlertController = UIAlertController(title: "state of your plant", message: "Select state of your plant.", preferredStyle: UIAlertControllerStyle.alert)
        let button_1 : UIAlertAction = UIAlertAction(title: "Select a photo", style: .default, handler: {(action: UIAlertAction!) in
            self.selectImage()
        })
        let button_2 : UIAlertAction = UIAlertAction(title: "Take a photo", style: .default, handler: {(action: UIAlertAction!) in
            self.takeImage()
        })
        let button_3 : UIAlertAction = UIAlertAction(title: "Select s image", style: .default, handler: {(action: UIAlertAction!) in
            let segue = self.storyboard?.instantiateViewController(withIdentifier: "select") as! selectimageViewController
            segue.objectId = self.objectId
            self.navigationController?.pushViewController(segue, animated: true)
        })
        let button_4 : UIAlertAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        alert.addAction(button_1)
        alert.addAction(button_2)
        alert.addAction(button_3)
        alert.addAction(button_4)
        present(alert, animated: true, completion: nil)
    }
    
}

extension UIImage {
    // resize image
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height));
        let reSizeImage:UIImage! = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    // scale the image at rates
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
}
