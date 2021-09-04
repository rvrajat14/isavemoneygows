//
//  NewIncomeViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 6/18/16.
//  Copyright © 2016 UlmatCorpit. All rights reserved.
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
//import SearchTextField

class NewIncomeViewController: BaseViewController,
                                UITextFieldDelegate,
                                ModalSchedulerDelegate,
                                CalDelegate,
                                ValidationDelegate, IdeaSelectDelegate{
    
    
    
    
    func scheduleSelected(schedule: ScheduleModel) {
        self.mSchedule.copyFromDictionary(value: schedule.toAnyObject())
        self.scheduleRender(schedule:self.mSchedule)
    }
    
    
    

    func onCalResult(value: String) {
        self.txtAmount.text = value
    }
    
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
    lazy var labelDescription:NiceLabel =  {
        let label = NiceLabel(title: "Description")
        label.appendValue(value: "*")
        label.setCompressionResistance(.defaultHigh, for: .horizontal)
        return label
    }()
    lazy var labelDescriptionError: ErrorLabel = {
        let label = ErrorLabel(title: NSLocalizedString("NEVCRequired", comment: "Required"),
                               insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        label.isHidden = true
        return label
    }()
    lazy var txtDescription: NiceTextField = {
        let textfield = NiceTextField(placeholder: NSLocalizedString("NEVCTypeDescription", comment: "Type a description"),
                                      insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        textfield.tag = 1
        textfield.inputAccessoryView = doneToolbar
        textfield.delegate = self
        
        return textfield
    }()
    
    lazy var ideaImage: IsmBtnIdea = {
        let iw = IsmBtnIdea()
        iw.addTarget(self, action: #selector(ideaTapped), for: .touchUpInside)
        return iw
    }()
    
    lazy var descInputCompisit: InputBackgroundView = {
        let icomp = InputBackgroundView()
        icomp.addSubview(txtDescription)
        txtDescription.topToSuperview()
        txtDescription.leftToSuperview()
        txtDescription.bottomToSuperview()
        icomp.addSubview(ideaImage)
        ideaImage.rightToSuperview(offset: -5)
        ideaImage.centerYToSuperview()
        ideaImage.leftToRight(of: txtDescription)
        return icomp
    }()
    
    lazy var descriptionLabelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelDescription, labelDescriptionError])
        stackView.axis = .horizontal
        stackView.distribution = UIStackView.Distribution.fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 6
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return stackView
    }()
    
    lazy var labelAmount: NiceLabel = {
        let label = NiceLabel(title: NSLocalizedString("NEVCAmount", comment: "Amount"))
        return label
    }()
    
    lazy var txtAmount:NiceTextField = {
        let textfield = NiceTextField(insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 30))
        textfield.keyboardType = .decimalPad
        textfield.rightViewMode = UITextField.ViewMode.always
        textfield.tag = 2
        textfield.inputAccessoryView = doneToolbar
        textfield.delegate = self
        return textfield
    }()
    lazy var calculatorImage: UIButton = {
        let iw = UIButton()
        iw.setImage(UIImage(named: "calculator")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        iw.tintColor = UIColor(named: "tintIconsColor")
        iw.width(24)
        iw.height(24)
        iw.addTarget(self, action: #selector(calculatorTapped), for: .touchUpInside)
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(calculatorTapped(tapGestureRecognizer:)))
//        iw.addGestureRecognizer(tapGestureRecognizer)
        return iw
    }()
    lazy var amountInputCompisit: InputBackgroundView = {
        let icomp = InputBackgroundView()
        icomp.addSubview(txtAmount)
        txtAmount.topToSuperview()
        txtAmount.leftToSuperview()
        txtAmount.bottomToSuperview()
        icomp.addSubview(calculatorImage)
        calculatorImage.rightToSuperview(offset: -5)
        calculatorImage.centerYToSuperview()
        calculatorImage.leftToRight(of: txtAmount)
        return icomp
    }()
    lazy var amountStackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelAmount,amountInputCompisit])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 6
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return stackView
    }()
    
   
    @objc func calculatorTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let cal = TBUtils.getCalculator()
        cal.delegate = self
        self.present(cal, animated: true, completion: nil)
    }
    
    
    lazy var labelDate:NiceLabel = {
        let label = NiceLabel(title: NSLocalizedString("NEVCTransactionDate", comment: "Transaction date"))
        return label
    }()
    lazy var txtTransactionDate:TextFieldDateInput = {
        let textfield = TextFieldDateInput()
        textfield.rightView = TxtImageView(image: UIImage(named: "date_range"))
        textfield.rightViewMode = UITextField.ViewMode.always
        return textfield
    }()
    lazy var dateStackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelDate,txtTransactionDate])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 6
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return stackView
    }()
    
    
    lazy var labelAccount:NiceLabel = {
        let label = NiceLabel(title: NSLocalizedString("NEVCAccount", comment: "Account (optional)"))
        return label
    }()
    lazy var txtAccount:NiceTextField = {
        let textfield = NiceTextField(placeholder: NSLocalizedString("NEVCSelect", comment: "Select"),
                                      insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 30))
        textfield.rightView = TxtImageView(image: UIImage(named: "right_chevron"))
        textfield.rightViewMode = UITextField.ViewMode.always
        //textfield.isEnabled = false
        return textfield
    }()
    lazy var stackViewAccount:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelAccount,txtAccount])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 6
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return stackView
    }()
    lazy var labelPayer:NiceLabel = {
        let label = NiceLabel(title: NSLocalizedString("NEVCPayee", comment: "Payee (optional)"))
        return label
    }()
    lazy var txtPayer:NiceTextField  = {
        let textfield = NiceTextField(placeholder: NSLocalizedString("NEVCSelect", comment: "Select"),
                                      insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 30))
        textfield.rightView = TxtImageView(image: UIImage(named: "right_chevron"))
        textfield.rightViewMode = UITextField.ViewMode.always
        //textfield.isEnabled = false
        return textfield
    }()
    lazy var stackViewPayer:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelPayer,txtPayer])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 6
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return stackView
    }()
    lazy var accountPayerStackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stackViewAccount,stackViewPayer])
        stackView.axis = .horizontal
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = UIStackView.Alignment.bottom
        stackView.spacing = 12
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return stackView
    }()
    
    
    //Scheduler switch
    lazy var recurringTransactionSwitch:UISwitch = {
        let uiswitch = UISwitch(frame: CGRect(x: 20.0, y: 90.0, width: 0, height: 0))
        uiswitch.addTarget(self, action: #selector(enableRecurringTransaction), for: .valueChanged)
        return uiswitch
    }()
    lazy var recurringTransactionSwitchLabel:NiceLabel = {
        let label = NiceLabel(title: NSLocalizedString("NEVCTransactionRecurring", comment: "This transaction is recurring"))
        return label
    }()
    lazy var recurringTransactionStackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [recurringTransactionSwitch,recurringTransactionSwitchLabel])
        stackView.axis = .horizontal
        stackView.distribution = UIStackView.Distribution.fillProportionally
        stackView.alignment = UIStackView.Alignment.bottom
        stackView.spacing = 12
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return stackView
    }()
    
    
    //Scheduler
    lazy var scheduleEditButton:UIButton = {
        let iv = UIButton()
        //NiceImageView(image: UIImage(named: "square.and.pencil"))
        iv.setImage(UIImage(systemName: "square.and.pencil")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        iv.tintColor = UIColor(named: "tintIconsColor")
        iv.addTarget(self, action: #selector(schedulerOpen), for: .touchUpInside)
        return iv
    }()
    lazy var labelFirstGoesOff:SmallTextLabel = {
        let label = SmallTextLabel(title: NSLocalizedString("NEVCFirstGoesOff", comment: "First goes off: "))
        label.appendValue(value: "10/11/2018 11:30")
        return label
    }()
    
    lazy var labelRepeatSequence:SmallTextLabel = {
        let label = SmallTextLabel(title: NSLocalizedString("NEVCThenRepeat", comment: "Then repeat: "))
        label.appendValue(value: "Every 1 month; for ever")
        return label
    }()
    
    lazy var schedulerPickerViewContainer:IsmCardView = {
        let view = IsmCardView()
        
        view.height(50)
        view.isHidden = true
        view.addSubview(scheduleEditButton)
        view.addSubview(labelFirstGoesOff)
        view.addSubview(labelRepeatSequence)
        scheduleEditButton.leftToSuperview(offset: 10)
        scheduleEditButton.verticalToSuperview()
        labelFirstGoesOff.leftToSuperview(offset: 45)
        labelFirstGoesOff.topToSuperview(offset:7)
        labelFirstGoesOff.rightToSuperview(offset:10)
        
        labelRepeatSequence.leftToSuperview(offset: 45)
        labelRepeatSequence.topToBottom(of: labelFirstGoesOff)
        labelRepeatSequence.rightToSuperview(offset:10)
        
        return view
    }()
    
   
    lazy var stackContent:UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [
                                                        descriptionLabelStackView,
                                                        descInputCompisit,
                                                        amountStackView,
                                                       
                                                       recurringTransactionStackView,
                                                       dateStackView,
                                                       schedulerPickerViewContainer,
                                                       accountPayerStackView])
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
    
    
    static var viewIdentifier:String = "NewIncomeViewController"
    var payerPicker:BoxPicker!
    var accountPicker:BoxPicker!
    var firestoreRef: Firestore!
    var pref:MyPreferences!
    var dateSelector:CompleteDatePicker!
    var dateformat: Utils!
    var transactionDateValue: Date!
    var accountValue: String!
    var PayerValue: String!
    var mIncome:Income!
    var mIncomeCopy:Income!
    //var firstGoOffSelector:CalendarPicker!
    var schedulePicker:SchedulePicker!
    var mAccountItems:[PickerItem] = []
    var mPayerItems:[PickerItem] = []
    var textSuggestion:[String] = []
    var appDelegate:AppDelegate!
    var flavor:Flavor!
    var currentTag:Int = -1
    var minDate:Date!
    var maxDate:Date!
    var mSchedule:Schedule!
    var mScheduleCopy:Schedule!
    var validator:Validator!
    var ideaList:[IdeaRow] = []
   
    var budgetGid:String!
    var allowOutOfRange:Bool = false
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if budgetGid == nil && mSchedule != nil {
            //self.navigationController?.popViewController(animated: true)
            self.dismissPage()
        }
        self.setUpActivity()
        self.layoutComponent()
        self.setupValidator()
        self.setupInitialState()
        
        self.payerPicker = BoxPicker()
        self.accountPicker = BoxPicker()
        self.pullPayers()
        self.pullAccounts()
        
        self.loadSuggestions()
        
       
    }
    func loadSuggestions() {
        var budgetSections:[BudgetSection] = [BudgetSection]()
        if(NSLocalizedString("userLang", comment: "lang") == "fr") {
            budgetSections = BudgetUtil.readTemplateFile(filename: "personnal_budget-fr")
           
        }else {
            budgetSections = BudgetUtil.readTemplateFile(filename: "personnal_budget")
        }
        ideaList = [IdeaRow]()
        for item in budgetSections {
            if item.type == .income {
                ideaList.append(IdeaRow(forId: "", andName: item.title))
            }
            
        }
        
        ideaList = ideaList.sorted(by: {$0.name < $1.name})
        
        if ideaList.count > 0 {
            ideaImage.isHidden = false
        } else {
            ideaImage.isHidden = true
        }
    }
    
    @objc func ideaTapped() {
        let vc = IdeasPickerViewController(nibName: "IdeasPickerViewController", bundle: nil)
        vc.ideaList = ideaList
        vc.delegate = self
        
        self.present(vc, animated: true, completion: nil)
    }
    func onIdeaSeleted(value: IdeaRow) {
        txtDescription.text = value.name
    }
    
    func setupInitialState() {
        
        minDate = params["minDate"] as? Date
        maxDate = params["maxDate"] as? Date
        if params["income"] != nil {
            mIncome = Income(dataMap: params["income"] as! [String:Any])
            mIncomeCopy = Income(dataMap: params["income"] as! [String:Any])
            
        }else{
            mIncome = Income(dataMap: [:])
        }
        
        if params["schedule"] != nil {
            mSchedule = Schedule(dataMap: params["schedule"] as! [String:Any])
            mScheduleCopy = Schedule(dataMap: params["schedule"] as! [String:Any])
            // If it is an update fill out form with existing values
            
        } else{
            self.mSchedule = self.defaultSchedule()
        }
        
 
        var defaultDate = Date()
        if(Int(defaultDate.timeIntervalSince1970) < Int(minDate.timeIntervalSince1970)) {
            defaultDate = minDate
            
        } else if(Int(defaultDate.timeIntervalSince1970) > Int(maxDate.timeIntervalSince1970)) {
            defaultDate = maxDate
            
        }
        
        dateSelector = CompleteDatePicker()
        dateSelector.setUp(widthSize: Int(self.view.frame.width), heightSize: 200, displayToday: false, associatedView: txtTransactionDate)
        dateSelector.onDateSelected(listenerDate: {date in
            self.txtTransactionDate.text = UtilsIsm.DateFormat(date: date, format: self.pref.getDateFormat())
        })
        
        if(!allowOutOfRange){
            self.dateSelector.minimumDate = minDate
            self.dateSelector.maximumDate = maxDate
        }
        
        self.dateSelector.date = defaultDate
        self.txtTransactionDate.text = UtilsIsm.DateFormat(date: defaultDate, format: self.pref.getDateFormat())
        
    
        // Setup and render default recurring transaction
        
        self.scheduleRender(schedule: self.mSchedule)
        
        
        if self.mSchedule.gid! != "" {
            self.setupForSchedulerUpdate(schedule: self.mSchedule)
            recurringTransactionStackView.isHidden = true
            
        }
        if self.mIncome.gid! != "" {
            self.setupForUpdate(income: mIncome)
            recurringTransactionStackView.isHidden = true
        }
        
        
    }
    func setupForUpdate(income:Income) {
        self.title = NSLocalizedString("newIncomeEdit", comment: "Edit Income")
        self.txtDescription.text = income.title
        self.txtAmount.text = "\(income.amount!)"
        //self.txtTransactionDate.date = Date(timeIntervalSince1970: Double(income.transaction_date))
        self.txtTransactionDate.text =  UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(income.transaction_date)), format: self.pref.getDateFormat())
        self.dateSelector.date =  Date(timeIntervalSince1970: Double(income.transaction_date))
    }
    
    func setupForSchedulerUpdate(schedule: Schedule) {
        self.title = NSLocalizedString("newIncomeEdit", comment: "Edit Income")
        self.mIncome = Income()
        self.mIncome.fromAnyObject(value: schedule.transaction_str ?? [:])
        self.txtDescription.text = self.mIncome.title
        self.txtAmount.text = "\(self.mIncome.amount!)"
        //self.txtTransactionDate.date = Date(timeIntervalSince1970: Double(self.mIncome.transaction_date))
        self.txtTransactionDate.text =  UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(self.mIncome.transaction_date)), format: self.pref.getDateFormat())
        self.dateSelector.date = Date(timeIntervalSince1970: Double(self.mIncome.transaction_date))
        self.recurringTransactionStackView.isHidden = true
        self.schedulerPickerViewContainer.isHidden = false
        self.dateStackView.isHidden = true
        self.scheduleRender(schedule:schedule)
    }
    func setUpActivity() {
        
        flavor = Flavor()
        pref = MyPreferences()
        mSchedule = Schedule()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.firestoreRef = appDelegate.firestoreRef
        //

        self.navigationItem.leftBarButtonItem  = cancelButton
        self.navigationItem.rightBarButtonItem = saveButton
        self.title = NSLocalizedString("NIVCAddIncome", comment: "Add Income")
    }
    
    func layoutComponent() {
        
        self.view.addSubview(contentScroll)
        contentScroll.addSubview(stackFormContent)
        
    }
    func setupValidator() {
        
        self.validator = Validator()
        self.validator.registerField(txtDescription, errorLabel: labelDescriptionError, rules: [RequiredRule(message: NSLocalizedString("text_required", comment: "Required"))])
    }
    
    @objc func enableRecurringTransaction(_ sender: UISwitch){
        let pref = AccessPref()
        if !pref.isProAccount() {
            displayUpgrade()
            sender.isOn = false
            
        }
        
        if sender.isOn {
            schedulerPickerViewContainer.isHidden = false
            dateStackView.isHidden = true
        }else {
            schedulerPickerViewContainer.isHidden = true
            dateStackView.isHidden = false
        }
    }
    @objc func schedulerOpen()  {
        
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
    
    
    func pullPayers()  {
        
        self.mPayerItems = []
        var selectedItem = -1
        var index = 0
        let payers = appDelegate.getPayers()
        
        for payer in payers{
        
            self.mPayerItems.append(PickerItem(id: 0, gid: payer.gid, title: payer.name)!)
            if self.mIncome.payer_gid != "" && payer.gid == self.mIncome.payer_gid {
                selectedItem = index
                
                self.txtPayer.text = payer.name
            }
            index += 1
        
        }
        
        self.payerPicker.setUp(widthSize: Int(self.view.frame.width), heightSize: 220, items: self.mPayerItems, inputText: self.txtPayer as UITextField, inputTextErr: UILabel())
        self.txtPayer.inputView = self.payerPicker
        self.txtPayer.inputAccessoryView = self.payerPicker.toolBar
        self.payerPicker.setSelected(index: selectedItem)
        
    }
    
    
    func pullAccounts() {
        
        let accounts = appDelegate.getAccounts()
        self.mAccountItems = []
        var selectedItem = -1
        var index = 0
        
        for account in accounts{
        
            self.mAccountItems.append(PickerItem(id: 0, gid: account.gid, title: account.name)!)
            if self.mIncome.account_gid != "" && account.gid == self.mIncome.account_gid {
                selectedItem = index
                self.txtAccount.text = account.name
                
            }
            index += 1
        }
        
        self.accountPicker.setUp(widthSize: Int(self.view.frame.width), heightSize: 220, items: self.mAccountItems, inputText: self.txtAccount, inputTextErr: UILabel())
        self.txtAccount.inputView = self.accountPicker
        self.txtAccount.inputAccessoryView = self.accountPicker.toolBar
        self.accountPicker.setSelected(index: selectedItem)
    }
    
    @objc func cancel(_ sender: AnyObject) {
        
        //appDelegate.navigateTo(instance: ViewController())
        //self.navigationController?.popViewController(animated: true)
        self.dismissPage()
        
        
    }
    func validationSuccessful() {
        
        if self.txtAmount.text == ""  {
            self.txtAmount.text = NSLocalizedString("newIncomeZero", comment: "0.0")
        }

        let fbIncome = FbIncome(reference: self.firestoreRef)

        mIncome.amount =  UtilsIsm.readNumberInput(value: self.txtAmount.text!)
        
        if  mIncome.amount == nil {
            mIncome.amount = 0.0
        }
        
        
        mIncome.title = txtDescription.text!
        mIncome.active = 1
        mIncome.payer_gid = payerPicker.getGid()
        mIncome.account_gid = accountPicker.getGid()
        mIncome.transaction_date = Int(dateSelector.date.timeIntervalSince1970)
        
        
        if !recurringTransactionSwitch.isOn && mSchedule.gid == "" {
            mIncome.budget_gid = budgetGid
            mIncome.user_gid = pref.getUserIdentifier()
            if mIncome.gid != "" {
                
                mIncome.last_update = Int(Date().timeIntervalSince1970)
                fbIncome.update(mIncome, completion: {(income) in
                    self.returnDashboad()
                }, error_message: {(error) in
                    self.returnDashboad()
                })
                
                
            } else {
                
                mIncome.insert_date = Int(Date().timeIntervalSince1970)
                fbIncome.write(mIncome, completion: {(income) in
                    self.returnDashboad()
                }, error_message: {(error) in
                    self.returnDashboad()
                })
                
                
            }
            
            
            
        } else{
            saveSchedule(income: mIncome)
            
        }
        
        
    }
    
    func returnDashboad() {
        //self.appDelegate.navigateTo(instance: ViewController())
        //self.navigationController?.popViewController(animated: true)
        self.dismissPage()
        
    }
    func saveSchedule(income:Income) {
        
        let fbSchedule:FbSchedule = FbSchedule(reference: self.firestoreRef)
        
        mSchedule.active = 1;
        mSchedule.transaction_title = income.title!
        mSchedule.transaction_str = income.toAnyObject()
        
        if mSchedule.gid != "" {
            
            mSchedule.last_update = Int(Date().timeIntervalSince1970)
            _=fbSchedule.update(mSchedule, completion: {(schedule) in
                
            }, error_message: {(error) in
                print(error)
            })
        }else {
            
            mSchedule.user_gid = self.pref.getUserIdentifier()
            mSchedule.transaction_type = Scheduler.TRANSACTION_TYPE_INCOME
            mSchedule.insert_date = Int(Date().timeIntervalSince1970)
            fbSchedule.write(mSchedule, completion: {(schedule) in
                
            }, error_message: {(error) in
                print(error)
            })
        }
        
        
        self.navigationController?.pushViewController(RecurringTransactionViewController(), animated: true)
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
    @objc func save(_ sender: AnyObject) {
        
        self.validator.validate(self)
        
        
    }
    
    
    
    func displayUpgrade() {
        IsmUtils.promtForPro(navContoller: self, featureName: NSLocalizedString("txtProfeatureBody", comment: ""))

    }
    
    func dateSelected(tag:Int, cancel:Bool) {
        
        self.txtTransactionDate.resignFirstResponder()
        if !cancel {
           // self.txtTransactionDate.text = Utils.formatTimeStamp(Int(dateSelector.date.timeIntervalSince1970))
        }
        
    }
    
    func scheduleSelected(schedule: Schedule) {
        self.scheduleRender(schedule:schedule)
        self.mSchedule = schedule
    }
    
    func scheduleRender(schedule:Schedule) {
        let timeStr = Utils.timeFormat(Int(schedule.nextOccurred))
        let dateStr = Utils.formatTimeStamp(Int(schedule.nextOccurred))
        labelRepeatSequence.appendValue(value: schedule.verboseSchedule())
        labelFirstGoesOff.appendValue(value: "\(dateStr) \(timeStr)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.currentTag = textField.tag
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("text_done", comment: "done"), style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))
        
        doneToolbar.barStyle = UIBarStyle.default
        doneToolbar.isTranslucent = true
        doneToolbar.tintColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        doneToolbar.sizeToFit()
        doneToolbar.setItems([flexSpace, done], animated: true)
        doneToolbar.sizeToFit()
        doneToolbar.isUserInteractionEnabled = true
        
        self.txtDescription.inputAccessoryView = doneToolbar
        self.txtAmount.inputAccessoryView = doneToolbar
        
        
    }
    
    func dismissPage(){
        self.dismiss(animated: true)
    }
    
    @objc func doneButtonAction () {
        
        switch self.currentTag {
        case 1:
            self.txtDescription.resignFirstResponder()
            break
        case 2:
            self.txtAmount.resignFirstResponder()
            break
        default:
            break
        }
    }
    
}
