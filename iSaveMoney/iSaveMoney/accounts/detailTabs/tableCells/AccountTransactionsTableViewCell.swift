//
//  AccountTransactionsTableViewCell.swift
//  iSaveMoneyAcc
//
//  Created by Sai Akhil on 18/08/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit

protocol TranactionCheckedDelegate {
    func onCheckTransaction(tnxCell: AccountTransactionsTableViewCell)
}

class AccountTransactionsTableViewCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var transactionNameLabel: UILabel!
    @IBOutlet weak var isCheckedButton: UIButton!
    
    var delegate: TranactionCheckedDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.isCheckedButton.imageView?.contentMode = .scaleAspectFit
        self.backgroundColor = UIColor.clear
        self.layer.backgroundColor = UIColor.clear.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
    }
    
    
    @IBAction func checkedPressed(_ sender: Any) {
        print("Pressed")
        delegate.onCheckTransaction(tnxCell: self)
    }
    
    
}
