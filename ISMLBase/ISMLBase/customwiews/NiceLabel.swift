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
       
        super.init(frame: .zero)
        self.baseLabel = title
        text = title
        font = UIFont(name: IsmFontFamily.DmsansRegular, size: IsmDimems.formLabelSize)
        textColor = UIColor(named: "formLabelColor")
        textAlignment = NSTextAlignment.left
        self.textInsets = UIEdgeInsets(top: 15, left: 0, bottom: 5, right: 0)
        height(35)
        
        
    }
    
    public func appendValue(value: String) {
        text = self.baseLabel + value
    }
    
    public required init?(coder aDecoder: NSCoder) {
        //fatalError("required init?(coder aDecoder: NSCoder) has not been implemented")
        super.init(coder: aDecoder)
        font = UIFont(name: IsmFontFamily.DmsansRegular, size: IsmDimems.formLabelSize)
        textColor = UIColor(named: "formLabelColor")
        textAlignment = NSTextAlignment.left
        self.textInsets = UIEdgeInsets(top: 15, left: 0, bottom: 5, right: 0)
        height(35)
    }
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: self.textInsets))
    }

}
 
