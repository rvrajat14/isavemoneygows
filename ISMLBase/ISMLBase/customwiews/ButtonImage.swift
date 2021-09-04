//
//  ButtonImage.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 12/6/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import UIKit

public class ButtonImage: UIButton {
    
    public init(image: String, color:UIColor) {
        super.init(frame: .zero)
        frame = CGRect(x: 20, y: 20, width: 24, height: 24)
        setImage(UIImage(named: image), for: .normal)
        tintColor = color
        
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder aDecoder: NSCoder) has not been implemeted")
    }
    
}
