//
//  NiceButton.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 11/23/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import UIKit
import TinyConstraints

public class NiceButton: UIButton {
    
    var payload:String!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public init(title: String) {
        super.init(frame: .zero)
        contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 10, bottom: 0.0, right: -10)//UIEdgeInsets(top: 0, left: -10, bottom: 0, right: -10)
        backgroundColor = Const.blueText
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 5
        layer.masksToBounds = true
        titleLabel?.font =  UIFont.boldSystemFont(ofSize: 18)
        height(40)
        payload = title
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder aDecoder: NSCoder) has not been implemeted")
    }
}
