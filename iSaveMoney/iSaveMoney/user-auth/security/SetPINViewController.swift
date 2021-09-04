//
//  SetPINViewController.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 9/13/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//
import UIKit
import KAPinField
import ISMLBase

class SetPINViewController: BaseScreenViewController, KAPinFieldDelegate {

    @IBOutlet weak var textInstruction: UILabel!
    @IBOutlet weak var textEnterPin: KAPinField!
    @IBOutlet weak var refreshButton: UIButton!
    
    lazy var cancelButton:UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "back_icon"),
                               landscapeImagePhone: UIImage(named: "back_icon"),
                               style: .plain,
                               target: self,
                               action: #selector(cancel(_:)))
    }()
    var previousCode:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem  = cancelButton
        self.title = NSLocalizedString("pinSettings", comment: "PIN settings")
        
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
        // Do any additional setup after loading the view.
    }

    func pinField(_ field: KAPinField, didFinishWith code: String) {
        print("Code: \(code) \(previousCode)")
        if previousCode == nil {
            self.textInstruction.text = NSLocalizedString("confirmpasscode", comment: "Confirm Passcord")
            previousCode = code
            textEnterPin.text = ""
            textEnterPin.reloadAppearance()
        } else{
            if code == previousCode {
                self.pref.setUnlockCode(previousCode!)
                textEnterPin.animateSuccess(with: "👍") {
                    self.navigationController?.popViewController(animated: true)
                }
                
            }else{
               
                textEnterPin.animateFailure() {
                    print("Failure")
                    self.previousCode = nil
                    self.textInstruction.text = NSLocalizedString("EnterPasscode", comment: "Enter Passcode")
                    self.textEnterPin.text = ""
                    self.textEnterPin.reloadAppearance()
                }
               
            }
        }
    }
    
    @objc func clearPinInput() {
        textEnterPin.text = ""
        textEnterPin.reloadAppearance()
        textEnterPin.becomeFirstResponder()
    }

    @objc func cancel(_ sender: UIBarButtonItem) {
        
        appDelegate.navigateTo(instance: ViewController())
    }
}
