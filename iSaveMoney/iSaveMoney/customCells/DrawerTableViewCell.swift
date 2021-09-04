//
//  DrawerTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 6/8/16.
//  Copyright © 2016 UlmatCorpit. All rights reserved.
//

import UIKit

class DrawerTableViewCell: UITableViewCell {


    @IBOutlet weak var drawerItemLabel: UILabel!
    @IBOutlet weak var drawerItemImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }

}
