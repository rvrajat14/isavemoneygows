//
//  PayerFormViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/13/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import Firebase
import SwiftValidator
import FirebaseFirestore
import ISMLBase
import ISMLDataService

class PayerFormViewController: BaseScreenViewController, UITextFieldDelegate, ValidationDelegate {

    static var viewIdentifier:String = "PayerFormViewController"
    
    //@IBOutlet weak var transactionDate: UITextField!
    @IBOutlet weak var transactionDate: UITextField!
    
    //@IBOutlet weak var textDescription: UITextField!
    @IBOutlet weak var textDescription: UITextField!
    
    //@IBOutlet weak var textTelephone: UITextField!
    @IBOutlet weak var textTelephone: UITextField!
    
    //@IBOutlet weak var textAddress: UITextField!
    @IBOutlet weak var textAddress: UITextField!
    
    //@IBOutlet weak var textErrorDescription: UILabel!
    @IBOutlet weak var textErrorDescription: UILabel!
    @IBOutlet weak var otherNotes: UITextField!
    
    var dateSelector:DatePicker!
    var mPayer:Payer!
    var validator:Validator!
    var navController: UINavigationController?
    var navItem: UINavigationItem?
    
    lazy var cancelButton:UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "back_icon"),
                               landscapeImagePhone: UIImage(named: "back_icon"),
                               style: .plain,
                               target: self,
                               action: #selector(PayerFormViewController.cancel(_:)))
    }()
    lazy var saveButton:UIBarButtonItem = {
        return UIBarButtonItem(title: NSLocalizedString("text_save", comment: "Save"),
                               style: .done,
                               target: self,
                               action:  #selector(PayerFormViewController.save(_:)))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mPayer = params["payer"] as? Payer ?? nil
        self.navItem = params["navigationItem"] as? UINavigationItem ?? self.navigationItem
        self.navController = params["navigationController"] as? UINavigationController ?? self.navigationController
        self.navItem?.leftBarButtonItem  = cancelButton
        self.navItem?.rightBarButtonItem = saveButton
        self.validator = Validator()
        
        let imageView = UIImageView()
        let image = UIImage(named: "date_range")
        imageView.image = image
        imageView.alpha = 0.5
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.gray
        imageView.frame = CGRect(x: 5, y: 0, width: 30, height: 30)
        transactionDate.rightView = imageView
        transactionDate.rightViewMode = UITextField.ViewMode.always
        
        //
        self.textErrorDescription.text = ""
        self.textDescription.tag = 1
        self.textDescription.delegate = self
        
        
        //
        self.textTelephone.tag = 2
        self.textTelephone.delegate = self
        
        //
        self.textAddress.tag = 3
        self.textAddress.delegate = self
        
        self.otherNotes.tag = 4
        self.otherNotes.delegate = self
        
        //
        self.transactionDate.tag = 5
        self.transactionDate.delegate = self
        
        dateSelector = DatePicker()
        dateSelector.setUp(widthSize: Int(self.view.frame.width), heightSize: 200, inputText: self.transactionDate, inputTextErr: UILabel(), date_format: self.pref.getDateFormat())
        self.transactionDate.inputView = dateSelector
        self.transactionDate.inputAccessoryView = dateSelector.toolBar
        
        self.transactionDate.text = UtilsIsm.DateFormat(date: Date(), format: self.pref.getDateFormat())
        
        self.title = NSLocalizedString("PayerFormAdd", comment: "Add Payer")
        
        if mPayer != nil {
            
            self.textDescription.text = mPayer.name
            self.textTelephone.text = mPayer.telephone
            self.textAddress.text = mPayer.address
            self.otherNotes.text = mPayer.other_notes
            
            self.transactionDate.text = UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(mPayer.insert_date)), format: self.pref.getDateFormat())
            
            self.title = NSLocalizedString("PayerFormEdit", comment: "Edit Payer")
        }else {
            
            mPayer = Payer()
        }

        
        self.validator = Validator()
        self.validator.registerField(textDescription, errorLabel: textErrorDescription, rules: [RequiredRule(message: NSLocalizedString("text_required", comment: "Required"))])
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validationSuccessful() {
        let fbPayer:FbPayer = FbPayer(reference: self.firestoreRef);
        
        mPayer.user_gid =  self.pref.getUserIdentifier()
        mPayer.name = textDescription.text!
        mPayer.telephone = textTelephone.text!
        mPayer.address = textAddress.text!
        mPayer.other_notes = otherNotes.text!
        
        if mPayer.gid != "" {
            mPayer.last_update = Int(Date().timeIntervalSince1970)
            mPayer.insert_date = Int(dateSelector.date.timeIntervalSince1970)
            _ = fbPayer.update(mPayer, completion: {(payer) in
                
            }, error_message: {(error) in
                print(error)
            });
        }else{
            
            mPayer.insert_date = Int(dateSelector.date.timeIntervalSince1970)
            _ = fbPayer.write(mPayer, completion: {(payer) in
                
            }, error_message: {(error) in
                print(error)
            })
        }
        
        
        //appDelegate.navigateTo(instance: PayerViewController())
        self.navController?.popViewController(animated: true)
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
            }
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.isHidden = false
        }
    }
    //save
    @objc func save(_ sender: UIBarButtonItem) {
        
        self.validator.validate(self)
    }
    
    //cancel
    @objc func cancel(_ sender: UIBarButtonItem) {
        
        self.navController?.popViewController(animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.navItem?.rightBarButtonItem = saveButton
    }
    


}
