//
//  ConfirmMessage.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 6/21/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import Foundation
import UIKit

public class ConfirmMessage {
    
    var alert:UIAlertController
    
    public init(title:String, message:String) {
        alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        
        
    }
    
    public func getAlert() -> UIAlertController {
        
        return alert
    }
    
}
