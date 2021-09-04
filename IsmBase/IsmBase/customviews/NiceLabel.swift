//
//  NiceLabel.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 11/23/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import UIKit

public class NiceLabel: UILabel {
    
    var baseLabel:String!
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    public init(title: String = "",insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)) {
       
        self.textInsets = insets
        super.init(frame: .zero)
        self.baseLabel = title
        text = title
        font = UIFont(name: "Lato-Regular", size: 13)
       
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
 
