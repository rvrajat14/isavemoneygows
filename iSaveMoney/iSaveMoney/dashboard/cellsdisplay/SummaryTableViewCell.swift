//
//  SummaryTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 11/25/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import TinyConstraints
import ISMLDataService
import ISMLBase

class SummaryTableViewCell: UITableViewCell {
    
    
    // Initial balance
    lazy var initialBalanceLabel: SmallTextLabel = {
        let label = SmallTextLabel()
        label.text = NSLocalizedString("initialBalance", comment: "Initial balance")
        label.textAlignment = .left
        return label
    }()
    lazy var initialBalanceValue: HeaderLevelThree = {
        let label = HeaderLevelThree()
        label.text = "$2,472.00"
        label.textAlignment = .left
        return label
    }()
    lazy var initialBalanceCard: IsmCardView = {
        let s = IsmCardView()
    
        s.height(30)
        s.addSubview(initialBalanceLabel)
        s.addSubview(initialBalanceValue)
        initialBalanceLabel.leftToSuperview(offset: 10)
        initialBalanceLabel.centerYToSuperview()
        initialBalanceValue.centerYToSuperview()
        initialBalanceValue.leftToRight(of: initialBalanceLabel, offset: 10)
        
        return s
    }()
    
    lazy var statCircle: StatView = {
        let statCir = StatView()
        statCir.height(self.bounds.width/2)
        return statCir
    }()
    lazy var startNote: SmallTextLabel = {
        let label = SmallTextLabel()
        label.text = "5% of income spent"
        label.textAlignment = .center
        return label
    }()
//    lazy var separator_1: UIView = {
//        let sep = UIView()
//        sep.backgroundColor = UIColor(red:0.81, green:0.81, blue:0.81, alpha:1.0)
//        sep.height(1)
//        return sep
//    }()
    
    lazy var statCircleView: UIStackView = {
        let s = UIStackView(arrangedSubviews: [statCircle, startNote])
        s.axis = .vertical
        s.distribution = UIStackView.Distribution.fillProportionally
        s.spacing = 0
        s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return s
    }()
    
    lazy var incomeLabel: SmallTextLabel = {
        let label = SmallTextLabel()
        label.text = NSLocalizedString("netDisposableIncome", comment: "Net Disposable Income")
        return label
    }()
    lazy var incomeValueLabel: HeaderLevelThree = {
        let label = HeaderLevelThree()
        label.text = "$7,000.00"
        return label
    }()
    lazy var incomeStackView: UIStackView = {
        let s = UIStackView(arrangedSubviews: [incomeLabel, incomeValueLabel])
        s.axis = .vertical
        s.distribution = .fill
        s.spacing = 6
        s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return s
    }()
    
    lazy var spentToDateLabel: SmallTextLabel = {
        let label = SmallTextLabel()
        label.text = NSLocalizedString("actualSpentDate", comment: "Actual Spent to Date")
        label.textAlignment = .right
        return label
    }()
    lazy var spentToDateValueLabel: HeaderLevelThree = {
        let label = HeaderLevelThree()
        label.text = "$2,472.00"
        label.textAlignment = .right
        return label
    }()
    lazy var spentToDateStackView: UIStackView = {
        let s = UIStackView(arrangedSubviews: [spentToDateLabel, spentToDateValueLabel])
        s.axis = .vertical
        s.distribution = .fill
        s.spacing = 6
        s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return s
    }()
    
    lazy var incomeSpentStackView: UIStackView = {
        let s = UIStackView(arrangedSubviews: [incomeStackView, spentToDateStackView])
        s.axis = .horizontal
        s.distribution = .fill
        s.spacing = 6
        s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return s
    }()
    
    lazy var provisionalBudgetLabel: SmallTextLabel = {
        let label = SmallTextLabel()
        label.text = NSLocalizedString("provisionalBudget", comment: "Provisional Balance")
        label.textAlignment = .center
        return label
    }()
    lazy var provisionalBudgetValueLabel: HeaderLevelThree = {
        let label = HeaderLevelThree()
        label.textAlignment = .center
        return label
    }()
    lazy var provisionalBudgetStackView: IsmCardView = {
        let s = IsmCardView()
        s.height(50)
        s.addSubview(provisionalBudgetLabel)
        s.addSubview(provisionalBudgetValueLabel)
        provisionalBudgetLabel.edgesToSuperview(excluding: .bottom, insets: .top(10) + .left(0) + .right(0))
        provisionalBudgetValueLabel.topToBottom(of: provisionalBudgetLabel)
        provisionalBudgetValueLabel.leftToSuperview()
        provisionalBudgetValueLabel.rightToSuperview()
        
        return s
    }()
    
    //Provisional Balance
    lazy var provisionalBalanceLabel: SmallTextLabel = {
        let label = SmallTextLabel()
        label.text = NSLocalizedString("provisionalBalance", comment: "Provisional Balance")
        label.textAlignment = .center
        return label
    }()
    lazy var provisionalBalanceValueLabel: HeaderLevelThree = {
        let label = HeaderLevelThree()
        label.text = "$4,340.00"
        label.textAlignment = .center
        return label
    }()
    lazy var provisionalBalanceStackView:IsmCardView = {
        let s = IsmCardView()
        s.height(50)
        s.addSubview(provisionalBalanceLabel)
        s.addSubview(provisionalBalanceValueLabel)
        provisionalBalanceLabel.edgesToSuperview(excluding: .bottom, insets: .top(10) + .left(0) + .right(0))
        provisionalBalanceValueLabel.topToBottom(of: provisionalBalanceLabel)
        provisionalBalanceValueLabel.leftToSuperview()
        provisionalBalanceValueLabel.rightToSuperview()
        return s
    }()
    
    // spent remaining
    lazy var remainingToSpentLabel: SmallTextLabel = {
        let label = SmallTextLabel()
        label.text = NSLocalizedString("spentRemaining", comment: "Spent Remaining")
        label.textAlignment = .center
        return label
    }()
    lazy var remainingToSpentValueLabel: HeaderLevelThree = {
        let label = HeaderLevelThree()
        label.text = "$2,472.00"
        label.textAlignment = .center
        return label
    }()
    lazy var remainingToSpentStackView: IsmCardView = {
        let s = IsmCardView()
    
        s.height(50)
        s.addSubview(remainingToSpentLabel)
        s.addSubview(remainingToSpentValueLabel)
        remainingToSpentLabel.edgesToSuperview(excluding: .bottom, insets: .top(10) + .left(0) + .right(0))
        remainingToSpentValueLabel.topToBottom(of: remainingToSpentLabel)
        remainingToSpentValueLabel.leftToSuperview()
        remainingToSpentValueLabel.rightToSuperview()
        return s
    }()
    
    
    
    lazy var spentAndRemainingStackView: UIStackView = {
        let s = UIStackView(arrangedSubviews: [provisionalBudgetStackView, provisionalBalanceStackView, remainingToSpentStackView])
        s.axis = .horizontal
        s.distribution = .fillEqually
        s.spacing = 12
        s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return s
    }()
    
    lazy var startBar: ProgressView = {
        let pv = ProgressView()
        pv.height(15)
        return pv
    }()
    
    lazy var stackOfWiews: UIStackView = {
        let s = UIStackView(arrangedSubviews: [ initialBalanceCard,
                                                incomeSpentStackView,
                                                statCircleView,
                                                spentAndRemainingStackView,
                                                startBar])
        s.axis = .vertical
        s.distribution = .equalSpacing
        s.alignment = .fill
        s.spacing = 12
        s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return s
    }()
    

    
    
    lazy var viewsWraper: UIView = {
        let vw = UIView()
    
        vw.layer.cornerRadius = 5
        vw.clipsToBounds = true
        return vw
    }()
    
    
    var flavor:Flavor!
    
     var testButton:ButtonWithImage!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
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
        
        self.backgroundColor = mmChrome.WHITE
        viewsWraper.addSubview(stackOfWiews)
        stackOfWiews.edgesToSuperview(excluding: .none, insets: .top(10) + .left(5) + .right(5) + .bottom(5))
       
        self.addSubview(viewsWraper)
        viewsWraper.edgesToSuperview(excluding: .none, insets: .top(15) + .right(15) + .left(15) + .bottom(5), usingSafeArea: true)
        
        self.layer.backgroundColor = UIColor.clear.cgColor
    }
}
