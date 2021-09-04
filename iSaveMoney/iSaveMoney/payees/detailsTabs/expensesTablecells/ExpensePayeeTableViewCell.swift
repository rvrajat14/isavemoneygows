//
//  ExpensePayeeTableViewCell.swift
//  iSaveMoneyAcc
//
//  Created by Sai Akhil on 27/07/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit

class ExpensePayeeTableViewCell: UITableViewCell {

    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var payeeAddress: UILabel!
    @IBOutlet weak var payeeName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        

        // Configure the view for the selected state
    }
    
}
