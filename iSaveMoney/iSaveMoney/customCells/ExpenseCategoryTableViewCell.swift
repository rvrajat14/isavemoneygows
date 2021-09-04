//
//  ExpenseCategoryTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 3/4/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit

class ExpenseCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var textTitle: UILabel!
    
    @IBOutlet weak var txtDate: UILabel!
    @IBOutlet weak var txtAmount: UILabel!
    
    
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
