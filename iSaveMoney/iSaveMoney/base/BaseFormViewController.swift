//
//  BaseFormViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 7/9/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit
import Firebase
import ISMLDataService
import FirebaseFirestore
import ISMLBase

class BaseFormViewController: BaseViewController {

    
    
    var firestoreRef: Firestore!
    var pref: MyPreferences!
    var flavor:Flavor!
    var appDelegate:AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pref = MyPreferences()
        self.view.backgroundColor = UIColor(named: "pageBgColor")
        flavor = Flavor()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.firestoreRef = appDelegate.firestoreRef
//        navigationController?.navigationBar.tintColor = flavor.getNavigationBarColor()
//        navigationController?.navigationBar.barTintColor = flavor.getPrimaryColor()
//
//        self.navigationController?.navigationBar.tintColor = flavor.getNavigationBarColor()
//        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.barTintColor =  Const.background1
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
        // Do any additional setup after loading the view.
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
