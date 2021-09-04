//
//  InputBackgroundView.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 12/9/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import Foundation
import UIKit
import Darwin
import ISMLBase

public class InputBackgroundView: UIView {
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderColor = UIColor(named: "textInputBorderColor")?.cgColor
        self.layer.backgroundColor = UIColor(named: "textInputBorderColor")?.cgColor
        self.layer.cornerRadius = 5
        self.height(IsmDimems.textEditHeightSize)
        
       
        
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)

        self.layer.borderColor = UIColor(named: "textInputBorderColor")?.cgColor
        self.layer.backgroundColor = UIColor(named: "textInputBorderColor")?.cgColor
        self.layer.cornerRadius = 5
        self.height(IsmDimems.textEditHeightSize)
    }
    
    
    

}
