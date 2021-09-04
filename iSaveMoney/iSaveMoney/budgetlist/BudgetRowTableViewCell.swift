//
//  BudgetRowTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 3/6/20.
//  Copyright © 2020 UlmatCorpit. All rights reserved.
//

import UIKit
import TinyConstraints
import ISMLBase

class BudgetRowTableViewCell: UITableViewCell {
    
    
    lazy var textTitle:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "Lato-Heavy", size: 17)
        
        return label
    }()
    
    lazy var textStatus:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = mmChrome.BLUE
        label.font = UIFont(name: "Lato-Regular", size: 14)
        
        return label
    }()
    
    lazy var txtOwner:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "Lato-Regular", size: 12)
        
        return label
    }()
    
 
    lazy var viewWrapper:UIView = {
        let vw = UIView()
        
        return vw
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
        
        //addSubview(viewWrapper)
        //viewWrapper.edgesToSuperview()
        self.backgroundColor = UIColor.clear
    
        
        self.addSubview(textTitle)
        textTitle.edgesToSuperview(excluding: .bottom, insets: .left(20) + .top(10))
        self.addSubview(textStatus)
        textStatus.leftToSuperview(offset: 20)
        textStatus.topToBottom(of: textTitle)
        textStatus.bottomToSuperview(offset: -10)
        
        self.addSubview(txtOwner)
        txtOwner.rightToSuperview(offset: -10)
        txtOwner.topToBottom(of: textTitle)
        
       
    }

}
