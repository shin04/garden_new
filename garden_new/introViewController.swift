//
//  introViewController.swift
//  garden_new
//
//  Created by 梶原大進 on 2018/03/16.
//  Copyright © 2018年 梶原大進. All rights reserved.
//

import UIKit

class introViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var usernameText: UITextField!
    @IBOutlet var passwardText: UITextField!
    @IBOutlet var registerBtn: UIButton!
    @IBOutlet var loginBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameText.delegate = self
        self.passwardText.delegate = self
        
        self.registerBtn.layer.cornerRadius = 20
        self.registerBtn.layer.masksToBounds = true
        
        self.loginBtn.layer.cornerRadius = 20
        self.loginBtn.layer.masksToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func alert(title : String!) {
        let alert : UIAlertController = UIAlertController(title: "message", message: title, preferredStyle: UIAlertControllerStyle.alert)
        let button : UIAlertAction = UIAlertAction(title: "OK!", style: .default, handler: nil)
        alert.addAction(button)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signIn() {
        NCMBUser.logInWithUsername(inBackground: usernameText.text, password: passwardText.text, block: ({(user,error) in
            if error != nil {
                print("signin error : \(error!)")
                self.alert(title: "You cannot sign up!!!")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }))
    }
    
    @IBAction func signUp() {
        let user = NCMBUser()
        user.userName = usernameText.text!
        user.password = passwardText.text!
        user.signUpInBackground({(error) in
            if error != nil {
                print("signup error : \(error!)")
                self.alert(title: "You cannot sign up!!!")
            } else {
                let object = NCMBObject(className : "WaterData")
                object?.setObject(NCMBUser.current().userName, forKey: "createdBy")
                object?.setObject(false, forKey: "notice")
                object?.saveInBackground({(error) in
                    if error != nil {
                        print("add WaterData class in sign up error : \(error!)")
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        })
    }
    
}
