//
//  DaybookViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 7/4/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit

class DaybookViewCell: UITableViewCell {
    @IBOutlet weak var textTitle: UILabel!
    @IBOutlet weak var txtDate: UILabel!
    @IBOutlet weak var txtAmount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        txtAmount.textAlignment = .right
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
