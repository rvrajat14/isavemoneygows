//
//  ImportCSVController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/16/20.
//  Copyright © 2020 UlmatCorpit. All rights reserved.
//

import UIKit
import TinyConstraints
import Firebase
import SwiftValidator
import FirebaseFirestore
import ISMLDataService
import ISMLBase

class ImportCSVController: BaseViewController, UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate {

    static var viewIdentifier:String = "ImportCSVController"
    static var kUTTypePDF = ".csv"

    var firestoreRef:Firestore!
    var pref:MyPreferences!
    var flavor:Flavor!
    var appDelegate:AppDelegate!
    
    var selectFile: NiceButton = {
        var button = NiceButton(title: NSLocalizedString("impcsv_select_file", comment: "Select file"))
        button.addTarget(self, action: #selector(clickFunction), for: .touchUpInside)
        return button
    }()
    
    
    
    var viewControllerNavController:UINavigationController!
    override func viewDidLoad() {
        super.viewDidLoad()

        flavor = Flavor()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
    
//        self.navigationController!.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.tintColor = flavor.getNavigationBarColor()
//        navigationController?.navigationBar.barTintColor = flavor.getPrimaryColor()
        //navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:flavor.getNavigationBarColor(), NSAttributedString.Key.font: UIFont(name: "Lato-Bold", size: 18)!]
        self.title = NSLocalizedString("impcsv_vc_title", comment: "Signin")
        
        self.view.addSubview(selectFile)
        selectFile.topToSuperview(offset: 10)
        selectFile.centerXToSuperview()
        
        // Do any additional setup after loading the view.
    }
    
    @objc func clickFunction(){
        
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(".csv")], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }

    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
    }
    
    
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        //dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }

}
