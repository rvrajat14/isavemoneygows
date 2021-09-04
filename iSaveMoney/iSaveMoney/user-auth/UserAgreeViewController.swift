//
//  UserAgreeViewController.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 12/19/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit

class UserAgreeViewController: UIViewController {

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
        self.title = NSLocalizedString("userGree", comment: "Create account")
        // Do any additional setup after loading the view.
    }
    @objc func cancel(_ sender: AnyObject) {
        
        self.dismiss(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
