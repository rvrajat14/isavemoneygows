//
//  CalButton.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 11/21/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import Foundation
import UIKit

class CalButton: UIButton {
   
    var payload:String!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(title: String) {
        super.init(frame: .zero)
        backgroundColor = Const.blueText
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
        //font = UIFont.boldSystemFont(ofSize: 18)
        width(50)
        height(50)
        payload = title
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder aDecoder: NSCoder) has not been implemeted")
    }
}
