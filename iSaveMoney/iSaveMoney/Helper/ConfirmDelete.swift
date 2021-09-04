//
//  ConfirmDelete.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 9/28/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit

class ConfirmDelete {
    
    var callback: ((Bool)->(Void))!
    init(){}
    
    func display(itemName: String,feedback: @escaping ((Bool)->(Void))) -> UIAlertController {
        self.callback = feedback
        let alert = UIAlertController(title: NSLocalizedString("confirm_delete", comment: "Delete"),
                                      message: String(format: NSLocalizedString("confirm_delete_msg", comment: "Delete message"), arguments: [itemName]),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("confirm_delete_continue", comment: "Default action"), style: .destructive, handler: { _ in
            
            self.callback(true)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("confirm_delete_cancel", comment: "Default action"), style: .cancel, handler: { _ in
        
        }))
        
        return alert
    }
}
