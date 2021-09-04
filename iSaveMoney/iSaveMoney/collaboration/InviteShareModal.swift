//
//  InviteShareViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 4/14/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import GoogleSignIn
import SwiftValidator
import Firebase
import MessageUI
import FirebaseFirestore
import FirebaseDynamicLinks
import ISMLDataService
import ISMLBase
import TinyConstraints


protocol InviteDelegate: class {
    func completedInvite()
}

class InviteShareModal: BaseViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate, EditorSelectDelegate {
    
    
    var textLabelInvite: NiceLabel!
    var textInputEmail: NiceTextField!
    var teamImage: UIButton!
    var emailInputComposit: InputBackgroundView!
    var buttonShareLink: ButtonWithArrow!
    var stackFirstPath: UIStackView!
    
    var userNotFoundText: HeaderLevelFour!
    var textLabelMessage: NiceLabel!
    var textInputMessage: UITextView!
    var stackViewMessage: UIView!
    
    var labelContentWrapper:UIStackView!
    
    var budget:Budget!
    var budgetName:String!
    
    
    var firestore:Firestore!
    var pref:MyPreferences!
    var isGoogleUser:Bool = false
    
    
    
    var flavor:Flavor!
    var appDelegate:AppDelegate!
    var firestoreRef:Firestore!
    
    weak var delegate:InviteDelegate?

    static var viewIdentifier:String = "InviteShareViewController"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("invite_share_add", comment: "Title")
        
        
        self.pref = MyPreferences()
        
        flavor = Flavor()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.firestore = appDelegate.firestoreRef


        let cancelButton = UIBarButtonItem(image: UIImage(named: "back_icon"), landscapeImagePhone: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(InviteShareModal.cancel(_:)))
        
        self.navigationItem.leftBarButtonItem  = cancelButton

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = true
        setupViews()
    }
    
    func setupViews() {
        
        textLabelInvite = {
            let label = NiceLabel()
            label.text = NSLocalizedString("invite_share_add_user_to_budget", comment: "Comment label").replacingOccurrences(of: "[budgetName]", with: budgetName)
            return label
        }()
        
        textInputEmail = {
            
            let textfield = NiceTextField(placeholder: NSLocalizedString("typeEmail", comment: "Type email"),insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 42)) //"typeEmail"
            textfield.autocorrectionType = UITextAutocorrectionType.no
            textfield.returnKeyType = UIReturnKeyType.done
            textfield.rightViewMode = UITextField.ViewMode.always
            //textfield.placeholder = NSLocalizedString("invite_share_email", comment: "Email")
           //textfield.translatesAutoresizingMaskIntoConstraints = false
            textfield.autocorrectionType = UITextAutocorrectionType.no
            textfield.keyboardType = .emailAddress
            textfield.delegate = self
            return textfield
        }()
        
        teamImage = {
            let iw = UIButton()
            iw.setImage(UIImage(named: "ic_teamwork")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
            iw.tintColor = UIColor(named: "tintIconsColor")
            iw.width(24)
            iw.height(24)
            iw.addTarget(self, action: #selector(userCircleTapped), for: .touchUpInside)
            return iw
        }()
        
        emailInputComposit = {
            let icomp = InputBackgroundView()
            icomp.addSubview(textInputEmail)
            textInputEmail.topToSuperview()
            textInputEmail.leftToSuperview()
            textInputEmail.bottomToSuperview()
            icomp.addSubview(teamImage)
            teamImage.rightToSuperview(offset: -10)
            teamImage.centerYToSuperview()
            teamImage.leftToRight(of: textInputEmail)
            return icomp
        }()
        buttonShareLink = {
            
            let button = ButtonWithArrow()
            button.setTitle(NSLocalizedString("invite_share_button_share", comment: "Add Members"), for: UIControl.State.normal)
            button.addTarget(self, action: #selector(buttonSaveAction), for: .touchUpInside)
            return button
        }()
        
    
        
        
        
        userNotFoundText = {
            let header = HeaderLevelFour(title: NSLocalizedString("invite_not_found", comment: "Not found"), textSize: 14)
            header.numberOfLines = 2
            return header
        }()
        textLabelMessage = {
            let label = NiceLabel()
            label.text = NSLocalizedString("invite_share_add_message", comment: "Add message")
            return label
        }()
        textInputMessage = {
            
            let textView = UITextView()
            textView.frame = CGRect(x: 0, y: 0, width: 200, height: 150)
            textView.font = .systemFont(ofSize: 13)
            textView.textColor = .black
            textView.layer.borderWidth = 0.5
            textView.layer.borderColor = UIColor(named: "textInputBgColor")?.cgColor
            textView.backgroundColor = UIColor(named: "textInputBgColor")
            textView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            textView.layer.cornerRadius = 5
            textView.isScrollEnabled = true
 
            textView.isEditable = true
            textView.text = NSLocalizedString("invite_share_message", comment: "Add message").replacingOccurrences(of: "[budget]", with: budgetName)
            //textView.translatesAutoresizingMaskIntoConstraints = false
            textView.textColor = UIColor(named: "textInputTextColor")
            return textView
        }()
        
        stackViewMessage = {
            let view = UIView()//arrangedSubviews: [textLabelMessage,textInputMessage]
            view.backgroundColor = .clear
            view.height(200)
            view.addSubview(userNotFoundText)
            userNotFoundText.edgesToSuperview(excluding: .bottom, insets: .left(10) + .top(20) + .right(10))
            
            view.addSubview(textLabelMessage)
            textLabelMessage.leftToSuperview(offset: 10)
            textLabelMessage.rightToSuperview(offset: -10)
            textLabelMessage.topToBottom(of: userNotFoundText)
            
            view.addSubview(textInputMessage)
            textInputMessage.leftToSuperview(offset: 10)
            textInputMessage.rightToSuperview(offset: -10)
            textInputMessage.topToBottom(of: textLabelMessage)
            return view
        }()
        
       
        
        labelContentWrapper = {
            let stackView = UIStackView(arrangedSubviews: [textLabelInvite,emailInputComposit, stackViewMessage,buttonShareLink])
            stackView.axis = .vertical
            stackView.distribution = .equalSpacing
            stackView.alignment = .fill
            stackView.spacing = 22
            stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        
        self.view.addSubview(labelContentWrapper)
        
        labelContentWrapper.edgesToSuperview(excluding: .bottom, insets: .top(10) + .left(10) + .right(10), usingSafeArea: true)
        
        stackViewMessage.isHidden = true
        teamImage.isHidden = true
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let editorList = appDelegate?.getUserCircle() ?? []
        if editorList.count > 0 {
            teamImage.isHidden = false
        }
        
        self.textInputEmail.delegate = self
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        stackViewMessage.isHidden = true
        self.buttonShareLink.setTitle(NSLocalizedString("invite_share_button_share", comment: "invite"), for: .normal)
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
   
    func hideKeyboard(sender: AnyObject) {
        textInputEmail.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func cancel(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
   
    
    func inviteDialog(user:PUser){
    
        let alertController = UIAlertController(title: NSLocalizedString("InviteUserFound", comment: "User found"), message: "\(user.first_name!)\n\(user.email!)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("InviteUserFoundButton", comment: "Invite"), style: .default) { action in
            // perhaps use action.title here
            
            self.inviteUser(user: user)
            
        })
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("InviteUserFoundCancel", comment: "Cancel"), style: .default) { action in
            // perhaps use action.title here
        })
        
        self.present(alertController, animated: true) {}
    }
    
   
    
    func inviteUser(user: PUser) {
    

        let fbBudget = FbBudget(reference: self.firestore)
        fbBudget.addEditorToBudget(budget_gid: self.pref.getSelectedMonthlyBudget(), user_gid: user.gid!, returnSaved: {saved in
            
        })
       
    
        
        self.messageUser(user: user)
        
    }
    
    internal func inviteFinished(withInvitations invitationIds: [String], error: Error?) {
        if error != nil {
            
            let alertController = UIAlertController(title: NSLocalizedString("InviteFailed", comment: "Invite failed!"), message: NSLocalizedString("InviteFailedMessage", comment: "unable to complete the invite process.."), preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("InviteFailedButton", comment: "OK"), style: .default) { action in
                // perhaps use action.title here
                
            })
        } else {
            let alertController = UIAlertController(title: NSLocalizedString("InviteSent", comment: "Invite sent!"), message: NSLocalizedString("InviteSentMessage", comment: "The user has been added to your budget."), preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("InviteSentButton", comment: "OK"), style: .default) { action in
                // perhaps use action.title here
                
            })
        }
    }
    

    func messageUser(user:PUser){
    
        
        
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textInputEmail.resignFirstResponder()
        
        
        return true
    }
    ////
    
    @objc func buttonSaveAction() {
        
        //if Validator.isEmail().apply(textInputEmail.text) {
        if(1==1) {
            let fbUser = FbUser(reference: self.firestore)
            
            fbUser.getByEmail(textInputEmail.text!.lowercased(),
            listner: { (user, found)  in
                
              
                if found {
                    
                
                    let fbBudget = FbBudget(reference: self.firestore)
                    
                    fbBudget.lookUpBudgetForUser(bugdet_gid: self.budget.gid, user_gid: user.gid, onBudgetRead: { userOwnBudgets in
                        
                        if userOwnBudgets.count > 0 {
                            self.stackViewMessage.isHidden = true
                            self.displayUserSharedBudget()
                        }else {
                            
                            fbBudget.addEditorToBudget(budget_gid: self.budget.gid, user_gid: user.gid, returnSaved: {saved in
                                fbBudget.markAsUnread(userBudgetGid: saved.gid)
                                self.stackViewMessage.isHidden = true
                                self.displayUserSharedBudget()
                                
                                
                            })
                        }
                    })
                    
                    
                } else {
                    
                     self.stackViewMessage.isHidden = false
                     self.generateContentLink()
                }
            },
            errorReturn: {(error) in
                self.stackViewMessage.isHidden = false
                self.generateContentLink()
            })
            
        }else {
            
            let alert = UIAlertController(title: NSLocalizedString("text_error", comment: "error title"), message: NSLocalizedString("invalid_email", comment: "invalid email"), preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
        
        //self.generateContentLink()
    }
    
    
    func displayUserSharedBudget() {
        let alert = UIAlertController(title: NSLocalizedString("budget_shared_tile", comment: "Shared"), message: NSLocalizedString("budget_shared", comment: "Budget shared") + self.textInputEmail.text!, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("budget_shared_yes", comment: "Yes"), style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
    
    func generateContentLink() {
        
        if self.stackViewMessage.isHidden {
            self.stackViewMessage.isHidden = false
            self.buttonShareLink.setTitle(NSLocalizedString("invite_share_link", comment: "Share invite link"), for: .normal)
        }
        
        let baseURL = URL(string: "https://www.digitleaf.com/?gid=" + budget.gid!)!
        let domain = "https://isavemoney.page.link"
        let linkBuilder = DynamicLinkComponents(link: baseURL, domainURIPrefix: domain)
        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.ulmatcorpit.iSaveMoneyGo")
        linkBuilder?.iOSParameters?.appStoreID = "1227088361"
        linkBuilder?.androidParameters =
            DynamicLinkAndroidParameters(packageName: "com.colpit.diamondcoming.isavemoneygo")
        
        
        //"?gid=" + budget.gid!
        
        guard let longDynamicLink = linkBuilder?.url else { return }
        
    
        print(longDynamicLink.absoluteURL)
        DynamicLinkComponents.shortenURL(longDynamicLink, options: nil) { url, warnings, error in
            
            
            print(error.debugDescription)
            if let error = error {
                
                return
            }
            
            let textMsg = NSLocalizedString("invite_share_message", comment: "Add message").replacingOccurrences(of: "[budget]", with: self.budgetName)
            self.textInputMessage.text = "\(textMsg)\n\(url!)"
            self.shareNow(shortURL: url!)
        }
        
       
        
        // Fall back to the base url if we can't generate a dynamic link.
        //return linkBuilder.link ?? baseURL
    }
    
    func shareNow(shortURL:URL) {
        
        let subject = NSLocalizedString("invite_share_subject", comment: "subject")
        let msg = NSLocalizedString("invite_share_message", comment: "body").replacingOccurrences(of: "[budget]", with: budgetName)
        //let invitationLink = shortURL.absoluteString
        
        let activities: [Any] = [
            subject,
            shortURL,
            msg
        ]
        let controller = UIActivityViewController(activityItems: activities,
                                                  applicationActivities: nil)
        
        present(controller, animated: true, completion: nil)
        
    }
    
    func sendEmailNow(shortURL:URL) {
        
        //guard let referrerName = Auth.auth().currentUser?.displayName else { return }
        let subject = NSLocalizedString("invite_share_subject", comment: "subject")+" :"+budgetName
        let invitationLink = shortURL.absoluteString
        let msg = NSLocalizedString("invite_share_message", comment: "body").replacingOccurrences(of: "[budget]", with: budgetName)+invitationLink
        //"<p>Let's play MyExampleGame together! Use my <a href=\"\(invitationLink)\">referrer link</a>!</p>"
        
        if !MFMailComposeViewController.canSendMail() {
            // Device can't send email
            return
        }
        let mailer = MFMailComposeViewController()
        mailer.mailComposeDelegate = self
        mailer.setSubject(subject)
        mailer.setMessageBody(msg, isHTML: true)
        self.present(mailer, animated: true, completion: nil)
    }

    @objc func userCircleTapped() {
        let vc = UserCircleViewController(nibName: "UserCircleViewController", bundle: nil)
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func onEditorSeleted(value: String) {
        self.textInputEmail.text = value
    }
    
}
