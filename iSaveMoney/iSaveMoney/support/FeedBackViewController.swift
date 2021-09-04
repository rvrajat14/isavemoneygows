//
//  FeedBackViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 3/10/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import MessageUI
import HelpCenter
import ISMLBase
import CheckoutModule

class FeedBackViewController: BaseScreenViewController, MFMailComposeViewControllerDelegate {

    static var viewIdentifier:String = "FeedBackViewController"
    
    @IBOutlet weak var buttonContactUs: UIButton!
    @IBOutlet weak var buttonHowItWorks: UIButton!
    @IBOutlet weak var txtTitleName: UILabel!
    @IBOutlet weak var txtBodyName: UILabel!
    @IBOutlet weak var buttonDocFaq: UIButton!
    @IBOutlet weak var buttonManagePro:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("drawerHelpFeedback", comment: "Help & Feedback")
        let cancelButton = UIBarButtonItem(image: UIImage(named: "back_icon"), landscapeImagePhone: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(cancel(_:)))
        self.navigationItem.leftBarButtonItem  = cancelButton
        
        let rigt_image = UIImage(named: "right_chevron")
        self.buttonContactUs.setImage(rigt_image, for: .normal)
        self.buttonContactUs.setTitle(NSLocalizedString("feedbackContactUs", comment: " Contact us"), for: .normal)
        self.buttonHowItWorks.setImage(rigt_image, for: .normal)
        self.buttonHowItWorks.setTitle(NSLocalizedString("feedbackHowItWorks", comment: " How it works"), for: .normal)
        self.buttonDocFaq.setImage(rigt_image, for: .normal)
        self.buttonDocFaq.setTitle(NSLocalizedString("faqAndDocumentation", comment: " FAQ and Documentation"), for: .normal)

        self.buttonManagePro.setTitle(NSLocalizedString("youArePro", comment: " Premium"), for: .normal)
        self.buttonManagePro.addTarget(self, action: #selector(openPremium), for: .touchUpInside)
        // Do any additional setup after loading the view.
        let pref = AccessPref()
        self.buttonManagePro.isHidden = !pref.isProAccount()
        
        if (flavor.getFlavor() == FlavorType.legacy) {
            txtTitleName.text = NSLocalizedString("app_name", comment: "")
        } else {
            txtTitleName.text = NSLocalizedString("app_name_mm", comment: "")
        }
        
        if let text = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String {
            
            txtBodyName.text = NSLocalizedString("txtSupportScreen", comment: "").replacingOccurrences(of: "[app_name]", with: NSLocalizedString("app_name_mm", comment: "")).replacingOccurrences(of: "[version]", with: text)
            
        } else {
            txtBodyName.text = NSLocalizedString("txtSupportScreen", comment: "").replacingOccurrences(of: "[version]", with: "1.0.x").replacingOccurrences(of: "[app_name]", with: NSLocalizedString("app_name_mm", comment: ""))
        }
    }
    
    
    
    @IBAction func actionContactUs(_ sender: Any) {
        
        if MFMailComposeViewController.canSendMail() {
        
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setToRecipients(["contact.isavemoneygo@gmail.com"])
            mailComposerVC.setSubject(NSLocalizedString("feedbackEmailSubject", comment: "iOS - iSaveMoney feedback"))
            mailComposerVC.setMessageBody(NSLocalizedString("feedbackEmailBody", comment: "Please description your request below:"), isHTML: false)
            self.present(mailComposerVC, animated: true, completion: nil)
        }else {
        
            let alertController = UIAlertController(title: NSLocalizedString("feedbackCantInitComposer", comment: "Can't init email composer..."), message: NSLocalizedString("feedbackCantInitComposerBody", comment: "Your device email client might be disable"), preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("feedbackCantInitComposerOkButton", comment: "Ok"), style: .default) { action in
                // perhaps use action.title here
                
            })
        
            self.present(alertController, animated: true) {}
        
        }
        

        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        
        var message = ""
        
        switch (result) {
        case MFMailComposeResult.sent:
            print("Email sent.")
            message = "Email sent."
            break
        case MFMailComposeResult.saved:
            print("You saved a draft of this email")
            message = NSLocalizedString("feedbackEmailSaved", comment: "You saved a draft of this email")
            break
        case MFMailComposeResult.cancelled:
            print("You cancelled sending this email.")
            message = NSLocalizedString("feedbackEmailCancelled", comment: "You cancelled sending this email.")
            
            self.displayMessage(message: "You cancelled sending this email.")
            break
        case MFMailComposeResult.failed:
            print("Mail failed:  An error occurred when trying to compose this email")
            message = NSLocalizedString("feedbackEmailFailed", comment: "Mail failed")
            break
        default:
            print("An error occurred when trying to compose this email")
            message = NSLocalizedString("feedbackErrorOccurred", comment: "An error occurred when trying to compose this email")
            break
        }
        
        if message != "" {
            
            self.displayMessage(message: message)
           
        }
        
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    func displayMessage(message:String) {
        
        let alertController = UIAlertController(title: NSLocalizedString("feedbackCantInit", comment: "Can't init email..."), message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("feedbackCantInitOkButton", comment: "Ok"), style: .default) { action in
            // perhaps use action.title here
            
        })
        
        self.present(alertController, animated: true) {}
    }
    
    
    @IBAction func howItWorks(_ sender: Any) {
        
        let args:NSDictionary = ["fromscreen": "help"]
        appDelegate.navigateTo(instance: HowItWorksViewController(), params: args)
    }
    
    @IBAction func docFaq(_ sender: Any) {
        let helpCenter = HelpCenterHome(nibName: "HelpCenterHome", bundle: Bundle(identifier: "com.digitleaf.helpcenter"))
        let navCtrl = UINavigationController(rootViewController: helpCenter)
        self.present(navCtrl, animated: true)
        //self.navigationController?.pushViewController(helpCenter, animated: true)
        
    }
    
    @objc func cancel(_ sender: Any) {
        
        appDelegate.navigateTo(instance: ViewController())
    }
    
    @objc func openPremium(){
        let vc = PremiumViewController(nibName: "PremiumViewController", bundle: Bundle(identifier: CoConst.BUNDLE_ID))

        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true)
        
        //IsmUtils.promtForSub(navContoller: self)
    }
    

}
