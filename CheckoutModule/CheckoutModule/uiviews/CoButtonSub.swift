//
//  CoButtonSub.swift
//  CheckoutModule
//
//  Created by ARMEL KOUDOUM on 12/6/20.
//

import Foundation
import UIKit


public class CoButtonSub: UIButton {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = CoUtilities.getUIColor(named: "checkout_btn_one_bg")
        self.layer.cornerRadius = 5
        self.setTitleColor(CoUtilities.getUIColor(named: "checkout_btn_one_txt"), for: .normal)
        self.titleLabel?.font = UIFont(name: CoFontFamily.ButtonSub, size: CoFontSizes.TRANS_BTN_SUB_SIZE)
       
       
    }
}
