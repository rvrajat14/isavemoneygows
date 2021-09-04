//
//  NiceNeutralButton.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/29/20.
//  Copyright © 2020 UlmatCorpit. All rights reserved.
//

import UIKit

public class NiceNeutralButton: UIButton {
    
    var payload:String!
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public init(title: String) {
        super.init(frame: .zero)
        backgroundColor = Const.GREY_CLEAR
        setTitle(title, for: .normal)
        setTitleColor(.darkGray, for: .normal)
        titleLabel?.font =  UIFont.boldSystemFont(ofSize: 13)
        layer.cornerRadius = 5
        layer.borderColor = Const.GREY.cgColor
        layer.borderWidth = 1
        //height(30)
        payload = title
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder aDecoder: NSCoder) has not been implemeted")
    }
}
