//
//  ExpenseTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 6/11/16.
//  Copyright © 2016 UlmatCorpit. All rights reserved.
//

import UIKit
import ISMLBase

class ExpenseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var barIndicator: BarIndicatorView!
    @IBOutlet weak var expenseLabel: UILabel!
    
    @IBOutlet weak var spentValueLabel: UILabel!

    @IBOutlet weak var budgetValueLabel: UILabel!
    
    @IBOutlet weak var remainingValueLabel: UILabel!
    

    
    @IBOutlet weak var addExpenseButton: UIButton!
    
    
    weak var delegate: SwiftyTableViewCellDelegate?
    
    @IBAction func addTapped(_ sender: UIButton) {
        delegate?.swiftyTableViewCellDidTapAdd(self)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       
        addExpenseButton.layer.frame.size.height = addExpenseButton.bounds.size.height
        addExpenseButton.layer.frame.size.width = addExpenseButton.bounds.size.height
        addExpenseButton.layer.cornerRadius = 0.5 * addExpenseButton.bounds.size.width
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
}
