//
//  PayeeFormViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/11/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import SwiftValidator
import ISMLBase
import ISMLDataService


class PayeeFormViewController: BaseScreenViewController, UITextFieldDelegate, ValidationDelegate  {
    
    @IBOutlet weak var transactionDate: UITextField!
    
    @IBOutlet weak var textDescription: UITextField!
    
    @IBOutlet weak var textTelephone: UITextField!
    
    @IBOutlet weak var textAddress: UITextField!
    
    @IBOutlet weak var textErrorDescription: UILabel!
    
    @IBOutlet weak var otherNotes: NiceTextField!
    
    var dateSelector:DatePicker!
    var mPayee:Payee!
    var validator:Validator!
    var navController: UINavigationController?
    var navItem: UINavigationItem?
    
    lazy var cancelButton:UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "back_icon"),
                               landscapeImagePhone: UIImage(named: "back_icon"),
                               style: .plain,
                               target: self,
                               action: #selector(PayeeFormViewController.cancel(_:)))
    }()
    lazy var saveButton:UIBarButtonItem = {
        return UIBarButtonItem(title: NSLocalizedString("text_save", comment: "Save"),
                               style: .done,
                               target: self,
                               action:  #selector(PayeeFormViewController.save(_:)))
    }()
    
    static var viewIdentifier:String = "PayeeFormViewController"
    override func viewDidLoad() {
        super.viewDidLoad()
        mPayee = params["payee"] as? Payee ?? nil
        self.navItem = params["navigationItem"] as? UINavigationItem ?? self.navigationItem
        self.navController = params["navigationController"] as? UINavigationController ?? self.navigationController
        self.navItem?.leftBarButtonItem  = cancelButton
        self.navItem?.rightBarButtonItem = saveButton
        self.title = NSLocalizedString("PayeeFromAdd", comment: "Add Payee")
    
        let imageView = UIImageView()
        let image = UIImage(named: "date_range")
        imageView.image = image
        imageView.alpha = 0.5
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.gray
        imageView.frame = CGRect(x: 5, y: 0, width: 30, height: 30)
        transactionDate.rightView = imageView
        transactionDate.rightViewMode = UITextField.ViewMode.always
        
        self.textErrorDescription.text = ""
        self.textDescription.tag = 1
        self.textDescription.delegate = self
        
        //
        self.textTelephone.tag = 2
        self.textTelephone.delegate = self
        
        //
        self.textAddress.tag = 3
        self.textAddress.delegate = self
        
        self.otherNotes.tag=4
        self.otherNotes.delegate = self
        
        //
        self.transactionDate.tag = 4
        self.transactionDate.delegate = self
        
        dateSelector = DatePicker()
        dateSelector.setUp(widthSize: Int(self.view.frame.width), heightSize: 200, inputText: self.transactionDate, inputTextErr: UILabel(), date_format: self.pref.getDateFormat())
        self.transactionDate.inputView = dateSelector
        self.transactionDate.inputAccessoryView = dateSelector.toolBar
        
        self.transactionDate.text = UtilsIsm.DateFormat(date: Date(), format: self.pref.getDateFormat())
        
        if mPayee != nil {
        
            self.textDescription.text = mPayee.name
            self.textTelephone.text = mPayee.telephone
            self.textAddress.text = mPayee.address
            self.otherNotes.text = mPayee.other_notes
            self.transactionDate.text = UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(mPayee.insert_date)), format: self.pref.getDateFormat())
            
            self.title = NSLocalizedString("PayeeFromEdit", comment: "Edit Payee")
        }else {
        
            mPayee = Payee()
        }
        
        self.validator = Validator()
        self.validator.registerField(textDescription, errorLabel: textErrorDescription, rules: [RequiredRule(message: NSLocalizedString("text_required", comment: "Required"))])
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func validationSuccessful() {
        
        let fbPayee:FbPayee = FbPayee()
        
        mPayee.user_gid =  self.pref.getUserIdentifier()
        mPayee.name = textDescription.text!
        mPayee.telephone = textTelephone.text!
        mPayee.other_notes = otherNotes.text!
        mPayee.address = textAddress.text!
        
        
        
        if mPayee.gid != "" {
            
            mPayee.last_update = Int(Date().timeIntervalSince1970)
            mPayee.insert_date = Int(dateSelector.date.timeIntervalSince1970)
            _ = fbPayee.update(mPayee, completion: {(payee) in
                
            }, error_message: {(error) in
                print(error)
            });
        } else {
            
            mPayee.insert_date = Int(dateSelector.date.timeIntervalSince1970)
            _ = fbPayee.write(mPayee, completion: {(payee) in
                
            }, error_message: {(error) in
                
            });
        }
        
        _ = self.navController?.popViewController(animated: true)
        //appDelegate.navigateTo(instance: PayeeViewController())
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
        //appDelegate.navigateTo(instance: PayeeViewController())
        _ = self.navController?.popViewController(animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navItem?.rightBarButtonItem = saveButton
    }

    
    

}
