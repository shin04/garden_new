//
//  CellModel.swift
//  garden_v3
//
//  Created by 梶原大進 on 2018/03/12.
//  Copyright © 2018年 梶原大進. All rights reserved.
//

import Foundation

class Farm: NSObject {
    var imageName: String!
    var farmName: String!
    
    init(farm: String, image: String) {
        self.farmName = farm
        self.imageName = image
    }
}

class Water: NSObject {
    var waterState: Bool!
    var farmName: String!
    
    init(waterState: Bool, farmName: String) {
        self.waterState = waterState
        self.farmName = farmName
    }
}
