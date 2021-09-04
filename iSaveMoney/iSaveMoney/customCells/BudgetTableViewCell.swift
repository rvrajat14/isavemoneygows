//
//  BudgetTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 1/21/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit

class BudgetTableViewCell: UITableViewCell {

    @IBOutlet weak var textTitle: UILabel!
   
    @IBOutlet weak var textStatus: UILabel!
    
    @IBOutlet weak var txtOwner: UILabel!
    
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
