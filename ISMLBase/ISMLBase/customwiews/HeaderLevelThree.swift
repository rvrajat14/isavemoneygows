//
//  HeaderLevelThree.swift
//  ISMLBase
//
//  Created by ARMEL KOUDOUM on 10/30/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit

public class HeaderLevelThree: UILabel {
    
    var baseLabel:String!
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    public init(title: String = "") {
       
        super.init(frame: .zero)
        self.baseLabel = title
        text = title
        font = UIFont(name: IsmFontFamily.DmsansBold, size: IsmDimems.header_level3_size)
        textColor = UIColor(named: "headerLevel3Color")
        textAlignment = NSTextAlignment.left
        
    }
    
    public func appendValue(value: String) {
        text = self.baseLabel + value
    }
    
    public required init?(coder aDecoder: NSCoder) {
        //fatalError("required init?(coder aDecoder: NSCoder) has not been implemented")
        super.init(coder: aDecoder)
        font = UIFont(name: IsmFontFamily.DmsansBold, size: IsmDimems.header_level3_size)
        textColor = UIColor(named: "headerLevel3Color")
        textAlignment = NSTextAlignment.left
       
    }
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: self.textInsets))
    }

}
 

