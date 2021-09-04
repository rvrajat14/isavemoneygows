//
//  CoTransBtn.swift
//  CheckoutModule
//
//  Created by ARMEL KOUDOUM on 12/5/20.
//

import Foundation
import UIKit


public class CoTransBtn: UIButton {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.clear
        
        self.setTitleColor(CoUtilities.getUIColor(named: "checkout_btn_trans_btn_txt"), for: .normal)
        self.titleLabel?.font = UIFont(name: CoFontFamily.ButtonText, size: CoFontSizes.TRANS_BTN_TEXT_SIZE)
       
       
    }
}

