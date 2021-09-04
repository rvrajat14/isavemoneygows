//
//  TransactionTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/9/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import UIKit
import TinyConstraints
import ISMLBase

class TransactionTableViewCell: UITableViewCell {
    
    var flavor:Flavor!
    
    var leterCircled:CircleTextUIView!
    var transactionTitle:NormalTextLabel!
    
    var transactionDateLabel: SmallTextLabel!
    var transactionValueLabel: HeaderLevelFour!
  

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        flavor = Flavor()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
        
        self.backgroundColor = UIColor.clear
        
        transactionDateLabel = {
            let label = SmallTextLabel()
            return label
        }()
        
        transactionValueLabel = {
            let label = HeaderLevelFour()
            return label
        }()
        
      
        
        transactionTitle = {
            let label = NormalTextLabel()
            return label
        }()
        
        
        leterCircled = {
            let cir = CircleTextUIView()
            cir.height(32)
            cir.width(32)
            return cir
        }()
        
        
        self.addSubview(leterCircled)
        self.addSubview(transactionTitle)
        self.addSubview(transactionDateLabel)
        self.addSubview(transactionValueLabel)
        
        leterCircled.leftToSuperview(offset: 10)
        leterCircled.topToSuperview(offset: 10)
        
        transactionTitle.topToSuperview(offset: 10)
        transactionTitle.leftToRight(of: leterCircled, offset: 5)
        transactionTitle.rightToSuperview(offset: -10)
        
        transactionDateLabel.leftToRight(of: leterCircled, offset: 5)
        transactionDateLabel.topToBottom(of: transactionTitle, offset: 2)
        //transactionDateLabel.bottomToSuperview(offset: -10)
        
        transactionValueLabel.topToBottom(of: transactionTitle)
        transactionValueLabel.rightToSuperview(offset: -10)
        transactionValueLabel.bottomToSuperview(offset: -5)
    }
}
