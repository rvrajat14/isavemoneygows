//
//  NiceTextField.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 11/23/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import UIKit
import TinyConstraints


public class NiceTextField: UITextField {

    var insets: UIEdgeInsets
    
    public init(placeholder: String = "",insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)) {
        self.insets = insets
        super.init(frame: .zero)
        layer.cornerRadius = 5
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(named: "textInputBorderColor")?.cgColor
        layer.backgroundColor = UIColor(named: "textInputBgColor")?.cgColor
        self.placeholder = placeholder
        autocorrectionType = UITextAutocorrectionType.no
        keyboardType = UIKeyboardType.default
        returnKeyType = UIReturnKeyType.done
        textColor = UIColor(named: "textInputTextColor")
        height(IsmDimems.textEditHeightSize)
        font = UIFont(name: IsmFontFamily.DmsansRegular, size: IsmDimems.textEditFontSize)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        //fatalError("required init?(coder aDecoder: NSCoder) has not been implemented")
        //super.init(frame: .zero)
        self.insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        super.init(coder: aDecoder)
        
        
        layer.cornerRadius = 5
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(named: "textInputBorderColor")?.cgColor
        layer.backgroundColor = UIColor(named: "textInputBgColor")?.cgColor
        //self.placeholder = placeholder
        autocorrectionType = UITextAutocorrectionType.no
        keyboardType = UIKeyboardType.default
        returnKeyType = UIReturnKeyType.done
        textColor = UIColor(named: "textInputTextColor")
        height(IsmDimems.textEditHeightSize)
        font = UIFont(name: IsmFontFamily.DmsansRegular, size: IsmDimems.textEditFontSize)
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.insets)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.insets)
    }
}
