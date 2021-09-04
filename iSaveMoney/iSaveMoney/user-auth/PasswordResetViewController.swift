//
//  PasswordResetViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 1/12/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import Firebase
import SwiftValidator
import TinyConstraints
import ISMLBase
import FirebaseAuth

class PasswordResetViewController: BaseViewController, UITextFieldDelegate, ValidationDelegate {
    
    
    static var viewIdentifier:String = "PasswordResetViewController"
    
    lazy var doneToolbar: UIToolbar = {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("text_done", comment: "done"), style: UIBarButtonItem.Style.done, target: self, action: #selector(SignInViewController.doneButtonAction))
        
        doneToolbar.barStyle = UIBarStyle.default
        doneToolbar.isTranslucent = true
        doneToolbar.tintColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        doneToolbar.sizeToFit()
        doneToolbar.setItems([flexSpace, done], animated: true)
        doneToolbar.sizeToFit()
        doneToolbar.isUserInteractionEnabled = true
        
        return doneToolbar
        
    }()
    
    lazy var labelName:NiceLabel = {
        let label = NiceLabel(title: NSLocalizedString("text_password_desc", comment: "Password"))
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 3
        return label
    }()
    lazy var textEmail: NiceTextField = {
        let textfield = NiceTextField(placeholder: NSLocalizedString("text_password_hit", comment: "Hint"),
                                      insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 30))
        textfield.rightViewMode = UITextField.ViewMode.always
        textfield.autocorrectionType = UITextAutocorrectionType.no
        textfield.tag = 2
        textfield.delegate = self
        textfield.inputAccessoryView = doneToolbar
        return textfield
    }()
    lazy var labelEmailError: ErrorLabel = {
        var label = ErrorLabel(title: "")
        label.isHidden = true
        return label
    }()
   
    lazy var passwordForgotButton: NiceButton = {
        var button = NiceButton(title: NSLocalizedString("password_reset_request", comment: "Send"))
        button.backgroundColor = flavor.getAccentColor()
        
        button.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        return button
    }()
    
    //Back Button
    lazy var signInButton: TransButton = {
        var button = TransButton(title: NSLocalizedString("back", comment: "back"))
        button.addTarget(self, action: #selector(buttonSignIn), for: .touchUpInside)
        return button
    }()
    
    lazy var stackContent:UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [labelName,
                                                       textEmail,
                                                       labelEmailError,
                                                       passwordForgotButton,
                                                       signInButton])
        stackView.axis = .vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 12
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return stackView
    }()
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 400)
    lazy var stackFormContent:UIView = {
        let view = UIView()
        view.frame.size = contentViewSize
        view.addSubview(stackContent)
        stackContent.edgesToSuperview(excluding: .bottom, insets: .left(10) + .top(25) + .right(10))
        return view
    }()
    
    lazy var contentScroll: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.contentSize = contentViewSize
        view.frame = self.view.bounds
        view.autoresizingMask = .flexibleHeight
        view.bounces = true
        view.showsHorizontalScrollIndicator = true
        return view
    }()
    
    lazy var cancelButton:UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "back_icon"),
                               landscapeImagePhone: UIImage(named: "back_icon"),
                               style: .plain,
                               target: self,
                               action: #selector(PasswordResetViewController.cancel(_:)))
    }()
    
    var flavor:Flavor!
    var appDelegate:AppDelegate!
    var validator:Validator!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textEmail.delegate = self
        flavor = Flavor()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        // Do any additional setup after loading the view.
        
//        self.navigationController!.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.tintColor = flavor.getNavigationBarColor()
//        navigationController?.navigationBar.barTintColor = flavor.getPrimaryColor()
        self.navigationItem.leftBarButtonItem  = cancelButton
        self.title = NSLocalizedString("text_password_title", comment: "Password")
        
        self.view.addSubview(contentScroll)
        contentScroll.addSubview(stackFormContent)
        
        self.validator = Validator()
        self.validator.registerField(textEmail, errorLabel: labelEmailError, rules: [RequiredRule(message: NSLocalizedString("text_required", comment: "required")), EmailRule(message: NSLocalizedString("invalid_email", comment: "Invalie"))])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func cancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func buttonSignIn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func resetPassword(_ sender: UIButton) {
        self.validator.validate(self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        return true
    }
    
    
    func validationSuccessful() {
        sendEmail()
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
    
    func sendEmail()  {
        
        self.indicatorShow()
        Auth.auth().sendPasswordReset(withEmail: textEmail.text!) { (error) in
            
            self.indicatorHide()
            let alert = UIAlertController(title: "Password reset", message: "Email sent. please verify your inbox", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    @objc func doneButtonAction () {
        
        self.textEmail.resignFirstResponder()
    }
    
   
   
}
