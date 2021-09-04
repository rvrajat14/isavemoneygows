//
//  AccountTransferViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 5/18/21.
//  Copyright © 2021 Armel Koudoum. All rights reserved.
//

import UIKit
import Firebase
import SwiftValidator
import FirebaseFirestore
import TinyConstraints
import ISMLBase
import ISMLDataService
import ToolsBoxModule
import CheckoutModule

class AccountTransferViewController: BaseViewController,
    UITextFieldDelegate,
    DateDelegate,
    ValidationDelegate,ModalSchedulerDelegate, CalDelegate {
    func onCalResult(value: String) {
        self.amountText.text = value
    }
    
    
    func scheduleSelected(schedule: ScheduleModel) {
        self.mSchedule.copyFromDictionary(value: schedule.toAnyObject())
        self.scheduleRender(schedule:self.mSchedule)
    }
    
    
    static var viewIdentifier:String = "TransferViewController"
    
    @IBOutlet weak var sourceAccountErrorText: UILabel!
    @IBOutlet weak var sourceAccountText: UITextField!
    
    @IBOutlet weak var destinationAccountText: UITextField!
    @IBOutlet weak var destinationAccountErrorText: UILabel!
    @IBOutlet weak var amountText: UITextField!
    @IBOutlet weak var amountErrorText: UILabel!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var schedulerToogler: UISwitch!
    @IBOutlet weak var transactionDateStackView: UIStackView!
    
    @IBOutlet weak var labelRepeatSequence: UILabel!
    @IBOutlet weak var labelFirstGoesOff: UILabel!
    
    @IBOutlet weak var schedulerWrapper: UIView!
    @IBOutlet weak var buttonCalulator: UIButton!
    
    
    lazy var viewControllerNavController:UINavigationController = {
        
        let cv:ModalScheduler = ModalScheduler()
        let nav = UINavigationController(rootViewController: cv)
        return nav
    }()
    
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
    
    
    
    var mTransfer:Transfer!
    var mSchedule:Schedule!
    
    var mAccount:Account!
    //var ref: DatabaseReference!
    var firestoreRef:Firestore!
    var pref:MyPreferences!
    var dateSelector:CalendarPicker!
    var fromAccountPicker:BoxPicker!
    var toAccountPicker:BoxPicker!
    
    var firstGoOffSelector:CalendarPicker!
    var schedulePicker:SchedulePicker!
    
    var appDelegate:AppDelegate!
    var flavor:Flavor!
    var validator:Validator!
    
    
    
    var currentTag:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpActivity()
        self.setupValidator()
        self.setupInitialState()
        amountText.keyboardType = .decimalPad
        fromAccountPicker = BoxPicker()
        toAccountPicker = BoxPicker()
        
        self.setAccounts()
        
        //Set currency
        
    }
    
    func setupInitialState() {
        
        mTransfer = Transfer(dataMap: [:])
        self.mSchedule = self.defaultSchedule()
        
        //Date can't be out of date range
        let defaultDate = Date()
        
        //Setup date picker
        dateSelector = CalendarPicker()
        dateSelector.tag = 0
        dateSelector.delegate = self
        dateSelector.setUp(widthSize: Int(self.view.frame.width),
                           heightSize: 220,
                           selectedDate: defaultDate,
                           displayToday: false, dformat: pref.getDateFormat())
        dateSelector.date = defaultDate
        
        self.dateText.inputView = dateSelector
        self.dateText.inputAccessoryView = dateSelector.toolBar
        self.dateText.text = UtilsIsm.DateFormat(date: defaultDate, format: self.pref.getDateFormat())
        
        self.scheduleRender(schedule: self.mSchedule)
        
    
        
        schedulerWrapper.layer.cornerRadius = 5.0
        schedulerWrapper.layer.borderColor = Const.GREY_CLEAR.cgColor
        schedulerWrapper.layer.borderWidth = 1
        schedulerWrapper.isHidden = true
        
       
        let btnImage = buttonCalulator.imageView?.image
        buttonCalulator.setImage(btnImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        buttonCalulator.tintColor = UIColor(named: "tintIconsColor")
        buttonCalulator.imageView?.tintColor = UIColor(named: "tintIconsColor")
        buttonCalulator.addTarget(self, action: #selector(calculatorTapped), for: .touchUpInside)
    }
    

    @objc func calculatorTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let cal = TBUtils.getCalculator()
        cal.delegate = self
        self.present(cal, animated: true, completion: nil)
    }

    
    
    func setUpActivity() {
        self.pref = MyPreferences()
        
        validator = Validator()
        flavor = Flavor()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.firestoreRef = appDelegate.firestoreRef
        //
//        self.navigationController!.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.tintColor = flavor.getNavigationBarColor()
//        navigationController?.navigationBar.barTintColor = flavor.getPrimaryColor()
        
        self.navigationItem.leftBarButtonItem  = cancelButton
        self.navigationItem.rightBarButtonItem = saveButton
        self.title = NSLocalizedString("TVCAddTransfer", comment: "Add Transfer")
        
        
        self.sourceAccountText.rightView = self.getAccountTextRightImageView(named: "right_chevron")
        self.sourceAccountText.rightViewMode = UITextField.ViewMode.always
        self.destinationAccountText.rightView = self.getAccountTextRightImageView(named: "right_chevron")
        self.destinationAccountText.rightViewMode = UITextField.ViewMode.always
        
        self.sourceAccountText.delegate = self
        self.sourceAccountText.tag = 1
        self.sourceAccountErrorText.text = ""
        
        self.destinationAccountText.delegate = self
        self.destinationAccountText.tag = 1
        self.destinationAccountErrorText.text = ""
        
        self.amountText.delegate = self
        self.amountText.tag = 3
        self.amountErrorText.text = ""
        
        self.dateText.delegate = self
        self.dateText.rightView = self.getAccountTextRightImageView(named: "date_range")
        self.dateText.rightViewMode = UITextField.ViewMode.always
        self.dateText.tag = 4
    }
    
    func getAccountTextRightImageView(named:String) -> UIImageView{
        let imageViewCategory = UIImageView()
        let imageArrow = UIImage(named: named)
        imageViewCategory.image = imageArrow
        imageViewCategory.alpha = 0.5
        imageViewCategory.image = imageViewCategory.image!.withRenderingMode(.alwaysTemplate)
        imageViewCategory.tintColor = UIColor.gray
        imageViewCategory.frame = CGRect(x: 5, y: 0, width: 30, height: 30)
        return imageViewCategory
    }
    
    func setupValidator() {
        
        self.validator = Validator()
        self.validator.registerField(sourceAccountText, errorLabel: sourceAccountErrorText , rules: [RequiredRule(message: NSLocalizedString("text_required", comment: "Required"))])
        self.validator.registerField(destinationAccountText, errorLabel: destinationAccountErrorText, rules: [RequiredRule(message: NSLocalizedString("text_required", comment: "Required"))])
    }
    
    
    
    func setAccounts() {
        
        let pref = MyPreferences()
        let fbAccount:FbAccount = FbAccount(reference: self.firestoreRef)
        
        fbAccount.getUserAccounts(pref.getUserIdentifier(), complete: {(accountsList) in
            
            var mItems:[PickerItem] = []
            
            var fromIndex = 0
            var toIndex = 0
            var index = 0
            
            for account in accountsList {
                
                if account.gid != "" {
                    mItems.append(PickerItem(id: 0, gid: account.gid, title: account.name)!)
                }
                
                if self.mTransfer.from != "" && account.gid == self.mTransfer.from {
                    
                    fromIndex = index
                }
                
                if self.mTransfer.to != "" && account.gid == self.mTransfer.to {
                    
                    toIndex = index
                }
                index += 1
                
            }
            
            self.toAccountPicker.setUp(widthSize: Int(self.view.frame.width), heightSize: 220, items: mItems, inputText: self.destinationAccountText, inputTextErr: self.destinationAccountErrorText)
            self.destinationAccountText.inputView = self.toAccountPicker
            self.destinationAccountText.inputAccessoryView = self.toAccountPicker.toolBar
            self.toAccountPicker.setSelected(index: toIndex)
            
            
            self.fromAccountPicker.setUp(widthSize: Int(self.view.frame.width), heightSize: 220, items: mItems, inputText: self.sourceAccountText, inputTextErr: self.sourceAccountErrorText)
            self.sourceAccountText.inputView = self.fromAccountPicker
            self.sourceAccountText.inputAccessoryView = self.fromAccountPicker.toolBar
            self.fromAccountPicker.setSelected(index: fromIndex)
            
            
        }, error_message: {(error) in
            
            print(error)
        })
        
        
    }
    
    func validationSuccessful() {
        
        let fbTransfer:FbTransfer = FbTransfer(reference: self.firestoreRef)
        
        if amountText.text! == "" {
            amountText.text = "0.0"
        }
        //let transfer:Transfer = Transfer()
        mTransfer.user_gid = self.pref.getUserIdentifier()
        mTransfer.from = self.fromAccountPicker.getGid()
        mTransfer.to = self.toAccountPicker.getGid()
        mTransfer.active = 1;
        mTransfer.from_str = self.sourceAccountText.text!
        mTransfer.to_str = self.destinationAccountText.text!
        mTransfer.type = 0
        mTransfer.amount =   UtilsIsm.readNumberInput(value:amountText.text!)
        mTransfer.transaction_date = Int(dateSelector.date.timeIntervalSince1970)
        //mTransfer.insert_date = Int(Date().timeIntervalSince1970)
        
        
        if !self.schedulerToogler.isOn && mSchedule.gid == "" {
            if mTransfer.gid != "" {
                mTransfer.last_update = Int(Date().timeIntervalSince1970)
                _ = fbTransfer.update(mTransfer, completion: {(transfer) in
                    
                }, error_message: {(error) in
                    print(error)
                    
                })
            } else {
                
                mTransfer.insert_date = Int(Date().timeIntervalSince1970)
                fbTransfer.write(mTransfer, completion: {(transfer) in
                    
                }, error_message: {(error) in
                    print(error)
                    
                })
                
            }
            self.navigationController?.popViewController(animated: true)
                
            } else {
                
                saveSchedule(transfer: mTransfer)
                
            }
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
        //Save
        @objc func save(_ sender: UIBarButtonItem) {
            self.validator.validate(self)
            
        }
        
        @objc func cancel(_ sender: UIBarButtonItem) {
            self.navigationController?.popViewController(animated: true)
            
        }
        
        
        func dateSelected(tag:Int, cancel:Bool) {
            
            self.dateText.resignFirstResponder()
            if !cancel {
                self.dateText.text = Utils.formatTimeStamp(Int(dateSelector.date.timeIntervalSince1970))
            }
            
        }
        
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            
        }
        
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            
            self.currentTag = textField.tag
        }
        @objc func doneButtonAction () {
            
            switch self.currentTag {
            case 3:
                self.amountText.resignFirstResponder()
                break
            default:
                break
            }
        }
        
        func saveSchedule(transfer:Transfer) {
            
            let fbSchedule:FbSchedule = FbSchedule(reference: self.firestoreRef)
            
            mSchedule.active = 1;
            
            mSchedule.transaction_title = transfer.comment!
            mSchedule.transaction_str = transfer.toAnyObject()
            
            
            if mSchedule.gid != "" {
                
                mSchedule.last_update = Int(dateSelector.date.timeIntervalSince1970)
                _=fbSchedule.update(mSchedule, completion: {(scgedule) in
                    
                }, error_message: {(error) in
                    print(error)
                })
            } else {
                
                mSchedule.user_gid = self.pref.getUserIdentifier()
                mSchedule.transaction_type = Scheduler.TRANSACTION_TYPE_TRANSFER
                
                mSchedule.insert_date = Int(dateSelector.date.timeIntervalSince1970)
                fbSchedule.write(mSchedule, completion: {(schedule) in
                    
                }, error_message: {(error) in
                    print(error)
                })
            }
            self.navigationController?.popViewController(animated: true)
        }
        @IBAction func onScheduulerToogled(_ sender: UISwitch) {
            let pref = AccessPref()
            if !pref.isProAccount() {
                sender.isOn = false
                IsmUtils.promtForPro(navContoller: self, featureName: NSLocalizedString("txtProfeatureBody", comment: "") )
                return
            }
            
            self.transactionDateStackView.isHidden = self.schedulerToogler.isOn
            self.schedulerWrapper.isHidden = !self.schedulerToogler.isOn
            
        }
        @IBAction func onRecurringButtonClicked(_ sender: Any) {
            let vcon = self.viewControllerNavController.topViewController as! ModalScheduler
            let scheduleModel = ScheduleModel()
            scheduleModel.copyFromDictionary(value: self.mSchedule.toAnyObject())
            vcon.schedule = scheduleModel
            vcon.delegate = self
            vcon.dateFormt = self.pref.getDateFormat()
            vcon.timeFormat = self.pref.getTimeFormat()
            vcon.flavor = self.flavor
            self.present(self.viewControllerNavController, animated: true, completion: nil)
        }
        
        
        
        func defaultSchedule() -> Schedule {
            
            let schedule = Schedule()
            
            
            schedule.transaction_type = Scheduler.TRANSACTION_TYPE_INCOME
            schedule.type = ScheduleType.MONTHLY
            schedule.step = 1
            schedule.weeklyDay = -1
            schedule.monthlyOption = -1
            schedule.numberEvent = 2
            schedule.dateLimitOccur = 0
            schedule.typeMaxOccur = ScheduleCount.FOR_EVER
            schedule.setNextOccur(firstGoesOff: Int(Date().timeIntervalSince1970))
            schedule.setLastOccurred(schedule.nextOccurred)
            
            
            return schedule
        }
        
        func scheduleRender(schedule:Schedule) {
            
            let timeStr = Utils.timeFormat(Int(schedule.nextOccurred))
            let dateStr = Utils.formatTimeStamp(Int(schedule.nextOccurred))
            self.labelFirstGoesOff.text = String(format: "%@%@", NSLocalizedString("NEVCFirstGoesOff", comment: "First goes off: "),schedule.verboseSchedule())
            self.labelRepeatSequence.text = String(format: "%@%@", NSLocalizedString("NEVCThenRepeat", comment: "Then repeat: "),"\(dateStr) \(timeStr)")
            
        }
        
        
}
