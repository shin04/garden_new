//
//  CustomCell.swift
//  garden_v3
//
//  Created by 梶原大進 on 2018/03/12.
//  Copyright © 2018年 梶原大進. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet var farmImage: UIImageView!
    @IBOutlet var farmName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(farm: Farm) {
        let imageFile = NCMBFile.file(withName: farm.imageName, data: nil) as! NCMBFile
        imageFile.getDataInBackground({(imageData, error) -> Void in
            if error != nil {
                print("setCell error : \(error!)")
            } else {
                let image = UIImage(data: imageData!)
                self.farmImage.image = image
                self.farmName.text = farm.farmName
            }
        })
    }
}

class CustomCell2: UITableViewCell {
    @IBOutlet var waterSwitch: RAMPaperSwitch!
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(water: Water) {
        self.waterSwitch.isOn = water.waterState
        self.nameLabel.text = water.farmName
    }
    
    @IBAction func switchAction(sender: RAMPaperSwitch) {
        print("switched")
    }
}


