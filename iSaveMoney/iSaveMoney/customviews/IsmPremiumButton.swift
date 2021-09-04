//
//  IsmPremiumButton.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 12/17/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import Foundation
import UIKit
import ISMLBase

public class IsmPremiumButton: UIButton {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .clear
        self.layer.cornerRadius = 5
        self.setTitleColor(UIColor(named: "upgradeButtonBgColor"), for: .normal)
        //var image = UIImage(named: "arrow_outline")
        // self.addExpenseButton.imageView?.contentMode = .scaleAspectFit
        self.setImage(UIImage(named: "premium_badge"), for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
        self.imageView?.tintColor = UIColor(named: "upgradeButtonBgColor")
        self.contentHorizontalAlignment  = .left
        self.height(IsmDimems.textEditHeightSize)
       
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 5)//(bounds.width - 35)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
        }
    }
}

