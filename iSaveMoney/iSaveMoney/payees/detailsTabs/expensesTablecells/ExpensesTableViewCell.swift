//
//  ExpensesTableViewCell.swift
//  iSaveMoneyAcc
//
//  Created by Sai Akhil on 27/07/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit

class ExpensesTableViewCell: UITableViewCell {

    @IBOutlet weak var expenseAmount: UILabel!
    @IBOutlet weak var expenseDate: UILabel!
    @IBOutlet weak var expenseName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
}
