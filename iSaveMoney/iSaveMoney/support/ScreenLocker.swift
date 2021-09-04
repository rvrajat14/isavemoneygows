//
//  ScreenLocker.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 7/12/18.
//  Copyright © 2018 UlmatCorpit. All rights reserved.
//

import UIKit
import ISMLDataService
import ISMLBase

class ScreenLocker : BaseViewController  {
    
    static var viewIdentifier:String = "ScreenLocker"
    var pref: MyPreferences!
    var flavor:Flavor!
    
    var descriptionLabel:UILabel!
    var unlockTextView:UITextField!
    var unlockButton:UIButton!
    var helpButton:UIButton!
    
    var stackFormContent:UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flavor = Flavor()
        
        self.pref = MyPreferences()
        
//        self.navigationController!.navigationBar.isTranslucent = false
//        
//        navigationController?.navigationBar.tintColor = flavor.getNavigationBarColor()
//        navigationController?.navigationBar.barTintColor = flavor.getPrimaryColor()
        //navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:flavor.getNavigationBarColor(), NSAttributedString.Key.font: UIFont(name: "Lato-Bold", size: 18)!]
        
        
        self.title = "Unlock Code"
        
        // Do any additional setup after loading the view.
        
        setupForm()
        
    }
    
    func setupForm() {
        
        descriptionLabel =  {
            
            let label = UILabel()
            self.automaticallyAdjustsScrollViewInsets = false
            label.text = "Enter your unlock code to continue"
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 13)
            return label
        }()
        
        unlockTextView = {
            let description = UITextField(frame: CGRect(x: 20.0, y: 90.0, width: 250.0, height: 100.0))
            self.automaticallyAdjustsScrollViewInsets = false
            description.textAlignment = .left
            description.font = UIFont.systemFont(ofSize: 15)
            description.borderStyle = UITextField.BorderStyle.roundedRect
            description.autocorrectionType = UITextAutocorrectionType.no
            description.keyboardType = UIKeyboardType.default
            description.returnKeyType = UIReturnKeyType.done
            
            return description
        }()
        
        unlockButton = {
            
            let button = UIButton(type: UIButton.ButtonType.system) as UIButton
            self.automaticallyAdjustsScrollViewInsets = false
            button.frame = CGRect(x:50, y:100, width:150, height:45)
            button.backgroundColor = Const.BLUE
            button.setTitle("Unlock and continue", for: UIControl.State.normal)
            button.tintColor = UIColor.white
            button.layer.cornerRadius = 5
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(ScreenLocker.continueAction), for: .touchUpInside)
            return button
        }()
        
        helpButton = {
            
            let button = UIButton(type: UIButton.ButtonType.system) as UIButton
            self.automaticallyAdjustsScrollViewInsets = false
            button.frame = CGRect(x:50, y:100, width:150, height:45)
            button.backgroundColor = UIColor.white
            button.setTitle("Get the code here", for: UIControl.State.normal)
            button.tintColor = Const.BLUE
            button.layer.cornerRadius = 5
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(ScreenLocker.getUnlockCodeAction), for: .touchUpInside)
            return button
        }()
        
        stackFormContent = {
            let s = UIStackView(arrangedSubviews: [descriptionLabel, unlockTextView, unlockButton, helpButton])
            self.automaticallyAdjustsScrollViewInsets = false
            s.axis = .vertical
            s.distribution = .equalSpacing
            s.alignment = .fill
            s.spacing = 12
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return s
        }()
        
        descriptionLabel.leadingAnchor.constraint(equalTo: stackFormContent.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: stackFormContent.trailingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: stackFormContent.topAnchor).isActive = true
        
        unlockTextView.leadingAnchor.constraint(equalTo: stackFormContent.leadingAnchor).isActive = true
        unlockTextView.trailingAnchor.constraint(equalTo: stackFormContent.trailingAnchor).isActive = true
        
        unlockButton.leadingAnchor.constraint(equalTo: stackFormContent.leadingAnchor).isActive = true
        unlockButton.trailingAnchor.constraint(equalTo: stackFormContent.trailingAnchor).isActive = true
        
        helpButton.leadingAnchor.constraint(equalTo: stackFormContent.leadingAnchor).isActive = true
        helpButton.trailingAnchor.constraint(equalTo: stackFormContent.trailingAnchor).isActive = true
        
        //self.view.addSubview(descriptionLabel)
        stackFormContent.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackFormContent)
        
        stackFormContent.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        stackFormContent.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant:  -10).isActive = true
        stackFormContent.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true

        
    }
    
    @objc func continueAction() {
        
        let textUnlockCode:String = unlockTextView.text!
        
        if(textUnlockCode != "" &&  textUnlockCode == Const.SCREEN_LOCK_CODE) {
            
            //pref.getUnlockCode()
            pref.setUnlockCode(textUnlockCode)
        }
    }
    
    @objc func getUnlockCodeAction() {
        
        guard let url = URL(string: "https://mmadvisors.ie") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
