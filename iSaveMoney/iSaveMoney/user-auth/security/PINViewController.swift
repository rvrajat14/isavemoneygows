//
//  PINViewController.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 9/13/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit
import KAPinField
import ISMLBase

class PINViewController: UIViewController, KAPinFieldDelegate {
    
    

    @IBOutlet weak var textEnterPin: KAPinField!
    @IBOutlet weak var refreshButton: UIButton!
    
    var pref: MyPreferences!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        textEnterPin.properties.delegate = self
        textEnterPin.properties.token = "-" // Default to "•"
        textEnterPin.properties.numberOfCharacters = 4 // Default to 4
        textEnterPin.properties.validCharacters = "0123456789+#?" // Default to only numbers, "0123456789"
        textEnterPin.properties.animateFocus = true // Animate the currently focused token
        textEnterPin.properties.isSecure = false // Secure pinField will hide actual input
        textEnterPin.properties.secureToken = "*" // Token used to hide actual character input when using isSecure = true
        // Do any additional setup after loading the view.
        
        textEnterPin.becomeFirstResponder()
        
        
        
        refreshButton.tintColor = Const.BLUE
        let icon = UIImage(named: "refresh")!
        refreshButton.setImage(icon, for: .normal)
        refreshButton.imageView?.contentMode = .scaleAspectFit
        refreshButton.imageView?.tintColor = Const.BLUE
        refreshButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        refreshButton.addTarget(self, action: #selector(clearPinInput), for: .touchUpInside)
        self.pref = MyPreferences()
    }


    func pinField(_ field: KAPinField, didFinishWith code: String) {
        print("Code: \(code)")
        if(self.pref.getUnlockCode() == code) {
            self.dismiss(animated: true)
        }else {
            textEnterPin.animateFailure() {
                print("Failure")
                self.textEnterPin.text = ""
                self.textEnterPin.reloadAppearance()
            }
        }
        
    }
    
    @objc func clearPinInput() {
        textEnterPin.text = ""
        textEnterPin.reloadAppearance()
        textEnterPin.becomeFirstResponder()
    }

}
