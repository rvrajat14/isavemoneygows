//
//  CoNormalText.swift
//  CheckoutModule
//
//  Created by ARMEL KOUDOUM on 12/5/20.
//

import UIKit

public class CoNormalText: UILabel {
    
    var baseLabel:String!
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    public init(title: String = "") {
       
        super.init(frame: .zero)
        self.baseLabel = title
        text = title
        font = UIFont(name: CoFontFamily.NormalText, size: CoFontSizes.NORMAL_TEXT_SIZE)
        textColor = CoUtilities.getUIColor(named: "checkout_normal_txt")
        textAlignment = NSTextAlignment.left
        
    }
    
    public func appendValue(value: String) {
        text = self.baseLabel + value
    }
    
    public required init?(coder aDecoder: NSCoder) {
        //fatalError("required init?(coder aDecoder: NSCoder) has not been implemented")
        super.init(coder: aDecoder)
        font = UIFont(name: CoFontFamily.NormalText, size: CoFontSizes.NORMAL_TEXT_SIZE)
        textColor = CoUtilities.getUIColor(named: "checkout_normal_txt")
        textAlignment = NSTextAlignment.left
       
    }
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: self.textInsets))
    }

}
 

