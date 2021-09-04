//
//  UserGroupTableViewCell.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 1/3/21.
//  Copyright © 2021 Armel Koudoum. All rights reserved.
//

import UIKit
import ISMLBase

class UserGroupTableViewCell: UITableViewCell {

    @IBOutlet weak var circledLetter: CircleTextUIView!
    @IBOutlet weak var txtTitle: NormalTextLabel!
    @IBOutlet weak var txtDate: SmallTextLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
