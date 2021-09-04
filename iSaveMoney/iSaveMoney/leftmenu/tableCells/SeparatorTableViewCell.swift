//
//  DrawerTitleTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 11/22/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import ISMLBase

class SeparatorTableViewCell: UITableViewCell {
    
    
    lazy var textTitle:HeaderLevelFour = {
        let label = HeaderLevelFour()
        label.text = "My account"
        label.textAlignment = .left
        return label
    }()
    
    
    lazy var separator_1:UIView = {
        let sep = UIView()
        sep.height(1)
        sep.backgroundColor = UIColor(named: "seperatorColor")
        return sep
    }()
    
    
    lazy var stackOfWiews:UIStackView = {
        let s = UIStackView(arrangedSubviews: [separator_1, textTitle])
        s.axis = .vertical
        s.distribution = .fill
        s.alignment = .center
        s.spacing = 12
        s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return s
    }()
    
    var flavor:Flavor!
    
    let rightArrowImage = UIImage(named: "arrow")
    
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
        addSubview(stackOfWiews)
        stackOfWiews.edgesToSuperview(insets: .top(20))
        separator_1.leftToSuperview(offset: 10)
        textTitle.leftToSuperview(offset: 10)
        
 
    }
    
}
