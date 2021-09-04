//
//  PrivacyViewController.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 12/21/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit

class PrivacyViewController: UIViewController {

    lazy var cancelButton:UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "back_icon"),
                               landscapeImagePhone: UIImage(named: "back_icon"),
                               style: .plain,
                               target: self,
                               action: #selector(cancel(_:)))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem  = cancelButton
        self.title = NSLocalizedString("privacyPolicy", comment: "Privacy Policy")
        // Do any additional setup after loading the view.
    }


    @objc func cancel(_ sender: AnyObject) {
        
        self.dismiss(animated: true)
    }

}
