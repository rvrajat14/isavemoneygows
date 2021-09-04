//
//  CoHeaderOne.swift
//  CheckoutModule
//
//  Created by ARMEL KOUDOUM on 12/5/20.
//

import UIKit

public class CoHeaderOne: UILabel {
    
    var baseLabel:String!
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    public init(title: String = "") {
       
        super.init(frame: .zero)
        self.baseLabel = title
        text = title
        font = UIFont(name: CoFontFamily.HOne, size: CoFontSizes.H1_SIZE)
        textColor = CoUtilities.getHOneColor()
        textAlignment = NSTextAlignment.center
        
    }
    
    public func appendValue(value: String) {
        text = self.baseLabel + value
    }
    
    public required init?(coder aDecoder: NSCoder) {
        //fatalError("required init?(coder aDecoder: NSCoder) has not been implemented")
        super.init(coder: aDecoder)
        font = UIFont(name: CoFontFamily.HOne, size: CoFontSizes.H1_SIZE)
        textColor = CoUtilities.getHOneColor()
        textAlignment = NSTextAlignment.center
       
    }
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: self.textInsets))
    }

}
