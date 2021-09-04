//
//  InviteUserInGroupViewController.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 1/3/21.
//  Copyright © 2021 Armel Koudoum. All rights reserved.
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
import SwiftValidator

class InviteUserInGroupViewController: BaseScreenViewController,
                                       UITextFieldDelegate,
                                       MFMailComposeViewControllerDelegate,
                                       EditorSelectDelegate,
                                       ValidationDelegate{
   
    

    @IBOutlet weak var txtPersonEmail: NiceTextField!
    @IBOutlet weak var notfoundView: UIView!
    @IBOutlet weak var txtMesageInvite: IsmTextNote!
    @IBOutlet weak var btnInvite: ButtonWithArrow!
    @IBOutlet weak var btnFindUser: UIButton!
    @IBOutlet weak var errorEmail: ErrorLabel!
    
    var validator:Validator!
    var team: TeamModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("titleUserGroupInvite", comment: "Invite")
        
        let cancelButton = UIBarButtonItem(image: UIImage(named: "back_icon"), landscapeImagePhone: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(cancel(_:)))
        self.navigationItem.leftBarButtonItem  = cancelButton
        self.notfoundView.isHidden = true
        self.txtPersonEmail.placeholder =  NSLocalizedString("typeEmail", comment: "Type email")
        btnInvite.addTarget(self, action: #selector(buttonSaveAction), for: .touchUpInside)
        // Do any additional setup after loading the view.
        
        btnFindUser.setImage(btnFindUser.imageView?.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        btnFindUser.tintColor = UIColor(named: "tintIconsColor")
        btnFindUser.addTarget(self, action: #selector(userCircleTapped), for: .touchUpInside)
        
        let editorList = appDelegate?.getUserCircle() ?? []
        if editorList.count > 0 {
            btnFindUser.isHidden = false
        }
        
        //
        btnInvite.setImage(btnInvite.imageView?.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        btnInvite.tintColor = .white
        
        self.errorEmail.text = ""
        txtPersonEmail.tag = 1
        txtPersonEmail.delegate = self
        self.validator = Validator()
        self.validator.registerField(txtPersonEmail, errorLabel: errorEmail,
                                     rules: [RequiredRule(message: NSLocalizedString("text_required", comment: "Required")),
                                             EmailRule(message: NSLocalizedString("invalid_email", comment: "Invalid"))])
        
        
    }


    @objc func cancel(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func buttonSaveAction() {
        
        self.validator.validate(self)
    }
    func validationSuccessful() {

        self.inviteNow()
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
    
    func inviteNow() {
        let fbUser = FbUser(reference: self.firestoreRef)
        
        fbUser.getByEmail(txtPersonEmail.text!.lowercased(),
        listner: { (user, found)  in
            
          
            if found {
                
            
                let fbTeam = FbTeamModel(reference: self.firestoreRef)
                fbTeam.get(forId: self.team.gid, listener: {team in
                    self.notfoundView.isHidden = true
                    self.displayUserSharedBudget(user: user)
                }, error_message: { err in
                    self.notfoundView.isHidden = false
                    self.displayUserSharedBudget(user: user)
                })
                
                
                
            } else {
                
                 self.notfoundView.isHidden = true
                 self.generateContentLink()
            }
        },
        errorReturn: {(error) in
            self.generateContentLink()
        })
    }
    
    
    func displayUserSharedBudget(user:PUser) {
        
       
        
        let alert = UIAlertController(title: NSLocalizedString("group_confirn_shared", comment: "Confirm"),
                                      message: NSLocalizedString("group_shared", comment: "question").replacingOccurrences(of: "[userName]", with: self.txtPersonEmail.text!) , preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("text_continue", comment: "continue"), style: .default, handler: { (action) in
            
            let member:TeamMemberModel = TeamMemberModel()
            member.teamID = self.team.gid
            member.userWithTeamId = "\(String(describing: user.gid))\(String(describing: self.team.gid))"
            member.fullName = user.email
            member.userEmail = user.email
            member.userId = user.gid
            member.JoiningDate = Int(Date().timeIntervalSince1970)
            member.team = self.team
            let fbteamMember = FbTeamMember(reference: self.firestoreRef)
            fbteamMember.write(member)
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("text_cancel", comment: "Cancel"), style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func generateContentLink() {
        
        if self.notfoundView.isHidden {
            self.notfoundView.isHidden = false
            self.btnInvite.setTitle(NSLocalizedString("invite_share_link", comment: "Share invite link"), for: .normal)
        }
        
        let baseURL = URL(string: "https://www.digitleaf.com/?team=" + team.gid!)!
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
            
            let textMsg = NSLocalizedString("invite_group_message", comment: "Add message").replacingOccurrences(of: "[groupName]", with: self.team.name)
            self.txtMesageInvite.text = "\(textMsg)\n\(url!)"
            self.shareNow(shortURL: url!)
        }
        
       
        
        // Fall back to the base url if we can't generate a dynamic link.
        //return linkBuilder.link ?? baseURL
    }
    
    func shareNow(shortURL:URL) {
        
        let subject = NSLocalizedString("invite_group_subject", comment: "subject")
        let msg = NSLocalizedString("invite_group_message", comment: "body").replacingOccurrences(of: "[groupName]", with: self.team.name)
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
        let subject = NSLocalizedString("invite_group_subject", comment: "subject")+" :"+self.team.name
        let invitationLink = shortURL.absoluteString
        let msg = NSLocalizedString("invite_group_message", comment: "body").replacingOccurrences(of: "[groupName]", with: self.team.name)+invitationLink
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
        self.txtPersonEmail.text = value
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if textField.tag == 1 {
            errorEmail.text = ""
            textField.layer.borderColor = UIColor(named: "textInputBorderColor")?.cgColor
        }
        
        return true
    }

}
