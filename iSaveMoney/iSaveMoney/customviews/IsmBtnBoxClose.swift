//
//  IsmBtnBoxClose.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 12/12/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import Foundation
import UIKit

public class IsmBtnBoxClose: UIButton {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .clear
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor(named: "cardBackgroundColor")
       
        self.setImage(UIImage(named: "close-icon")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        self.tintColor = UIColor(named: "tintIconsColor")
        self.imageView?.contentMode = .scaleAspectFit
        self.height(24)
        self.width(24)
       
    }
}

