//
//  AddGroupViewController.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 1/3/21.
//  Copyright © 2021 Armel Koudoum. All rights reserved.
//

import UIKit
import Firebase
import ISMLBase
import SwiftValidator

class AddGroupViewController: UIViewController,ValidationDelegate, UITextFieldDelegate {
   

    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var teamName: NiceTextField!
    @IBOutlet weak var teamMemo: NiceTextField!
    @IBOutlet weak var txtTeamNameError: ErrorLabel!
    
    
    var validator:Validator!
    var appDelegate:AppDelegate!
    var firestoreRef: Firestore!
    var pref: MyPreferences!
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
        self.title = NSLocalizedString("titleAddGroup", comment: "Add Group")
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.firestoreRef = appDelegate.firestoreRef
        pref = MyPreferences()
        imageContainer.isHidden = true
        txtTeamNameError.text = ""
        teamName.tag = 1
        teamName.delegate = self
        self.navigationItem.leftBarButtonItem  = cancelButton
        self.navigationItem.rightBarButtonItem = saveButton
        // Do any additional setup after loading the view.
        
        self.validator = Validator()
        self.validator.registerField(teamName, errorLabel: txtTeamNameError, rules: [
                                        RequiredRule(message: NSLocalizedString("text_required", comment: "Required"))])
    }
    @objc func save(_ sender: AnyObject) {
        
        self.validator.validate(self)

    }

    @objc func cancel(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }

    
    func validationSuccessful() {
        let fbTeam = FbTeamModel(reference: self.firestoreRef)
        let teamModel = TeamModel()
        teamModel.ownerId = self.pref.getUserIdentifier()
        teamModel.memo = self.teamMemo.text
        teamModel.name = self.teamName.text!
        fbTeam.write(teamModel)
        self.navigationController?.popViewController(animated: true)
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if textField.tag == 1 {
            txtTeamNameError.text = ""
            textField.layer.borderColor = UIColor(named: "textInputBorderColor")?.cgColor
        }
        
        return true
    }
    
}
