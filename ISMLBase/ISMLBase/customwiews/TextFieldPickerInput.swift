//
//  TextFieldPickerInput.swift
//  ISMLBase
//
//  Created by ARMEL KOUDOUM on 10/30/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import TinyConstraints


public class TextFieldPickerInput: UITextField {

    var insets: UIEdgeInsets
    
    public init(placeholder: String = "",insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 24)) {
        self.insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 24)
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
        
        rightView = TxtImageView(image: UIImage(named: "right_chevron"))
        rightView?.tintColor = UIColor(named: "textInputIconsColor")
        rightView?.width(24)
        rightView?.height(24)
        rightViewMode = UITextField.ViewMode.always
    }
    
    public required init?(coder aDecoder: NSCoder) {
        //fatalError("required init?(coder aDecoder: NSCoder) has not been implemented")
        //super.init(frame: .zero)
        self.insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 24)
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
        
        rightView = TxtImageView(image: UIImage(named: "dropdown"))
        rightView?.tintColor = UIColor(named: "textInputIconsColor")
        rightView?.width(24)
        rightView?.height(24)
        rightViewMode = UITextField.ViewMode.always
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.insets)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.insets)
    }
}

