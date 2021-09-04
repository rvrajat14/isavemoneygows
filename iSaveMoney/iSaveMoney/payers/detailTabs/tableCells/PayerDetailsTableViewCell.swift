//
//  PayerDetailsTableViewCell.swift
//  iSaveMoneyAcc
//
//  Created by Sai Akhil on 02/08/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit

class PayerDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var payerName: UILabel!
    @IBOutlet weak var payerAddress: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var amount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
