//
//  ErrorLabel.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 11/23/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import UIKit

public class ErrorLabel: UILabel {
    
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    public init(title: String = "",insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)) {
        self.textInsets = insets
        super.init(frame: .zero)
        text = title
        font = UIFont.systemFont(ofSize: 9)
        textColor = .red
        textAlignment = NSTextAlignment.right
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        font = UIFont.systemFont(ofSize: 9)
        textColor = .red
        textAlignment = NSTextAlignment.right
    }
    
    public override func drawText(in rect: CGRect) {
        
        super.drawText(in: rect.inset(by: self.textInsets))
        
    }
    
}

