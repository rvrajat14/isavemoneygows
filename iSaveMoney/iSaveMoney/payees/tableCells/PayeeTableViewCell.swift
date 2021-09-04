//
//  PayeeTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/5/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import TinyConstraints
import ISMLBase

class PayeeTableViewCell: UITableViewCell {

    @IBOutlet weak var circularText: CircleTextUIView!
    @IBOutlet weak var payeeName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectionStyle = .none
        
    }
    
   
}
