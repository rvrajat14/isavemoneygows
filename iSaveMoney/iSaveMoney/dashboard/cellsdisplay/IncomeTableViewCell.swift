//
//  IncomeTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/7/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import UIKit
import TinyConstraints
import ISMLBase

class IncomeTableViewCell: UITableViewCell {

    lazy var incomeTitle:MediumTextLabel = {
        let label = MediumTextLabel()
        label.text = "Income title"
        label.textAlignment = .left
        return label
    }()
    
    lazy var incomeLabel: SmallTextLabel = {
        let label = SmallTextLabel()
        label.text = NSLocalizedString("actualIncome", comment: "Actual Income")
        label.textAlignment = .left
        return label
    }()
    lazy var incomeValueLabel: NormalTextLabel = {
        let label = NormalTextLabel()
        label.text = "$1,450.00"
        label.textAlignment = .right
        return label
    }()
    lazy var incomeStack:UIView = {
        let s = UIView()
     
        s.addSubview(incomeLabel)
        s.addSubview(incomeValueLabel)
        incomeLabel.leftToSuperview()
        incomeValueLabel.left(to: incomeLabel)
        incomeValueLabel.rightToSuperview()
       
        return s
    }()
    
    lazy var titleAmountStack:UIView  = {
        let s = UIView()
        s.addSubview(incomeTitle)
        s.addSubview(incomeStack)
       
        incomeTitle.topToSuperview()
        incomeTitle.leftToSuperview()
        incomeTitle.rightToSuperview()
        incomeStack.topToBottom(of: incomeTitle)
        incomeStack.bottomToSuperview()
        incomeStack.leftToSuperview()
        incomeStack.rightToSuperview()
        
        return s
    }()
    
    lazy var leterCircled:RoundCornerTextUIView = {
        let cir = RoundCornerTextUIView()
        cir.height(32)
        cir.width(32)
        return cir
    }()
    
    lazy var leterCircledTitleAmountStack:UIView  = {
        let s = UIView();
        s.addSubview(leterCircled)
        s.addSubview(titleAmountStack)
        leterCircled.leftToSuperview(offset: 15)
        leterCircled.topToSuperview(offset: 5)
        leterCircled.bottomToSuperview(offset: -5)
        
        titleAmountStack.topToSuperview(offset: 5)
        titleAmountStack.leftToSuperview(offset: 55)
        titleAmountStack.rightToSuperview(offset: -15)
        return s
    }()
    
    lazy var separator_1:UIView = {
        let sep = UIView()
        sep.height(1)
        sep.backgroundColor = UIColor(named: "seperatorColor")
        return sep
    }()
    
    lazy var stackOfWiews:UIView = {
        let s = UIView()
        s.addSubview(leterCircledTitleAmountStack)
        s.addSubview(separator_1)
        leterCircledTitleAmountStack.topToSuperview(offset: 10)
        leterCircledTitleAmountStack.bottomToSuperview(offset: -15)
        leterCircledTitleAmountStack.leftToSuperview()
        leterCircledTitleAmountStack.rightToSuperview()
        separator_1.edgesToSuperview(excluding: .top, insets: .left(15) + .right(-15))
        return s
    }()
    
    lazy var viewsWraper:UIView = {
        let vw = UIView()
        vw.clipsToBounds = true
     
        vw.addSubview(stackOfWiews)
        stackOfWiews.edgesToSuperview()
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
        viewsWraper.edgesToSuperview()
        viewsWraper.edgesToSuperview(excluding: .none, insets: .top(0) + .right(15) + .left(15) + .bottom(0), usingSafeArea: true)
        
    }
}
