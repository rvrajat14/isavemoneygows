//
//  TransButton.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 11/23/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import UIKit

public class TransButton: UIButton {
    
    var payload:String!
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public init(title: String) {
        super.init(frame: .zero)
        backgroundColor = UIColor.clear
        setTitle(title, for: .normal)
        setTitleColor(Const.BLUE, for: .normal)
        titleLabel?.font =  UIFont.boldSystemFont(ofSize: 13)
        //height(30)
        payload = title
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder aDecoder: NSCoder) has not been implemeted")
    }
}
