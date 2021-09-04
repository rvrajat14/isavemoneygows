//
//  ImsBtnCalculator.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 12/10/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import Foundation
import UIKit

public class ImsBtnCalculator: UIButton {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .clear
//        self.layer.cornerRadius = 5
//        self.setTitleColor(UIColor(named: "buttonTextColor"), for: .normal)
        //var image = UIImage(named: "arrow_outline")
        // self.addExpenseButton.imageView?.contentMode = .scaleAspectFit
        self.setImage(UIImage(named: "calculator")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        self.tintColor = UIColor(named: "tintIconsColor")
        self.imageView?.contentMode = .scaleAspectFit
        self.height(24)
        self.width(24)
       
    }
}


