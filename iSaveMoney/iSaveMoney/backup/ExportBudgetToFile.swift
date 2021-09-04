//
//  ExportBudgetToFile.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 11/29/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import SwiftValidator
import UIKit
import MessageUI
import ISMLDataService
import ISMLBase
import TinyConstraints
import CheckoutModule

class ExportBudgetToFile: BaseViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate, ValidationDelegate {
    
    
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
    
    
    var pref: MyPreferences!
    var flavor:Flavor!
    var appDelegate:AppDelegate!
    var mBudgetObject:BudgetObject!
    
    var budgetTitleLabel:NiceLabel!
    var titleLabel:NiceLabel!
    var descriptionLabel:NiceLabel!
    
    var emailLabel:NiceLabel!
    var emailTextEdit:NiceTextField!
    var emailStackView:UIStackView!
    var emailLabelError:NiceLabel!
   
    var typeFormat:UISegmentedControl!
    var wrapperStackView:UIStackView!
    
    var submitButton:ButtonWithArrow!
    
    static var viewIdentifier:String = "ExportBudgetToFile"
    
    var validator:Validator!
    
    public override func getTag() -> String {
        
        return "ExportBudgetToFile"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flavor = Flavor()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        self.title = NSLocalizedString("txtExport", comment: "Export")

        
        let cancelButton = UIBarButtonItem(image: UIImage(named: "back_icon"), landscapeImagePhone: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(cancelpage))
        
        self.navigationItem.leftBarButtonItem  = cancelButton
        
        setupViews()
        self.validator = Validator()
        self.validator.registerField(emailTextEdit, errorLabel: emailLabelError, rules: [RequiredRule(message: NSLocalizedString("text_required", comment: "Required")),
            EmailRule(message: NSLocalizedString("invalid_email", comment: "Email invalid"))])
    }
    
    func setupViews() {
        
        budgetTitleLabel = {
            let label = NiceLabel(title: IsmUtils.makeTitleFor(budget: mBudgetObject.formBudget()))
            label.font = UIFont.boldSystemFont(ofSize: 18)
            //label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        
        titleLabel = {
            let label = NiceLabel(title:NSLocalizedString("export_csv_headline"
                , comment: "Export file headline"))
            label.font = UIFont.boldSystemFont(ofSize: 14)
            //label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        
        descriptionLabel = {
            let label = NiceLabel(title: NSLocalizedString("export_csv_description", comment: "description..."))
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            //label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        
        emailLabel = {
            let label = NiceLabel(title: NSLocalizedString("export_email", comment: "description..."))
            //label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        emailTextEdit = {
            let edit = NiceTextField(placeholder: NSLocalizedString("export_email_placeholder", comment: "Enter email..."))
            edit.autocorrectionType = UITextAutocorrectionType.no
            edit.keyboardType = UIKeyboardType.emailAddress
            edit.returnKeyType = UIReturnKeyType.done
            edit.delegate = self
            return edit
        }()
        
        emailLabelError = {
            let label = NiceLabel()
            label.textColor = Const.RED
            label.isHidden = true
            return label
        }()
        
        emailStackView = {
            let s = UIStackView(arrangedSubviews: [emailLabel, emailTextEdit,emailLabelError])
            s.axis = .vertical
            s.distribution = .equalSpacing
            s.alignment = .fill
            s.spacing = 6
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            //s.translatesAutoresizingMaskIntoConstraints = false
            return s
        }()
        
        typeFormat = {
            let segemented = UISegmentedControl (
                items:[
                    NSLocalizedString("export_in_csv", comment: "CSV"),
                    NSLocalizedString("export_in_excel", comment: "MS Excel"),
                    NSLocalizedString("export_in_pdf", comment: "PDF")])
            segemented.frame = CGRect()
            segemented.selectedSegmentIndex = 0
            segemented.tintColor = flavor.getAccentColor()
            //segemented.translatesAutoresizingMaskIntoConstraints = false
            return segemented
        }()
        
        
        submitButton = {
            
            let button = ButtonWithArrow()
            button.setTitle(NSLocalizedString("share_your_list_send", comment: ""), for: .normal)
            return button
        }()
        wrapperStackView = {
            let s = UIStackView(arrangedSubviews: [budgetTitleLabel, titleLabel, descriptionLabel, emailStackView, typeFormat, submitButton])
            s.axis = .vertical
            s.distribution = .equalSpacing
            s.alignment = .fill
            s.spacing = 18
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           // s.translatesAutoresizingMaskIntoConstraints = false
            return s
        }()
        
        
        self.view.addSubview(wrapperStackView)
        
        //emailTextEdit.widthAnchor.constraint(equalTo: wrapperStackView.widthAnchor).isActive = true
        
        wrapperStackView.edgesToSuperview(excluding: .bottom, insets: .left(10) + .top(40) + .right(10))
        
        
        submitButton.addTarget(self, action: #selector(ExportBudgetToFile.exportButton), for: .touchUpInside)
        
        //submitButton.topAnchor.constraint(equalTo: typeFormat.bottomAnchor, constant: 25)
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("End Editing")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       // _ = validateEmail()
        return true
    }
    @objc func cancelpage() {
        //appDelegate.navigateTo(instance: ViewController())
        self.navigationController?.popViewController(animated: true)
    }
    
    func getType() -> String {
        
        switch  typeFormat.selectedSegmentIndex {
        case 0:
            return NSLocalizedString("export_in_csv", comment: "CSV")
        case 1:
            return NSLocalizedString("export_in_excel", comment: "MS Excel")
        case 2:
            return NSLocalizedString("export_in_pdf", comment: "PDF")
        default:
            return ""
            
        }
        
    }
    
    func getExtension() -> String {
        
        switch  typeFormat.selectedSegmentIndex {
        case 0:
            return "csv"
        case 1:
            return "xlsx"
        case 2:
            return "pdf"
        default:
            return ""
            
        }
        
    }
    
    func getUrl() -> String {
        
        var url:String = ""
        switch  typeFormat.selectedSegmentIndex {
        case 0:
            url = Const.CLOUD_FUNCTION + "csvReportFile"
            
            break
            
        case 1:
            url = Const.CLOUD_FUNCTION + "excelSheetReportFile"
            
            break
        case 2:
            url = Const.CLOUD_FUNCTION + "pdfReportFile"
            
            break
        default:
            url = ""
            break
        }
        
        return url
    }
    func validationSuccessful() {
        
        
        self.indicatorShow()
        
        let budgetJson = JSONBudget(budget_object: self.mBudgetObject)
        
        var objectJsonToSend:[String : Any] = [:]
        objectJsonToSend["rawData"] = budgetJson.makeJson()
        objectJsonToSend["email"] = emailTextEdit.text
        
        objectJsonToSend["subject"] = NSLocalizedString("email_subject", comment: "subject").replacingOccurrences(of: "[type]", with: self.getType())
        objectJsonToSend["body"] = NSLocalizedString("email_body", comment: "body")
        
        
        let jsonString:Data = try! JSONSerialization.data(withJSONObject: objectJsonToSend, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let dataToSend = NSString(data: jsonString as Data, encoding: String.Encoding.utf8.rawValue)! as String
        print(dataToSend)
        
        sendHttpRequest(dataToSend: dataToSend)
    }
    @objc func exportButton() {
        let pref = AccessPref()
       
        if !pref.isProAccount() {
            IsmUtils.promtForPro(navContoller: self, featureName: NSLocalizedString("textGoPro", comment: "Unlimitted budget") )
            return
        }
       self.validator.validate(self)
   }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //_ = validateEmail()
        return true
    }
    
    
    func sendHttpRequest(dataToSend: String) {
        // This shows how you can specify the settings/parameters instead of using the default/shared parameters
        let urlToRequest = self.getUrl()
            
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let paramString = dataToSend
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        let task = session4.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            self.indicatorHide()
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                self.exportFailed()
                print("*****error")
                return
            }
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            print("Result...")
            print(dataString!)
            
            let dataResult:[String:Any] = self.parseStringToJson(jsonText: dataString! as String)
            
            print(dataResult)
            var status = dataResult["status"] as? Bool ?? false
            if (status) {
                
                //self.exportCompleted()
                print((dataResult["url"] as! String))
                let fileURL = URL(string: (dataResult["url"] as! String))

                let downloader:DownloadFile = DownloadFile()
                downloader.load(URL: fileURL! as NSURL,fileType: self.getExtension(), listener:{ url in
                    
                    self.sendExportFile(pathForLog: url, extensionType: self.getExtension())
                })
            } else {
                self.exportFailed()
            }
            
        }
        task.resume()
        
    }
    
    func parseStringToJson(jsonText:String) -> [String:Any] {
        var dictonary:[String:Any] = [:]
        
        if let data = jsonText.data(using: String.Encoding.utf8) {
            //as? [String:AnyObject]!
            do {
                dictonary =  try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] ?? [:]
                
                
            } catch let error as NSError {
                print(error)
            }
        }
        
        return dictonary//["status"]! as! Bool ?? false
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return [:]
    }

    
    func exportCompleted() {
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(
                title: NSLocalizedString("export_sent_title", comment: "title"),
                message: NSLocalizedString("export_sent_body", comment: "body").replacingOccurrences(of: "[email]", with: self.emailTextEdit.text!),
                preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: NSLocalizedString("text_ok", comment: "ok"), style: .default) { action in
                
            })
            
            
            
            self.present(alertController, animated: true) {}
        }
        
    }
    
    func exportFailed() {
        
        DispatchQueue.main.async {
            
            let alertController = UIAlertController(
                title: NSLocalizedString("export_failed_title", comment: "title"),
                message: NSLocalizedString("export_failed_body", comment: "body"),
                preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: NSLocalizedString("text_ok", comment: "ok"), style: .default) { action in
                
            })
            
            
            self.present(alertController, animated: true) {}
        }
        
    }
    
    
    
    
    func sendExportFile(pathForLog: URL, extensionType: String) {
        //application/vnd.ms-excel
        //application/pdf
        
        var fileType = "csv/txt"
        
        if extensionType == "pdf" {
            fileType = "application/pdf"
        }
        
        if extensionType == "xlsx" {
            fileType = "application/vnd.ms-excel"
        }
        if MFMailComposeViewController.canSendMail() {
            
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setToRecipients([emailTextEdit.text!])//contact.isavemoneygo@gmail.com
            mailComposerVC.setSubject("Export file....")
            mailComposerVC.setMessageBody("CSV file attached", isHTML: false)
            
            if let fileData = NSData(contentsOf: pathForLog) {
                mailComposerVC.addAttachmentData(fileData as Data, mimeType: fileType, fileName: "budget-file."+extensionType)
            }
            
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
}
