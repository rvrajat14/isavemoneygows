//
//  MyTransactionTableViewCell.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 1/10/21.
//  Copyright © 2021 Armel Koudoum. All rights reserved.
//

import UIKit
import ISMLBase

class MyTransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var vwCircleText: CircleTextUIView!
    @IBOutlet weak var txtTitle: NormalTextLabel!
    @IBOutlet weak var txtDate: SmallTextLabel!
    @IBOutlet weak var txtAmount: NormalTextLabel!
    @IBOutlet weak var imgIndicator: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
