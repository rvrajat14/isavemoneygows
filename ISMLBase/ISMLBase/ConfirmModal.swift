//
//  ConfirmModal.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/2/20.
//  Copyright © 2020 UlmatCorpit. All rights reserved.
//

import Foundation
import UIKit

public class ConfirmModal {
    public static func getModal(title: String, message: String, okText: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: okText, style: UIAlertAction.Style.default, handler: nil))

        return alert;
    }
    
}
