//
//  UserCircleTableViewCell.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 1/2/21.
//  Copyright © 2021 Armel Koudoum. All rights reserved.
//

import UIKit
import ISMLBase

class UserCircleTableViewCell: UITableViewCell {

    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var emailLabel: NormalTextLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        personImage.image = personImage.image?.withRenderingMode(.alwaysTemplate)
        personImage.tintColor = UIColor(named: "tintIconsColor")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
