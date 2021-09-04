//
//  SignUpViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 1/11/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import SwiftValidator
import Firebase
import TinyConstraints
import ISMLBase
import ISMLDataService
import FirebaseAuth


class SignUpViewController: BaseViewController,
                            UITextFieldDelegate,
                            ValidationDelegate {


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
        let label = NiceLabel(title: NSLocalizedString("text_signup_fullname", comment: "Name"))
        return label
    }()
    lazy var textName: NiceTextField = {
        let textfield = NiceTextField(placeholder: NSLocalizedString("text_signup_fullname", comment: "Full Name"),
                                      insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 30))
        textfield.rightViewMode = UITextField.ViewMode.always
        textfield.autocorrectionType = UITextAutocorrectionType.no
        textfield.tag = 1
        textfield.delegate = self
        textfield.inputAccessoryView = doneToolbar
        return textfield
    }()
    
    lazy var labelEmail:NiceLabel = {
        let label = NiceLabel(title: NSLocalizedString("text_signup_email", comment: "Email"))
        label.appendValue(value: "*")
        label.setCompressionResistance(.defaultHigh, for: .horizontal)
        return label
    }()
    lazy var labelEmailError: ErrorLabel = {
        let label = ErrorLabel(title: NSLocalizedString("NEVCRequired", comment: "Required"),
                               insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        label.isHidden = true
        return label
    }()
    lazy var labelEmailErrorStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelEmail, labelEmailError])
        stackView.axis = .horizontal
        stackView.distribution = UIStackView.Distribution.fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 6
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return stackView
    }()
    lazy var textEmail: NiceTextField = {
        let textfield = NiceTextField(placeholder: NSLocalizedString("text_signup_email", comment: "Select"),
                                      insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 30))
        textfield.rightViewMode = UITextField.ViewMode.always
        textfield.autocorrectionType = UITextAutocorrectionType.no
        textfield.tag = 2
        textfield.delegate = self
        textfield.keyboardType = .emailAddress
        textfield.inputAccessoryView = doneToolbar
        return textfield
    }()
    lazy var labelPassword:NiceLabel = {
        let label = NiceLabel(title: NSLocalizedString("text_signup_password", comment: "Password"))
        label.appendValue(value: "*")
        label.setCompressionResistance(.defaultHigh, for: .horizontal)
        return label
    }()
    lazy var labelPasswordError: ErrorLabel = {
        let label = ErrorLabel(title: NSLocalizedString("NEVCRequired", comment: "Required"),
                               insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        label.isHidden = true
        return label
    }()
    lazy var labelPasswordErrorStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelPassword, labelPasswordError])
        stackView.axis = .horizontal
        stackView.distribution = UIStackView.Distribution.fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 6
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return stackView
    }()
    lazy var textPassword: NiceTextField = {
        let textfield = NiceTextField(insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 30))
        //placeholder: NSLocalizedString("text_signup_password", comment: "Select"),
        textfield.rightViewMode = UITextField.ViewMode.always
        textfield.autocorrectionType = UITextAutocorrectionType.no
        textfield.isSecureTextEntry = true
        textfield.tag = 3
        textfield.delegate = self
        textfield.inputAccessoryView = doneToolbar
        return textfield
    }()
    lazy var signupButton: NiceButton = {
        var button = NiceButton(title: NSLocalizedString("text_signup_create", comment: "Create account"))
        button.addTarget(self, action: #selector(buttonSignUp), for: .touchUpInside)
        return button
    }()
    
    lazy var signInButton: TransButton = {
        var button = TransButton(title: NSLocalizedString("text_signup_signin", comment: "Create account"))
        button.addTarget(self, action: #selector(buttonSignIn), for: .touchUpInside)
        return button
    }()
    
    lazy var agreeButton: TransButton = {
        var button = TransButton(title: NSLocalizedString("userGree", comment: "Create account"))
        button.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 11)
        
        button.setTitleColor(UIColor(named: "normalTextColor"), for: .normal)
        button.addTarget(self, action: #selector(userAgree), for: .touchUpInside)
        return button
    }()
    
    lazy var privacyPolicy: TransButton = {
        var button = TransButton(title: NSLocalizedString("privacyPolicy", comment: "Privacy Policy"))
        button.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 11)
        button.setTitleColor(UIColor(named: "normalTextColor"), for: .normal)
        button.addTarget(self, action: #selector(policyTerm), for: .touchUpInside)
        return button
    }()
    
    lazy var privacyAndAgreement: UIView = {
        var vw = UIView()
        vw.height(40)
        let and:UIView = {
            let sep = UIView()
            sep.backgroundColor = UIColor(named: "normalTextColor")
            sep.height(4)
            sep.width(4)
            return sep
        }()
        
        vw.addSubview(and)
        and.centerXToSuperview()
        and.centerYToSuperview()
        
        vw.addSubview(agreeButton)
        agreeButton.centerYToSuperview()
        agreeButton.rightToLeft(of: and, offset: -10)
        
        vw.addSubview(privacyPolicy)
        privacyPolicy.centerYToSuperview()
        privacyPolicy.leftToRight(of: and, offset: 10)
        return vw
    }()
    
    lazy var stackContent:UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [labelName,
                                                       textName,
                                                       labelEmailErrorStackView,
                                                       textEmail,
                                                       labelPasswordErrorStackView,
                                                       textPassword,
                                                       signupButton,
                                                       signInButton,
                                                       privacyAndAgreement])
        stackView.axis = .vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 6
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
    
    static var viewIdentifier:String = "SignUpViewController"
    
    var flavor:Flavor!
    var appDelegate:AppDelegate!
    var validtor:Validator!
    var currentTag:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpActivity()
        self.layoutComponent()
        self.setupValidator()
        //self.setupInitialState()
    }
    func setUpActivity(){
        flavor = Flavor()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
//        self.navigationController!.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.tintColor = flavor.getNavigationBarColor()
//        navigationController?.navigationBar.barTintColor = flavor.getPrimaryColor()
        //navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:flavor.getNavigationBarColor(), NSAttributedString.Key.font: UIFont(name: "Lato-Bold", size: 18)!]
        self.title = NSLocalizedString("text_signup_title", comment: "Signup")
    }
    
    func layoutComponent() {
        
        self.view.addSubview(contentScroll)
        contentScroll.addSubview(stackFormContent)
        
    }
    
    func setupValidator() {
        
        self.validtor = Validator()
        self.validtor.registerField(textEmail, errorLabel: labelEmailError, rules: [RequiredRule(message: NSLocalizedString("text_required", comment: "Required")),
            EmailRule(message: NSLocalizedString("invalid_email", comment: "Invalid emai"))])
        self.validtor.registerField(textPassword, errorLabel: labelPasswordError, rules: [RequiredRule(message: NSLocalizedString("text_required", comment: "Required")),
            MinLengthRule(length: 6, message: NSLocalizedString("text_min_required", comment: "Minimum"))])
    }
    
    
    @objc func buttonSignIn(_ sender: UIButton) {
        
        self.navigationController?.pushViewController(SignInViewController(), animated: true)
        
    }

    @objc func buttonSignUp(_ sender: UIButton) {
       self.validtor.validate(self)
    }
    
    func validationSuccessful() {
        authenticateUser()
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
    
    
    /** user authentication  */
    func authenticateUser() {
        
        if Auth.auth().currentUser != nil {
            // Link user account on signup.
            
            indicatorShow()
            
            print("LoginTrance:: link user account \(textEmail.text!)...")
            let credential = EmailAuthProvider.credential(withEmail: textEmail.text!, password: textPassword.text!)
            
            let user = Auth.auth().currentUser
            
            user?.link(with: credential) { (user, error) in
                
                self.indicatorHide()
       
            }
            
        } else {
            // Sign up user.
            
            self.indicatorShow()
            print("LoginTrance:: Create User \(textEmail.text!)...")
            Auth.auth().createUser(withEmail: textEmail.text!, password: textPassword.text!) { (user, error) in
                
                self.indicatorHide()
                            }
        }
 
    }
    
    
    @objc func hideKeyboard(sender: AnyObject) {
        textEmail.endEditing(true)
        textName.endEditing(true)
        textPassword.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.currentTag = textField.tag
    }
    
    @objc func userAgree() {
        let vc = UserAgreeViewController(nibName: "UserAgreeViewController", bundle: nil)
        let viewControllerNavController = UINavigationController(rootViewController: vc)
        self.present(viewControllerNavController, animated: true)
    }
    
    @objc func policyTerm() {
        let vc = PrivacyViewController(nibName: "PrivacyViewController", bundle: nil)
        let viewControllerNavController = UINavigationController(rootViewController: vc)
        self.present(viewControllerNavController, animated: true)
    }
    
    
    @objc func doneButtonAction () {
        
        switch self.currentTag {
        case 1:
            self.textName.resignFirstResponder()
            break
        case 2:
            self.textEmail.resignFirstResponder()
            break
        case 3:
            self.textPassword.resignFirstResponder()
            break
        default:
            break
        }
    }
    
}
