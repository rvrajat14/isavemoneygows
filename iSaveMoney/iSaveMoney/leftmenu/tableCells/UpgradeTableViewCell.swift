//
//  UpgradeTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 3/6/20.
//  Copyright © 2020 UlmatCorpit. All rights reserved.
//

import UIKit
import TinyConstraints
import ISMLBase

public protocol OnUpgrade:class {
    func onPressUpgrade()
}

class UpgradeTableViewCell: UITableViewCell {
    
    var delegate: OnUpgrade!
    lazy var upgradeButton:IsmUpgradeButton = {
        let btn = IsmUpgradeButton()
        btn.setTitle(NSLocalizedString("drawerUpgrade", comment: "Upgrade to PRO"), for: .normal)
        btn.height(48)
        return btn
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
        
      
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
       
        addSubview(upgradeButton)
        upgradeButton.edgesToSuperview(insets: .top(5) + .left(15) + .right(10) + .bottom(5))
        upgradeButton.addTarget(self, action: #selector(upgradeNow), for: .touchUpInside)
       

        
    }
    @objc func upgradeNow() {
        delegate.onPressUpgrade()
    }
    
}
