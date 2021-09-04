//
//  CalInputTextField.swift
//  ToolsBoxModule
//
//  Created by ARMEL KOUDOUM on 12/8/20.
//

import Foundation
import UIKit

public class CalInputTextField: UITextField {

    var insets: UIEdgeInsets
    
    
    public required init?(coder aDecoder: NSCoder) {
        //fatalError("required init?(coder aDecoder: NSCoder) has not been implemented")
        //super.init(frame: .zero)
        self.insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        super.init(coder: aDecoder)
        
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.insets)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.insets)
    }
}

