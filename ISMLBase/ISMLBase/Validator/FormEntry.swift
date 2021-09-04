//
//  FormEntry.swift
//  ISMLBase
//
//  Created by ARMEL KOUDOUM on 11/12/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import Foundation
import UIKit

public class FormEntry {
    
    public var editText: UITextField
    public var errorLabel: UILabel
    
    public init(edit: UITextField, err: UILabel) {
        self.editText = edit
        self.errorLabel = err
    }
}
