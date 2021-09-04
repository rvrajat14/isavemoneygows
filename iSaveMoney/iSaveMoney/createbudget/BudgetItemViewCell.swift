//
//  AddimcomeViewCellTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 7/4/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit
import ISMLBase

protocol BudgetItemTableViewDelegate: class {
    func tableViewCellIconDidTaped(_ sender: BudgetItemViewCell, type: Int)
}

class BudgetItemViewCell: UITableViewCell {
    
    
   
    
    
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var textTitle: UILabel!
    @IBOutlet weak var buttonRemove: UIButton!
    @IBOutlet weak var textAmount: UILabel!
    @IBOutlet weak var sideColor: UIView!
    
    
    public var myIndex: Int!
    weak var delegate: BudgetItemTableViewDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        // Initialization code
        textAmount.textAlignment = .right
        buttonRemove.tintColor = Const.RED
        buttonAdd.tintColor = Const.BLUE
        buttonRemove.addTarget(self, action: #selector(BudgetItemViewCell.removeTapped), for: .touchUpInside)
        buttonAdd.addTarget(self, action: #selector(BudgetItemViewCell.addTapped), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func removeTapped() {
        delegate?.tableViewCellIconDidTaped(self, type: 0)
    }
    
    @objc func addTapped() {
        delegate?.tableViewCellIconDidTaped(self, type: 1)
    }

}
