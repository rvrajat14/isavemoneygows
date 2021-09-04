//
//  TotalTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 6/11/16.
//  Copyright © 2016 UlmatCorpit. All rights reserved.
//

import UIKit
import TinyConstraints
import ISMLBase


class TotalTableViewCell: UITableViewCell {
    
    lazy var totalLabel: MediumTextLabel = {
        let label = MediumTextLabel()
        label.text = "Total expenditude"
        label.textAlignment = .left
        return label
    }()
    
    lazy var totalValueLabel: HeaderLevelThree = {
        let label = HeaderLevelThree()
        label.text = "$1,450.00"
        label.textAlignment = .right
        return label
    }()
    
    lazy var separator_1:UIView = {
        let sep = UIView()
        sep.height(1)
        sep.backgroundColor = UIColor(named: "seperatorColor")
        return sep
    }()
    
    lazy var viewsWraper:UIView = {
        let vw = UIView()
        vw.height(25)
        vw.addSubview(totalLabel)
        vw.addSubview(totalValueLabel)
        vw.addSubview(separator_1)
        totalLabel.leftToSuperview()
        totalValueLabel.left(to: totalLabel)
        totalValueLabel.rightToSuperview()
        separator_1.edgesToSuperview(excluding: .top)
        return vw
    }()
    
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
        
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.backgroundColor = UIColor.clear

        self.addSubview(viewsWraper)
        viewsWraper.edgesToSuperview(excluding: .none, insets: .left(15) + .top(25) + .right(15) + .bottom(0))
        
        
     
        
       self.layer.backgroundColor = UIColor.clear.cgColor
    }
}
