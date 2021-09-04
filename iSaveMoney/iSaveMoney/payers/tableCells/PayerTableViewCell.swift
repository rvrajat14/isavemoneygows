//
//  PayerTableViewCell.swift
//  iSaveMoneyAcc
//
//  Created by Sai Akhil on 31/07/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit
import ISMLBase

class PayerTableViewCell: UITableViewCell {

    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var payerName: UILabel!
    @IBOutlet weak var circularTextView: CircleTextUIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        

        // Configure the view for the selected state
    }
    
}
