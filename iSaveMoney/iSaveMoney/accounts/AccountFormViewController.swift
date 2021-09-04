//
//  AccountFormViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/13/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import Firebase
import SwiftValidator
import FirebaseFirestore
import ISMLDataService
import ISMLBase

class AccountFormViewController: BaseFormViewController, DateDelegate, UITextFieldDelegate {
    func dateSelected(tag: Int, cancel: Bool) {
        self.textTransactionDate.resignFirstResponder()
        self.textTransactionDate.text = UtilsIsm.DateFormat(date: self.dateSelector.date, format: self.pref.getDateFormat())
    }
    

    static var viewIdentifier:String = "AccountFormViewController"
    
    @IBOutlet weak var textAddressError: UILabel!
    @IBOutlet weak var textPhoneNumberError: UILabel!
    @IBOutlet weak var textOtherNotes: UITextField!
    @IBOutlet weak var textAddress: UITextField!
    @IBOutlet weak var textPhoneNumber: UITextField!
    @IBOutlet weak var textAccountType: UITextField!
    @IBOutlet weak var textAccountTypeError: UILabel!
    @IBOutlet weak var textAccountDescription: UITextField!
    @IBOutlet weak var textAccountDescriptionError: UILabel!
    @IBOutlet weak var textAccountBalance: UITextField!
    @IBOutlet weak var textAccountBalanceError: UILabel!
    @IBOutlet weak var textTransactionDate: UITextField!
    
    
    lazy var cancelButton:UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "back_icon"),
                               landscapeImagePhone: UIImage(named: "back_icon"),
                               style: .plain,
                               target: self,
                               action: #selector(AccountFormViewController.cancel(_:)))
    }()
    lazy var saveButton:UIBarButtonItem = {
        return UIBarButtonItem(title: NSLocalizedString("text_save", comment: "Save"),
                               style: .done,
                               target: self,
                               action:  #selector(AccountFormViewController.save(_:)))
    }()
    
    
    var typeAccountPicker: SimpleDropDown!
    
    var mAccount:Account!

    var isEditMode = false
    
    var navController:UINavigationController? = nil
    var navItem: UINavigationItem?

    let accountType = [
        NSLocalizedString("Checking", comment: "Checking"),
        NSLocalizedString("Savings", comment: "Savings"),
        NSLocalizedString("Credit", comment: "Credit"),
        NSLocalizedString("Debit", comment: "Debit"),
        NSLocalizedString("Cash", comment: "Cash"),
        NSLocalizedString("Other", comment: "Other")]
    
    var dateSelector:CalendarPicker!
    var currentTag:Int = -1
   
    
    var validationList: [FormEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("AddAccount", comment: "Add Account")
        mAccount = params["account"] as? Account ?? nil
        if mAccount != nil {
            self.title = NSLocalizedString("EditAccount", comment: "Edit Account")
        }
        self.navController = params["navigationController"] as? UINavigationController ?? self.navigationController
       self.navItem = params["navigationItem"] as? UINavigationItem ?? self.navigationItem
        self.navItem?.leftBarButtonItem  = cancelButton
        self.navItem?.rightBarButtonItem = saveButton

        
        let imageView = UIImageView()
        let image = UIImage(named: "date_range")
        imageView.image = image
        imageView.alpha = 0.5
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.gray
        imageView.frame = CGRect(x: 5, y: 0, width: 30, height: 30)
        textTransactionDate.rightView = imageView
        textTransactionDate.rightViewMode = UITextField.ViewMode.always
        
        
        //Set currency
        let currencyView = UILabel()
        currencyView.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 80, height: 30))
        
        let locale = Locale(identifier: self.pref.getCurrency())
        let currencySymbol = locale.currencySymbol
    
        
        currencyView.text = currencySymbol!
        currencyView.textColor = UIColor.gray
        currencyView.numberOfLines = 1;
        currencyView.textAlignment =  NSTextAlignment.left;
        currencyView.sizeToFit()
        self.textAccountBalance.rightView = currencyView
        self.textAccountBalance.rightViewMode = UITextField.ViewMode.always
        
        
        //
        
        let imageViewCategory = UIImageView()
        let imageArrow = UIImage(named: "right_chevron")
        imageViewCategory.image = imageArrow
        imageViewCategory.alpha = 0.5
        imageViewCategory.image = imageViewCategory.image!.withRenderingMode(.alwaysTemplate)
        imageViewCategory.tintColor = UIColor.gray
        imageViewCategory.frame = CGRect(x: 5, y: 0, width: 30, height: 30)
        textAccountType.rightView = imageViewCategory
        textAccountType.rightViewMode = UITextField.ViewMode.always
        
        //
        self.textAccountDescriptionError.text = ""
        self.textAccountDescription.tag = 1
        self.textAccountDescription.delegate = self

        //
        self.textAccountTypeError.text = ""
        self.textAccountType.tag = 2
        self.textAccountType.delegate = self
        
        //
        self.textAccountBalanceError.text = ""
        self.textAccountBalance.tag = 3
        self.textAccountBalance.delegate = self
        
        self.textPhoneNumberError.text = ""
        self.textPhoneNumber.tag = 4
        self.textPhoneNumber.delegate = self
        
        self.textAddressError.text = ""
        self.textAddress.tag = 5
        self.textAddress.delegate = self
        
        self.textOtherNotes.tag = 6
        self.textOtherNotes.delegate = self

        self.textTransactionDate.delegate = self
        self.textTransactionDate.tag = 7
        
        
        dateSelector = CalendarPicker()
        dateSelector.setUp(widthSize: Int(self.view.frame.width), heightSize: 220, selectedDate: Date(), displayToday: true, dformat: pref.getDateFormat())
        dateSelector.delegate = self
        self.textTransactionDate.inputView = dateSelector
        self.textTransactionDate.inputAccessoryView = dateSelector.toolBar
        self.textTransactionDate.delegate = self
        self.textTransactionDate.text = UtilsIsm.DateFormat(date: Date(), format: self.pref.getDateFormat())
        
        
        typeAccountPicker = SimpleDropDown()
        
        self.typeAccountPicker.setUp(widthSize: Int(self.view.frame.width), heightSize: 200, items: accountType, inputText: self.textAccountType, inputTextErr: self.textAccountTypeError)
        
        self.typeAccountPicker.mSelectedItem = 0
        self.textAccountType.inputView = self.typeAccountPicker
        self.textAccountType.inputAccessoryView = self.typeAccountPicker.toolBar
        
        
        if mAccount != nil {
           
            self.textAccountDescription.text = mAccount.name
            self.textAccountBalance.text = "\(mAccount.balance!)"
            self.textAccountType.text = self.accountType[mAccount.type]
            self.textPhoneNumber.text = mAccount.telephone
            self.textOtherNotes.text = mAccount.other_notes
            self.textAddress.text =  mAccount.address
            self.textTransactionDate.text = UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(mAccount.insert_date)), format: self.pref.getDateFormat())
            
            self.typeAccountPicker.mSelectedItem = mAccount.type
            self.typeAccountPicker.selectThis(row: mAccount.type)
            
            self.title = NSLocalizedString("AccountFromEdit", comment: "Edit Account")
            isEditMode = true
        }else {
            
            mAccount = Account()
        }

        self.addDoneButtonOnKeyboard()

        //validator.registerField(textAccountType, errorLabel: textAccountTypeError, rules: [RequiredRule()])
        //validator.registerField(textAccountDescription, errorLabel: textAccountDescriptionError, rules: [RequiredRule()])
        
        // Do any additional setup after loading the view.
        validationList.append(FormEntry(edit: textAccountType, err: textAccountTypeError))
        validationList.append(FormEntry(edit: textAccountDescription, err: textAccountDescriptionError))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //Save 
    @objc func save(_ sender: UIBarButtonItem) {
        
//        var errorCount = 0
//
//        errorCount += validateDescription()
//        errorCount += validateAccountType()
//
//        if errorCount > 0 {
//            return
//        }
//
        //validator.validate(self)
        let errorCount = runValidation()
        if errorCount > 0 {
            return
        }
        
        saveAccount()
        
    }
    
    func runValidation() -> Int{
        var errorCount = 0;
        for entry in validationList {
            if entry.editText.text == "" {
                errorCount += 1
                entry.errorLabel.text = NSLocalizedString("text_required", comment: "Required")
                entry.editText.layer.borderColor = UIColor(named: "errorBorderColor")?.cgColor
            } else {
                entry.errorLabel.text = ""
                entry.editText.layer.borderColor = UIColor(named: "textInputBorderColor")?.cgColor
               
            }
        }
        
        return errorCount
    }
    
//    func validationSuccessful() {
//        // submit the form
//    }
//
//    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
//      // turn the fields to red
//      for (field, error) in errors {
//        if let field = field as? UITextField {
//          field.layer.borderColor = UIColor.red.cgColor
//          field.layer.borderWidth = 1.0
//        }
//        error.errorLabel?.text = NSLocalizedString("text_required", comment: "Required")//error.errorMessage // works if you added labels
//        error.errorLabel?.isHidden = false
//      }
//    }
    
    func saveAccount(){
        let fbAccount:FbAccount = FbAccount(reference: self.firestoreRef)
        
        
        mAccount.user_gid =  self.pref.getUserIdentifier()
        mAccount.name = textAccountDescription.text!
        mAccount.type = typeAccountPicker.getId()
        mAccount.telephone = textPhoneNumber.text
        mAccount.address = textAddress.text
        mAccount.other_notes = textOtherNotes.text
        if textAccountBalance.text! == "" {
            
            textAccountBalance.text = NSLocalizedString("ZeroDot", comment: "0.0")
        }
        mAccount.balance =  UtilsIsm.readNumberInput(value:textAccountBalance.text!)
        
        
        
        if mAccount.gid != "" {
            
            mAccount.last_update = Int(Date().timeIntervalSince1970)
            mAccount.insert_date = Int(dateSelector.date.timeIntervalSince1970)
        
            _ = fbAccount.update(mAccount, completion: {(account) in
                self.backToPreview()
            }, error_message: {(error) in
                print(error)
                self.backToPreview()
            })
            
        } else {
            
            mAccount.insert_date = Int(dateSelector.date.timeIntervalSince1970)
           
            _ = fbAccount.write(mAccount, completion: {(account) in
                self.backToPreview()
            }, error_message: {(error) in
                print(error)
                self.backToPreview()
            })
            
        }
    }
    
    
    
    
    //Cancel
    @objc func cancel(_ sender: UIBarButtonItem) {
        
        
        backToPreview()
        
    }
    
    
    func backToPreview() {
        
//        if isEditMode {
//            let args:NSDictionary = ["account": mAccount]
//            let accountDetails = AccountDetailsViewController(nibName: "AccountDetailsViewController", bundle: nil)
//            accountDetails.params = args
//            self.navigationController?.pushViewController(accountDetails, animated: true)
//
//        } else {
//            self.navigationController?.popViewController(animated: true)
//        }
        self.navController?.popViewController(animated: true)
    }

    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("text_done", comment: "done"), style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))
        
        doneToolbar.barStyle = UIBarStyle.default
        doneToolbar.isTranslucent = true
        doneToolbar.tintColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        doneToolbar.sizeToFit()
        doneToolbar.setItems([flexSpace, done], animated: true)
        doneToolbar.sizeToFit()
        doneToolbar.isUserInteractionEnabled = true
        
        self.textAccountBalance.inputAccessoryView = doneToolbar
        self.textAccountDescription.inputAccessoryView = doneToolbar
        
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        _ = self.runValidation()
        self.currentTag = textField.tag
    }

    @objc func doneButtonAction () {
        
        switch self.currentTag {
        case 1:
            self.textAccountDescription.resignFirstResponder()
            break
        case 3:
            self.textAccountBalance.resignFirstResponder()
            break
        default:
            break
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navItem?.rightBarButtonItem = saveButton
    }
    
    
}
