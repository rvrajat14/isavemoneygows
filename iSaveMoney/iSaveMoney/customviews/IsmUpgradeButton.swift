//
//  IsmUpgradeButton.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 12/9/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import Foundation
import UIKit
import ISMLBase

public class IsmUpgradeButton: UIButton {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor(named: "upgradeButtonBgColor")
        self.layer.cornerRadius = 5
        self.setTitleColor(UIColor(named: "buttonTextColor"), for: .normal)
        //var image = UIImage(named: "arrow_outline")
        // self.addExpenseButton.imageView?.contentMode = .scaleAspectFit
        self.setImage(UIImage(named: "upgradeIcon"), for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
        self.height(IsmDimems.textEditHeightSize)
       
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 5, left: (bounds.width - 35), bottom: 5, right: 5)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
        }
    }
}
