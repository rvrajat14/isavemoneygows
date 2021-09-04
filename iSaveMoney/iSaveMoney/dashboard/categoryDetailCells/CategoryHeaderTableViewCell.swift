//
//  CategoryHeaderTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/9/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import UIKit
import TinyConstraints
import ISMLBase

public protocol AddExpenDelegate: class{
    func onPressButton()
}

class CategoryHeaderTableViewCell: UITableViewCell {
    
    var flavor:Flavor!
    
    var leterCircled:RoundCornerTextUIView!
    var categoryTitle:HeaderLevelThree!
    
    var budgetSpendLabel: SmallTextLabel!
    var budgetSpendValueLabel: NormalTextLabel!
    var budgetSpendStack:UIStackView!
    
    var actualSpendLabel: SmallTextLabel!
    var actualSpendValueLabel: NormalTextLabel!
    var actualSpendStack:UIStackView!
    
    var remainingLabel: SmallTextLabel!
    var remainingValueLabel: NormalTextLabel!
    var remainingStack:UIStackView!
    
    var stackValuesWiews:UIStackView!
    
    
    var progressGraph:BarIndicatorView!
    var delegate:AddExpenDelegate!

    
    var addDelegate: AddExpenDelegate!
    lazy var addExpenseButton:UIButton =  {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "plus")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageView?.tintColor = UIColor.white
        btn.width(32)
        btn.height(32)
        btn.backgroundColor = UIColor(named: "tintIconsColor")
        btn.layer.cornerRadius = 16
        
        
        return btn
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
       
        setupViews()
//        addExpenseButton.addTarget(self, action: #selector(addExpensePress), for: .touchUpInside)
//        self.addSubview(addExpenseButton)
//        //addExpenseButton.topToSuperview(offset: 10)
//        addExpenseButton.rightToSuperview(offset: -10)
//        addExpenseButton.bottomToSuperview()
//        //categoryTitle.rightToLeft(of: addExpenseButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    func setupViews() {
        
    
        self.backgroundColor = UIColor.clear
        
        categoryTitle = {
            let label = HeaderLevelThree()
            return label
        }()
        
        leterCircled = {
            let cir = RoundCornerTextUIView()
            cir.height(32)
            cir.width(32)
            return cir
        }()
        
        
        //Budget spend
        budgetSpendLabel = {
            let label = SmallTextLabel()
            label.text = NSLocalizedString("Budgetspend", comment: "Budget spend")
            return label
        }()
        
        budgetSpendValueLabel = {
            let label = NormalTextLabel()
            return label
        }()
        
        budgetSpendStack = {
            let s = UIStackView(arrangedSubviews: [budgetSpendLabel, budgetSpendValueLabel])
            s.axis = .vertical
            s.distribution = .fill
            s.spacing = 3
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return s
        }()
       
        //Actual spend
        actualSpendLabel = {
            let label = SmallTextLabel()
            label.text = NSLocalizedString("ActualSpend", comment: "Actual spend")
            return label
        }()
        
        actualSpendValueLabel = {
            let label = NormalTextLabel()
            return label
        }()
        
        actualSpendStack = {
            let s = UIStackView(arrangedSubviews: [actualSpendLabel, actualSpendValueLabel])
            s.axis = .vertical
            s.distribution = .fill
            s.spacing = 3
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return s
        }()
        
        //Remaining
        remainingLabel = {
            let label = SmallTextLabel()
            label.text = NSLocalizedString("txtRemaining", comment: "Remaining")
            return label
        }()
        
        remainingValueLabel = {
            let label = NormalTextLabel()
            return label
        }()
        
        remainingStack = {
            let s = UIStackView(arrangedSubviews: [remainingLabel, remainingValueLabel])
            s.axis = .vertical
            s.distribution = .fill
            s.spacing = 3
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return s
        }()
        
        stackValuesWiews = {
            let s = UIStackView(arrangedSubviews: [budgetSpendStack,  actualSpendStack, remainingStack])
            s.axis = .horizontal
            s.distribution = .equalSpacing
            s.spacing = 6
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return s
        }()
    
        
        //progress bar
        progressGraph = {
            let pro = BarIndicatorView()
            pro.height(15)
            return pro
        }()
       
        
       
        self.addSubview(leterCircled)
        self.addSubview(categoryTitle)
        
        
        
        
        
        self.addSubview(stackValuesWiews)
        self.addSubview(progressGraph)
       
        leterCircled.leftToSuperview(offset: 10)
        leterCircled.topToSuperview(offset: 10)
        categoryTitle.topToSuperview(offset: 10)
        categoryTitle.leftToRight(of: leterCircled, offset: 5)
        categoryTitle.rightToSuperview(offset: -46)
       
        
        
        //stackValuesWiews.height(40)
        stackValuesWiews.leftToSuperview(offset: 10)
        stackValuesWiews.rightToSuperview(offset: -10)
        stackValuesWiews.topToBottom(of: leterCircled, offset: 5)
        
        progressGraph.leftToSuperview(offset: 10)
        progressGraph.rightToSuperview(offset: -10)
        progressGraph.topToBottom(of: stackValuesWiews, offset: 5)
        progressGraph.bottomToSuperview(offset: -10)
        
        
        
    }
    
    @objc func addExpensePress() {
        addDelegate?.onPressButton()
    }
    
}
