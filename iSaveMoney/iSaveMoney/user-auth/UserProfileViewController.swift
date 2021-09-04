//
//  UserProfileViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 5/18/21.
//  Copyright © 2021 Armel Koudoum. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import UIKit
import Firebase
import FirebaseAuth
import ISMLBase
import ISMLDataService
import SwiftValidator

class UserProfileViewController: BaseScreenViewController,UITextFieldDelegate,ValidationDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    
    
    
    var countries:[Any] = []
    
    static var viewIdentifier:String = "MyProfileViewController"
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var memberSinceLabel: UILabel!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var closeAccountButton: UIButton!
    
    var dateformat: Utils!
    var user:PUser? = nil
    var validator:Validator!
    var userCollection:UserCollection!
    
    lazy var cancelButton:UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "back_icon"),
                               landscapeImagePhone: UIImage(named: "back_icon"),
                               style: .plain,
                               target: self,
                               action: #selector(cancel(_:)))
    }()
    lazy var saveButton:UIBarButtonItem = {
        return UIBarButtonItem(title: NSLocalizedString("text_save", comment: "Save"),
                               style: .done,
                               target: self,
                               action:  #selector(save(_:)))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userCollection = UserCollection(reference: Firestore.firestore())
        self.navigationItem.leftBarButtonItem  = cancelButton
        self.navigationItem.rightBarButtonItem = saveButton
        self.title = NSLocalizedString("my_profile", comment: "My profile")
        
        let keyImage = UIImage(named: "key-icon.png")
        let tintedImage = keyImage?.withRenderingMode(.alwaysTemplate)
        self.changePasswordButton.setImage(tintedImage, for: .normal)
        self.changePasswordButton.tintColor = UIColor(red: 0.13, green: 0.59, blue: 0.95, alpha: 1.00)
        self.changePasswordButton.setTitle(NSLocalizedString("change_password", comment: ""), for: .normal)
        
        let closeIcon = UIImage(named: "close-icon.png")
        let closeTintedImage = closeIcon?.withRenderingMode(.alwaysTemplate)
        self.closeAccountButton.setImage(closeTintedImage, for: .normal)
        self.closeAccountButton.tintColor = UIColor(red: 0.81, green: 0.11, blue: 0.12, alpha: 1.00)
        self.closeAccountButton.setTitle(NSLocalizedString("delete_account", comment: ""), for: .normal)
        
        let countryPicker = UIPickerView()
        countryPicker.dataSource = self
        countryPicker.delegate = self
        self.countryTextField.inputView = countryPicker
        
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.phoneTextField.delegate = self
        self.countryTextField.delegate = self
        self.emailAddressTextField.delegate = self
        
        self.validator = Validator()
        
        self.dateformat = Utils()
        loadProfile()
        self.loadCountryCodes(countryPicker)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.countryTextField{
            self.setupPickerViewToolBar()
        }
    }
    
    private func setupPickerViewToolBar(){
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: NSLocalizedString("text_done", comment: "Done"), style: .plain, target: self, action: #selector(uiPickerViewOnSelection))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("button_cancel", comment: "Cancel"), style: .plain, target: self, action: #selector(uiPickerViewOnCancel))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.countryTextField.inputAccessoryView = toolBar
    }
    
    @objc func uiPickerViewOnSelection() {
        self.user?.country = self.countryTextField.text
        self.countryTextField.resignFirstResponder()
    }
    @objc func uiPickerViewOnCancel() {
        self.countryTextField.text = self.user?.country
        self.countryTextField.resignFirstResponder()
    }
    
    private func loadCountryCodes(_ pickerView:UIPickerView){
        DispatchQueue.global(qos: .background).async {
            
            var countries: [Any] = []
            
            for code in NSLocale.isoCountryCodes {
                let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
                let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: (code)"
                countries.append(["code": id.replacingOccurrences(of: "_", with: ""), "name": name])
            }
            
            DispatchQueue.main.async {
                self.countries = countries
                pickerView.reloadAllComponents()
            }
        }
    }
    
    private func setUpData(user:PUser?){
        
        self.user = user
        self.firstNameTextField.text = user?.first_name
        self.lastNameTextField.text = user?.last_name
        self.emailAddressTextField.text = user?.email
        self.countryTextField.text = user?.country
        self.phoneTextField.text = user?.phone_number
        let cuser = Auth.auth().currentUser
        if let cuser = cuser {
            self.memberSinceLabel.text = String(format: NSLocalizedString("member_since", comment: ""), arguments: [UtilsIsm.DateFormat(date: cuser.metadata.creationDate ?? Date(), format: self.pref.getDateFormat())])
        }
    
        
        
        
    }
    
    private func loadUserData(user_gid:String){
        self.userCollection.getUser(user_gid, onComplete: { user in
            self.setUpData(user: user)
        }, onError: { error in
            
        })
    }
    
    func loadProfile(){
        
        let user = Auth.auth().currentUser
        
        let fbPreferences = FbPreferences(reference: self.firestoreRef)
        
        fbPreferences.get(user_gid: (user?.uid)!, notifier: {preferences in
            if preferences.gid != "" {
                //load the profile
                preferences.saveValuesToPreferences(prefs: preferences.toAnyObject())
                self.loadUserData(user_gid: preferences.gid)
            } else {
                
                try! Auth.auth().signOut()
                self.navigateToLogin()
            }
        }, errorReturn: {error in
            
        })
        
        
        
        
    }
    
    func navigateToLogin()  {
        
        self.navigationController?.pushViewController(SignInViewController(), animated: true)
        
        
    }
    
    @objc func save(_ sender: UIBarButtonItem) {
        if(self.user == nil){
            return
        }
        self.validator.validate(self)
    }
    
    
    //cancel
    @objc func cancel(_ sender: Any) {
        
        //self.navigationController?.popToRootViewController(animated: true)
        appDelegate.navigateTo(instance: ViewController())
    }
    @IBAction func onChangePasswordClicked(_ sender: Any) {
        self.navigationController?.pushViewController(PasswordResetViewController(), animated: true)
    }
    
    @IBAction func onDeleteAccountClicked(_ sender: Any) {
        let alert = UIAlertController(title: NSLocalizedString("confirm_delete_account_title", comment: "Confir, Delete Account"), message:  NSLocalizedString("confirm_delete_message", comment: "Confirm delete message"),         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("button_cancel", comment: "Cancel"), style: UIAlertAction.Style.cancel, handler: { _ in
            
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("button_confirm", comment: "Continue"),
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
                                        let user = Auth.auth().currentUser
                                        user?.delete(completion: {error in
                                            //self.userCollection.delete((self.user?.gid)!)
                                            self.navigateToLogin()
                                        })
        }))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func validationSuccessful() {
        self.user?.first_name = self.firstNameTextField.text
        self.user?.last_name  = self.lastNameTextField.text
        self.user?.email = self.emailAddressTextField.text
        self.user?.phone_number = self.phoneTextField.text
        
        self.userCollection.update(self.user!, onComplete: { user in
            //self.navigationController?.popViewController(animated: true)
        }, onError: {error in
            //Error - SHOW
        })
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let country = self.countries[row] as? [String: Any] {
            return country["name"] as? String
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let country = self.countries[row] as? [String: Any] {
            self.countryTextField.text = country["name"] as? String
        }
    }
    
}
