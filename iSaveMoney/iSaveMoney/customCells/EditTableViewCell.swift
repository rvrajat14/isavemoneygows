//
//  EditTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 1/20/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit

class EditTableViewCell: UITableViewCell {

    @IBOutlet weak var editTitle: UITextField!
    
    @IBOutlet weak var editValue: UITextField!
    
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
  
    
    
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
