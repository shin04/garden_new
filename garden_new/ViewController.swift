//
//  ViewController.swift
//  garden_v3
//
//  Created by 梶原大進 on 2018/03/11.
//  Copyright © 2018年 梶原大進. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var controllerArrays : [UIViewController] = [] //viewを格納
        
        //viewを作成
        let controller_1 = self.storyboard?.instantiateViewController(withIdentifier: "main_navi")
        let controller_2 = self.storyboard?.instantiateViewController(withIdentifier: "watering")
        let controller_3 = self.storyboard?.instantiateViewController(withIdentifier: "diary_navi")
        let controller_4 = self.storyboard?.instantiateViewController(withIdentifier: "setting")
        
        controller_1?.title = "農作物一覧"
        controller_2?.title = "水やり状況"
        controller_3?.title = "日記"
        controller_4?.title = "設定"
        
        controllerArrays.append(controller_1!)
        controllerArrays.append(controller_2!)
        controllerArrays.append(controller_3!)
        controllerArrays.append(controller_4!)
        
        //色作成
        let menuBackground = UIColorFromRGB(rgbValue: 0x37CCB5)
        let selectMenu = UIColorFromRGB(rgbValue: 0x51FFB3)
        let unselectMenu = UIColorFromRGB(rgbValue: 0x3EE8CE)
        
        //pagemenu作成
        var options = PageMenuOption(frame : CGRect(x:0.0, y:20.0, width:self.view.frame.width, height:self.view.frame.height))
        options.menuItemBackgroundColorNormal = menuBackground
        options.menuItemBackgroundColorSelected = selectMenu
        options.menuItemBackgroundColorNormal = unselectMenu
        options.menuIndicatorColor = selectMenu
        
        let pagemenu = PageMenuView(viewControllers: controllerArrays, option: options)
        view.addSubview(pagemenu)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //RGBで色作成
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}

