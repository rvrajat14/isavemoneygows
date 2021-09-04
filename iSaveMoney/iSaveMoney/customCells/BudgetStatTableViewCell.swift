//
//  BudgetStatTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 6/11/16.
//  Copyright © 2016 UlmatCorpit. All rights reserved.
//

import UIKit
import ISMLDataService
import ISMLBase

class BudgetStatTableViewCell: UITableViewCell {

    @IBOutlet weak var startBar: BarIndicatorView!
    @IBOutlet weak var statCircle: StatView!
    
    @IBOutlet weak var incomeLabel: UILabel!
    
    @IBOutlet weak var provisionalBudgetLabel: UILabel!
    
    @IBOutlet weak var provisionalBalanceLabel: UILabel!
    
     @IBOutlet weak var spentToDateLabel: UILabel!
    
     @IBOutlet weak var remainingToSpentLabel: UILabel!
    
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
