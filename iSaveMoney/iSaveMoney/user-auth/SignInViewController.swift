//
//  SignInViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 1/11/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import SwiftValidator
import Firebase
import GoogleSignIn
import TinyConstraints
import ISMLBase
import ISMLDataService
import FirebaseAuth
import AuthenticationServices
import CryptoKit

@available(iOS 13.0, *)
extension SignInViewController: ASAuthorizationControllerDelegate {

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }
      // Initialize a Firebase credential.
      let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                idToken: idTokenString,
                                                rawNonce: nonce)
      // Sign in with Firebase.
      Auth.auth().signIn(with: credential) { (authResult, error) in
        if (error != nil) {
          // Error. If error.code == .MissingOrInvalidNonce, make sure
          // you're sending the SHA256-hashed nonce as a hex string with
          // your request to Apple.
            print(error!.localizedDescription)
          return
        }
        // User is signed in to Firebase with Apple.
        // ...
      }
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
  }

}

class SignInViewController: BaseViewController, UITextFieldDelegate, ValidationDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    
    var pref:MyPreferences!
    var userInterfaceStyle: UIUserInterfaceStyle!
    fileprivate var currentNonce: String?
    func validationSuccessful() {
        signIn()
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
    

    static var viewIdentifier:String = "SignInViewController"
    
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
    
    @objc func doneButtonAction () {
        
        switch self.currentTag {
        case 2:
            self.textEmail.resignFirstResponder()
            hideKeyboard()
            break
        case 3:
            self.textPassword.resignFirstResponder()
            hideKeyboard()
            break
        default:
            break
        }
    }
    func hideKeyboard() {
        textEmail.endEditing(true)
        textPassword.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.currentTag = textField.tag
    }
    
    lazy var labelEmail: NiceLabel = {
        var label = NiceLabel(title: NSLocalizedString("text_signin_email", comment: "Email"))
        label.setCompressionResistance(.defaultHigh, for: .horizontal)
        return label
    }()
    lazy var labelEmailError: ErrorLabel = {
        var label = ErrorLabel(title: "")
        return label
    }()
    lazy var emailWrapper:UIStackView = {
        var wrapper = UIStackView(arrangedSubviews: [labelEmail, labelEmailError])
        wrapper.axis = .horizontal
        wrapper.distribution = UIStackView.Distribution.fillProportionally
        return wrapper
    }()
    lazy var textEmail: NiceTextField = {
        var text = NiceTextField(placeholder: NSLocalizedString("text_signin_email", comment: "Email"))
        text.autocorrectionType = UITextAutocorrectionType.no
        text.inputAccessoryView = doneToolbar
        text.keyboardType = .emailAddress
        text.delegate = self
        text.tag = 2
        return text
    }()
    
    
    lazy var textPassword: NiceTextField = {
        var text = NiceTextField(placeholder: "")
        text.isSecureTextEntry = true
        text.keyboardType = .default
        text.inputAccessoryView = doneToolbar
        text.delegate = self
        text.tag = 3
        return text
    }()
    lazy var labelPwd: NiceLabel = {
        var label = NiceLabel(title: NSLocalizedString("text_signin_password", comment: "password"))
        label.setCompressionResistance(.defaultHigh, for: .horizontal)
        return label
    }()
    lazy var labelPwdError: ErrorLabel = {
        var label = ErrorLabel(title: "")
        return label
    }()
    lazy var pwdWrapper:UIStackView = {
        var wrapper = UIStackView(arrangedSubviews: [labelPwd, labelPwdError])
        wrapper.axis = .horizontal
        wrapper.distribution = UIStackView.Distribution.fillProportionally
        return wrapper
    }()
    
    lazy var signinButton: NiceButton = {
        var button = NiceButton(title: NSLocalizedString("text_signin_signin", comment: "SignIn"))
        button.backgroundColor = flavor.getAccentColor()
        button.addTarget(self, action: #selector(buttonSignIn), for: .touchUpInside)
        return button
    }()
    
    
    lazy var pwdForgot:TransButton = {
        var button = TransButton(title: NSLocalizedString("text_signin_pwd_forgot", comment: "Password forgot"))
        button.addTarget(self, action: #selector(buttonPasswordForgot), for: .touchUpInside)
        return button
    }()
    
    lazy var signUpBtn:TransButton = {
        var button = TransButton(title: NSLocalizedString("text_signin_create", comment: "create account"))
        button.addTarget(self, action: #selector(buttonSignUp(_:)), for: .touchUpInside)
        return button
    }()
    lazy var signupPwdForgotSection:UIStackView = {
        var wrapper = UIStackView(arrangedSubviews: [pwdForgot, signUpBtn])
        wrapper.axis = .horizontal
        wrapper.distribution = UIStackView.Distribution.fillEqually
        return wrapper
    }()
    
    lazy var googleSignInButton: GIDSignInButton = {
        var button = GIDSignInButton()
        button.layer.cornerRadius = 5
        //button.addTarget(self, action: #selector(buttonSignInGoogle), for: .touchUpInside)
        return button
    }()
    
    lazy var appleSignInButton: ASAuthorizationAppleIDButton = {
        let btnAuthorization:ASAuthorizationAppleIDButton
        if self.traitCollection.userInterfaceStyle == .dark {
            btnAuthorization = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        } else {
            btnAuthorization = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        }
        btnAuthorization.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        btnAuthorization.center = self.view.center
        
        btnAuthorization.addTarget(self, action: #selector(buttonSignInApple), for: .touchUpInside)
        return btnAuthorization
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
        var wrapper = UIStackView(arrangedSubviews: [emailWrapper,
                                                     textEmail,
                                                     pwdWrapper,
                                                     textPassword,
                                                     signinButton,
                                                     signupPwdForgotSection,
                                                     appleSignInButton,
                                                     googleSignInButton,
                                                     privacyAndAgreement])
        wrapper.axis = .vertical
        wrapper.spacing = 12
        wrapper.distribution = UIStackView.Distribution.equalSpacing
        return wrapper
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
    
    var flavor:Flavor!
    var appDelegate:AppDelegate!
    
    var currentTag:Int = -1
    var validator:Validator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        validator = Validator()
        pref = MyPreferences()
        //GIDSignIn.sharedInstance().uiDelegate = self
        
        self.validator.registerField(textEmail, errorLabel: labelEmailError, rules: [RequiredRule(message: NSLocalizedString("text_required", comment: "required")), EmailRule(message: NSLocalizedString("invalid_email", comment: "Invalie"))])
        self.validator.registerField(textPassword, errorLabel: labelPwdError, rules: [RequiredRule(message: NSLocalizedString("text_required", comment: "Required")),
            MinLengthRule(length: 6, message: NSLocalizedString("text_min_required", comment: "Minimum"))])
      
        flavor = Flavor()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        GIDSignIn.sharedInstance().presentingViewController = self
        //GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
        
        self.title = NSLocalizedString("text_signin_title", comment: "Signin")
        
        
        
        self.setupViewConstraints()
       
    }
    
    func setupViewConstraints() {
        self.view.addSubview(contentScroll)
        contentScroll.addSubview(stackFormContent)
    }
    
   
    
    @objc func buttonPasswordForgot(_ sender: UIButton) {
        
        self.navigationController?.pushViewController(PasswordResetViewController(), animated: true)
    
    }
    
    
    @objc func buttonSignUp(_ sender: UIButton) {
        
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    @objc func buttonSignIn(_ sender: UIButton) {
        
        print("Sign-in user btn")
       
        
        validator.validate(self)
        
    }
    

    func signIn() {
    
        print("Sign-in user")
        self.indicatorShow()
        Auth.auth().signIn(withEmail: textEmail.text!, password: textPassword.text!) { (user, error) in
            
            self.indicatorHide()
            if user == nil {
            
                let alertController = UIAlertController(title: "Error...", message: "Unable to sign in. Email or password error", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                    // perhaps use action.title here
                
                })
                
                
                self.present(alertController, animated: true) {}
            
            }
        }
    
    }
    
    @objc func buttonSignInApple() {
        self.startSignInWithAppleFlow()
        /*if let authUI = FUIAuth.defaultAuthUI(){
            authUI.providers = [FUIOAuth.appleAuthProvider()]
            authUI.delegate = self
            let authViewController = authUI.authViewController()
            self.present(authViewController, animated: true)
        }*/
    }
    
    /*func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let user = authDataResult?.user {
            print("Here is user \(user)")
        }
    }*/
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
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
    
    
}
