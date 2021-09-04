//
//  CoBoxCard.swift
//  CheckoutModule
//
//  Created by ARMEL KOUDOUM on 12/6/20.
//

import Foundation
import UIKit
import Darwin

public class CoBoxCard: UIView {
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.backgroundColor = CoUtilities.getUIColor(named: "checkout_box_card")?.cgColor
        self.layer.cornerRadius = 5
        
       
        
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)

        self.layer.backgroundColor = CoUtilities.getUIColor(named: "checkout_box_card")?.cgColor
        self.layer.cornerRadius = 5
    }
    
    
    

}
