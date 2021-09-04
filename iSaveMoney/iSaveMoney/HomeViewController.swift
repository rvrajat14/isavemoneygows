//
//  HomeViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 4/12/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    static var viewIdentifier:String = "HomeViewController"
    
    @IBOutlet weak var txtPleaseWait: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true

        self.txtPleaseWait.text = NSLocalizedString("text_wait", comment: "Wait...")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
