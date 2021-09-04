//
//  AccountDetailsHeaderTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 1/19/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import UIKit
import TinyConstraints
import ISMLBase

class AccountHeaderTableViewCell: UITableViewCell {

    var flavor:Flavor!
    
    var labelInitialBalance:UILabel!
    var valueInitialBalance:UILabel!
    var wrapperInitialBalance:UIStackView!
    
    var labelTotalCredit:UILabel!
    var valueTotalCredit:UILabel!
    var wrapperTotalCredit:UIStackView!
    
    var labelTotalDebit:UILabel!
    var valueTotalDebit:UILabel!
    var wrapperTotalDebit:UIStackView!
    
    var wrapperCreditDebit:UIStackView!
    
    var labelFinalBalance:UILabel!
    var valueFinalBalance:UILabel!
    var wrapperFinalBalance:UIStackView!
    
    var verticalWrapperStackView:UIStackView!
    var viewsWraper:UIView!
    
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
        flavor = Flavor()
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        
        viewsWraper = UIView()
        viewsWraper.backgroundColor = UtilsIsm.getBackgroundColor(vc: self)
        viewsWraper.layer.borderWidth = 1
        viewsWraper.layer.borderColor = legacyChrome.GREY_CLEAR.cgColor
        viewsWraper.layer.cornerRadius = 5
        viewsWraper.clipsToBounds = true
        
        
        //Initial Balance
        labelInitialBalance = {
            let label = UILabel()
            label.text = "Initial balance"
            label.textAlignment = .left
            label.font = UIFont(name: "Lato-Regular", size: 11)
            
            return label
        }()
        valueInitialBalance = {
            let label = UILabel()
            label.text = ""
            label.textAlignment = .left
            label.font = UIFont(name: "Lato-Regular", size: 13)
            
            return label
        }()
        wrapperInitialBalance = {
            let s = UIStackView(arrangedSubviews: [labelInitialBalance, valueInitialBalance])
            s.axis = .horizontal
            s.distribution = .fill
            s.alignment = .center
            s.spacing = 6
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return s
        }()
        
       
        //Total Credit
        labelTotalCredit = {
            let label = UILabel()
            label.text = "Total Credit"
            label.textAlignment = .left
            label.textColor = mmChrome.LIGHT_GREY
            label.font = UIFont(name: "Lato-Regular", size: 11)
            
            return label
        }()
        valueTotalCredit = {
            let label = UILabel()
            label.text = ""
            label.textAlignment = .left
            label.textColor = Const.BLUE
            label.font = UIFont(name: "Lato-Regular", size: 13)
            
            return label
        }()
        wrapperTotalCredit = {
            let s = UIStackView(arrangedSubviews: [labelTotalCredit, valueTotalCredit])
            s.axis = .vertical
            s.distribution = .fill
            s.alignment = .center
            s.spacing = 6
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return s
        }()
        
       
        //Total Debit
        labelTotalDebit = {
            let label = UILabel()
            label.text = "Total Debit"
            label.textAlignment = .right
            label.textColor = mmChrome.LIGHT_GREY
            label.font = UIFont(name: "Lato-Regular", size: 11)
            
            return label
        }()
        valueTotalDebit = {
            let label = UILabel()
            label.text = ""
            label.textAlignment = .right
            label.textColor = Const.RED
            label.font = UIFont(name: "Lato-Regular", size: 13)
            
            return label
        }()
        wrapperTotalDebit = {
            let s = UIStackView(arrangedSubviews: [labelTotalDebit, valueTotalDebit])
            s.axis = .vertical
            s.distribution = .fill
            s.alignment = .center
            s.spacing = 6
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return s
        }()
       
        
        wrapperCreditDebit = {
            let s = UIStackView(arrangedSubviews: [wrapperTotalCredit, wrapperTotalDebit])
            s.axis = .horizontal
            s.distribution = .fill
            s.alignment = .center
            s.spacing = 6
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return s
        }()
        
       
        //Final Balance
        labelFinalBalance = {
            let label = UILabel()
            label.text = "Final Balance"
            label.textAlignment = .left
            label.textColor = mmChrome.LIGHT_GREY
            label.font = UIFont(name: "Lato-Regular", size: 11)
            
            return label
        }()
        valueFinalBalance = {
            let label = UILabel()
            label.text = ""
            label.textAlignment = .left
            label.font = UIFont(name: "Lato-Regular", size: 13)
            
            return label
        }()
        wrapperFinalBalance = {
            let s = UIStackView(arrangedSubviews: [labelFinalBalance, valueFinalBalance])
            s.axis = .horizontal
            s.distribution = .fill
            s.alignment = .center
            s.spacing = 6
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return s
        }()
      
        
        verticalWrapperStackView = {
            let s = UIStackView(arrangedSubviews: [wrapperInitialBalance, wrapperCreditDebit, wrapperFinalBalance])
            s.axis = .vertical
            s.distribution = .fill
            s.alignment = .center
            s.spacing = 6
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return s
        }()
        wrapperInitialBalance.topToSuperview(offset:10)
        wrapperInitialBalance.leftToSuperview(offset:10)
        wrapperInitialBalance.rightToSuperview(offset:-10)

        wrapperCreditDebit.leftToSuperview(offset:10)
        wrapperCreditDebit.rightToSuperview(offset:-10)

        wrapperFinalBalance.leftToSuperview(offset:10)
        wrapperFinalBalance.rightToSuperview(offset:-10)
        wrapperFinalBalance.bottomToSuperview(offset:-10)
        
       
        
        viewsWraper.addSubview(verticalWrapperStackView)
        verticalWrapperStackView.edgesToSuperview()
        addSubview(viewsWraper)
        viewsWraper.edgesToSuperview()
        

    }

}
