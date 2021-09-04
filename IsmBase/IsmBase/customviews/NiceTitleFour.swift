//
//  NiceTitleFour.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/29/20.
//  Copyright © 2020 UlmatCorpit. All rights reserved.
//

import UIKit
public class NiceTitleFour: UILabel {
    
    var baseLabel:String!
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    public init(title: String = "",insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)) {
       
        self.textInsets = insets
        super.init(frame: .zero)
        self.baseLabel = title
        text = title
        font = UIFont(name: "Lato-Regular", size: 16)
        textColor = Const.greyDarkColor
        textAlignment = NSTextAlignment.left
        
    }
    public init() {
        
        super.init(frame: .zero)
        self.baseLabel = ""
        font = UIFont(name: "Lato-Regular", size: 16)
        textColor = Const.greyDarkColor
        textAlignment = NSTextAlignment.left
    }
    
    public func appendValue(value: String) {
        text = self.baseLabel + value
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("required init?(coder aDecoder: NSCoder) has not been implemented")
    }
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: self.textInsets))
    }

}

