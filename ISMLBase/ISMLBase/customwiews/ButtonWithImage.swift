//
//  ButtonWithImage.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 1/28/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import Foundation
import UIKit

public class ButtonWithImage: UIButton {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 5, left: (bounds.width - 35), bottom: 5, right: 5)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
        }
    }
}
