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
        
    }
    
    @IBAction func switchAction(sender: RAMPaperSwitch) {
        print("switched")
    }
}


