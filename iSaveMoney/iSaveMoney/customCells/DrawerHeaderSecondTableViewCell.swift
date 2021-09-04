//
//  DrawerHeaderSecondTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 1/14/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit

class DrawerHeaderSecondTableViewCell: UITableViewCell {

    @IBOutlet weak var textEmail: UILabel!
    @IBOutlet weak var imgIndicator: UIImageView!
    
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
