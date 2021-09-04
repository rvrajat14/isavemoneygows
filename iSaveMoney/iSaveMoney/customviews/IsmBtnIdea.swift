//
//  IsmBtnIdea.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 12/12/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import Foundation
import UIKit

public class IsmBtnIdea: UIButton {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .clear
        self.setImage(UIImage(named: "give_idea")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        self.tintColor = UIColor(named: "tintIconsColor")
        self.imageView?.contentMode = .scaleAspectFit
        self.height(24)
        self.width(24)
       
    }
}
