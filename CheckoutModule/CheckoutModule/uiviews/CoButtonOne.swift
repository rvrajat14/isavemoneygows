//
//  CoButtonOne.swift
//  CheckoutModule
//
//  Created by ARMEL KOUDOUM on 12/5/20.
//

import Foundation
import UIKit


public class CoButtonOne: UIButton {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = CoUtilities.getUIColor(named: "checkout_btn_one_bg")
        self.layer.cornerRadius = 5
        self.setTitleColor(CoUtilities.getUIColor(named: "checkout_btn_one_txt"), for: .normal)
        self.titleLabel?.font = UIFont(name: CoFontFamily.ButtonText, size: CoFontSizes.BTN_TEXT_SIZE)
       
       
    }
}
