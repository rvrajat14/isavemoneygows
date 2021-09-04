//
//  PlusButton.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 12/8/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import UIKit
import TinyConstraints

public class PlusButton: UIButton {
    
    public init(image: String, color:UIColor) {
        super.init(frame: .zero)
        frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        setImage(UIImage(named: image), for: .normal)
        tintColor = .white
        backgroundColor = color
        width(30)
        height(30)
        layer.cornerRadius = 15
        clipsToBounds = true
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder aDecoder: NSCoder) has not been implemeted")
    }
    
}
