//
//  AccountTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/15/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import TinyConstraints
import ISMLBase

class AccountTableViewCell: UITableViewCell {

    lazy var circleText: CircleTextUIView = {
       let cir = CircleTextUIView()
       cir.height(32)
       cir.width(32)
       return cir
   }()
    
    lazy var textAcountName: NormalTextLabel = {
       let label = NormalTextLabel()
       return label
   }()
    lazy var accountBalance: HeaderLevelFour = {
       let label = HeaderLevelFour()
       label.textColor = Const.GREEN
       return label
   }()
    
    
    var flavor:Flavor!
    
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
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
        addSubview(circleText)
        circleText.leftToSuperview(offset: 20)
        circleText.topToSuperview(offset: 10)
        addSubview(textAcountName)
        textAcountName.edgesToSuperview(excluding: .bottom, insets: .left(60) + .top(10) + .left(10), usingSafeArea: true)
        addSubview(accountBalance)
        accountBalance.leftToSuperview(offset: 70)
        accountBalance.topToBottom(of: textAcountName)
        accountBalance.bottomToSuperview(offset: -10)
    }

}
