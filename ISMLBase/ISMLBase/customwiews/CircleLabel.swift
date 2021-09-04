//
//  CircleLabel.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 11/24/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import UIKit

public class CircleLabel: UILabel {
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
        
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    public func commonInit(){
        self.layer.cornerRadius = self.bounds.width/2
        self.clipsToBounds = true
        self.textColor = UIColor.white
        self.setProperties(borderWidth: 1.0, borderColor:UIColor.black)
    }
    public func setProperties(borderWidth: Float, borderColor: UIColor) {
        self.layer.borderWidth = CGFloat(borderWidth)
        self.layer.borderColor = borderColor.cgColor
    }
}
