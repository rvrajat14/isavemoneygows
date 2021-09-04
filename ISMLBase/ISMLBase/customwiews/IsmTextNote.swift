//
//  IsmTextNote.swift
//  ISMLBase
//
//  Created by ARMEL KOUDOUM on 12/10/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import Foundation
import UIKit
import TinyConstraints

public class IsmTextNote: UITextView {

    var insets: UIEdgeInsets
    public init(placeholder: String = "" ) {
        self.insets =  UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        super.init(frame: .zero, textContainer: nil)
        layer.cornerRadius = 5
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(named: "textInputBorderColor")?.cgColor
        layer.backgroundColor = UIColor(named: "textInputBgColor")?.cgColor
        //self.placeholder = placeholder
        autocorrectionType = UITextAutocorrectionType.no
        keyboardType = UIKeyboardType.default
        returnKeyType = UIReturnKeyType.done
        textColor = UIColor(named: "textInputTextColor")
        height(IsmDimems.textNotesHeightSize)
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
        height(IsmDimems.textNotesHeightSize)
        font = UIFont(name: IsmFontFamily.DmsansRegular, size: IsmDimems.textEditFontSize)
    }
    

}
