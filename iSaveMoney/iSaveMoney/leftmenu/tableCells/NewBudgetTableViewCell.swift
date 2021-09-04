//
//  NewBudgetTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/16/18.
//  Copyright © 2018 UlmatCorpit. All rights reserved.
//

import UIKit
import TinyConstraints
import ISMLBase

public protocol OnCreateBudget:class {
    func onPress()
}
class NewBudgetTableViewCell: UITableViewCell {
    
    var delegate: OnCreateBudget!
    
    lazy var buttonNewButton:ButtonWithArrow = {
        let label = ButtonWithArrow()
        label.setTitle( "New budget", for: .normal)
        return label
    }()
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        

        addSubview(buttonNewButton)
        buttonNewButton.edgesToSuperview(insets: .top(5) + .left(15) + .right(10) + .bottom(5))
        buttonNewButton.addTarget(self, action: #selector(newbudget), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func newbudget() {
        delegate.onPress()
    }

    
}
