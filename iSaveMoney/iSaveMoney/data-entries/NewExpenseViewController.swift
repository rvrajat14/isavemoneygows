//
//  NewExpenseViewController.swift
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
import ISMLDataService
import ISMLBase
import ToolsBoxModule
import CheckoutModule

//import SearchTextField

class NewExpenseViewController: BaseViewController, UITextFieldDelegate, ModalSchedulerDelegate, DateDelegate, CalDelegate, ValidationDelegate, IdeaSelectDelegate, BoxPickDelegate {
    func onItemSeleted(value: PickerItem) {
        self.loadSuggestions(forCategory: value.title)
    }
    func onClearSeleted() {
        self.loadSuggestions(forCategory: "")
    }
    
//    func scheduleSelected(schedule: ScheduleModel) {
//
//        self.scheduleRender(schedule:schedule)
//        self.mSchedule = schedule
//    }
    
    func scheduleSelected(schedule: ScheduleModel) {
        self.mSchedule.copyFromDictionary(value: schedule.toAnyObject())
        self.scheduleRender(schedule:self.mSchedule)
    }
    
    func dateSelected(tag: Int, cancel: Bool) {
        self.textDate.resignFirstResponder()
        if !cancel {
            //self.textDate.text = Utils.formatTimeStamp(Int(dateSelector.date.timeIntervalSince1970))
            
        }
    }
    

    var firestoreRef: Firestore!
    var pref: MyPreferences!
    
    var minDate:Date!
    var maxDate:Date!
    //var expenseGid:String!
    //var scheduleGid:String!
    //var initialCategory:String!
    
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
    
    lazy var selectCategoryLabel: NiceLabel = {
        let label = NiceLabel(title: NSLocalizedString("NEVCPickCategory", comment: "Pick a category"),
                              insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        //label.text = NSLocalizedString("NEVCPickCategory", comment: "Pick a category")
        label.appendValue(value: "*")
        label.setCompressionResistance(.defaultHigh, for: .horizontal)
        return label
    }()
    lazy var selectCategoryError: ErrorLabel = {
        let label = ErrorLabel(title: NSLocalizedString("NEVCRequired", comment: "Required"),
                               insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        label.isHidden = true
        return label
    }()
    lazy var selectCategory: TextFieldPickerInput = {
        let textfield = TextFieldPickerInput(placeholder: NSLocalizedString("NEVCSelectCategory", comment: "Select a category..."),
                                      insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 30))
        textfield.tag = 1
        //textfield.isEnabled = false
        return textfield
    }()
    
    lazy var categoryLabelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [selectCategoryLabel, selectCategoryError])
        stackView.axis = .horizontal
        stackView.distribution = UIStackView.Distribution.fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 6
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return stackView
    }()
   
    lazy var labelDescription: NiceLabel =  {
        let label = NiceLabel(title: NSLocalizedString("NEVCDescription", comment: "Description"))
        return label
    }()
    
    lazy var textDescription: NiceTextField = {
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
        icomp.addSubview(textDescription)
        textDescription.topToSuperview()
        textDescription.leftToSuperview()
        textDescription.bottomToSuperview()
        icomp.addSubview(ideaImage)
        ideaImage.rightToSuperview(offset: -5)
        ideaImage.centerYToSuperview()
        ideaImage.leftToRight(of: textDescription)
        return icomp
    }()
    
    
    lazy var descriptionStackView: UIStackView  = {
        let stackView = UIStackView(arrangedSubviews: [labelDescription, descInputCompisit])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 6
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return stackView
    }()
    
   
    lazy var labelAmount: NiceLabel = {
        let label = NiceLabel(title: NSLocalizedString("NEVCAmount", comment: "Amount"))
        return label
    }()
    //Set currency
    
    lazy var textAmount:NiceTextField = {
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
        return iw
    }()
    
    lazy var amountInputCompisit: InputBackgroundView = {
        let icomp = InputBackgroundView()
        icomp.addSubview(textAmount)
        textAmount.topToSuperview()
        textAmount.leftToSuperview()
        textAmount.bottomToSuperview()
        icomp.addSubview(calculatorImage)
        calculatorImage.rightToSuperview(offset: -5)
        calculatorImage.centerYToSuperview()
        calculatorImage.leftToRight(of: textAmount)
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

    
    lazy var labelDate:NiceLabel = {
        let label = NiceLabel(title: NSLocalizedString("NEVCTransactionDate", comment: "Transaction date"))
        return label
    }()
    lazy var textDate:TextFieldDateInput = {
        let textfield = TextFieldDateInput()
        return textfield
    }()
    lazy var dateStackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelDate,textDate])
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
   
    lazy var labelPayee:NiceLabel = {
        let label = NiceLabel(title: NSLocalizedString("NEVCPayee", comment: "Payee (optional)"))
        return label
    }()
    lazy var txtPayee:NiceTextField  = {
        let textfield = NiceTextField(placeholder: NSLocalizedString("NEVCSelect", comment: "Select"),
                                      insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 30))
        textfield.rightView = TxtImageView(image: UIImage(named: "right_chevron"))
        textfield.rightViewMode = UITextField.ViewMode.always
        //textfield.isEnabled = false
        return textfield
    }()
    
    lazy var labelNote:NiceLabel = {
        let label = NiceLabel(title: NSLocalizedString("text_notes", comment: "Notes"))
        return label
    }()
    lazy var txtNote:IsmTextNote  = {
        let textfield = IsmTextNote(placeholder: NSLocalizedString("hint_type_here", comment: "Type here"))
    
        return textfield
    }()
   
    lazy var advancedStackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelAccount,txtAccount,labelPayee,txtPayee, labelNote, txtNote])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 6
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return stackView
    }()
    
    
    
    lazy var buttonMore: ButtonAdvanceOptions = {
        let btn = ButtonAdvanceOptions()
        btn.width(min: 100, max: 110, priority: .defaultHigh, isActive: true)
        return btn
    }()
    lazy var advanceButton:UIView = {
        let vw = UIView()
        vw.backgroundColor = .clear
        vw.height(52)
        vw.addSubview(buttonMore)
        let sep = UIView()
        sep.backgroundColor = UIColor(named: "seperatorColor")
        sep.height(1)
        vw.addSubview(sep)
        buttonMore.leftToSuperview()
        buttonMore.centerYToSuperview()
        sep.rightToSuperview()
        sep.centerYToSuperview()
        sep.leftToRight(of: buttonMore)
        return vw
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
        var stackView = UIStackView(arrangedSubviews: [categoryLabelStackView,
                                                       selectCategory,
                                                       descriptionStackView,
                                                       amountStackView,
                                                       recurringTransactionStackView,
                                                       dateStackView,
                                                       schedulerPickerViewContainer,
                                                       advanceButton,
                                                       advancedStackView])
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
                               action:  #selector(self.save(_:)))
    }()
    
   
    static var viewIdentifier:String = "NewExpenseViewController"
    
    var currentTag:Int = -1
    
    //Date selector
    
    var categoryPicker:BoxPicker!
    var payeePicker:BoxPicker!
    var accountPicker:BoxPicker!
    //var dateSelector:CalendarPicker!
    var datePicker:CompleteDatePicker!
    
    var mExpense:Expense!
    var mExpenseCopy:Expense!
    var mSchedule:Schedule!
    var mScheduleCopy:Schedule!
    
    var mAccountItems:[PickerItem] = []
    var mPayeeItems:[PickerItem] = []
    var mCategoryItems:[PickerItem] = []
    
    var categories:[BudgetCategory] = []
    
    var textSuggestion:[String] = []
    var flavor:Flavor!
    var appDelegate:AppDelegate!
    
    
    lazy var viewControllerNavController:UINavigationController = {
        
        let cv:ModalScheduler = ModalScheduler()
        let nav = UINavigationController(rootViewController: cv)
        return nav
    }()

    
    //var schedule:Schedule!
    var validtor:Validator!
    var ideaList:[IdeaRow]!
    
    var budgetGid:String!
    var allowOutOfRange:Bool = false
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if budgetGid == nil && mSchedule != nil {
            //self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true)
        }
        
        self.setUpActivity()
        self.layoutComponent()
        self.setupValidator()
        self.setupInitialState()
        
        self.categoryPicker = BoxPicker()
        self.payeePicker = BoxPicker()
        self.accountPicker = BoxPicker()
        
        self.pullPayees()
        self.pullAccounts()
        self.setUpCategory()

        textSuggestion = appDelegate.getItemsSuggestion()
       
        setButtonState(state: !self.pref.getAddExpMode())
        buttonMore.addTarget(self, action: #selector(toggleAdvance), for: .touchUpInside)
        
    }
    
    func loadSuggestions(forCategory: String) {
        var budgetSections:[BudgetSection] = [BudgetSection]()
        if(NSLocalizedString("userLang", comment: "lang") == "fr") {
            budgetSections = BudgetUtil.readTemplateFile(filename: "personnal_budget-fr")
           
        }else {
            budgetSections = BudgetUtil.readTemplateFile(filename: "personnal_budget")
        }
        ideaList = [IdeaRow]()
        for item in budgetSections {
            if item.type == .category {
                if item.title == forCategory {
                    for inItem in item.items {
                        ideaList.append(IdeaRow(forId: "", andName: inItem))
                    }
                }
                
            }
            
        }
        
        let container = appDelegate.persistentContainer
        let expenseList:[CaheExpenses] = IdeaExpensesHelper.getLastTen(viewContext: container.viewContext, forCategory: forCategory)
        
        for item in expenseList {
            if ideaList.filter({$0.name == item.expenseName}).count <= 0 {
                ideaList.append(IdeaRow(forId: item.expenseName!, andName: item.expenseName!))
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
        textDescription.text = value.name
    }
    
    func setButtonState(state: Bool) {
        self.advancedStackView.isHidden = !state
        let textDisp = self.advancedStackView.isHidden ? NSLocalizedString("text_advance", comment: "Advanced"): NSLocalizedString("text_simple", comment: "Simple")
        self.buttonMore.setTitle(textDisp, for: .normal)
        self.pref.setAddExpMode(forValue: !state)
    }
    
    @objc func toggleAdvance(){
        print("Toggle now ")
        setButtonState(state: self.advancedStackView.isHidden)
    }
    
    func setupInitialState() {

        minDate = params["minDate"] as? Date
        maxDate = params["maxDate"] as? Date
        let initialCategory:String = (params["initialCategory"] != nil) ? (params["initialCategory"] as! String) : ""
        if params["expense"] != nil {
            mExpense = Expense(dataMap: params["expense"] as! [String:Any])
            mExpenseCopy = Expense(dataMap: params["expense"] as! [String:Any])
            
        }else{
            mExpense = Expense(dataMap: [:])
            mExpense.category_gid = initialCategory
        }
        
        if params["schedule"] != nil {
            mSchedule = Schedule(dataMap: params["schedule"] as! [String:Any])
            mScheduleCopy = Schedule(dataMap: params["schedule"] as! [String:Any])
            // If it is an update fill out form with existing values
          
        } else{
            self.mSchedule = self.defaultSchedule()
        }
        
        //initialCategory = mExpense.gid!
        categories  = appDelegate.getCategoriesList()
        
        
    
        //Date can't be out of date range
        var defaultDate = Date()
        if(Int(defaultDate.timeIntervalSince1970) < Int(minDate.timeIntervalSince1970)) {
            defaultDate = minDate
           
        }else if(Int(defaultDate.timeIntervalSince1970) > Int(maxDate.timeIntervalSince1970)) {
            defaultDate = maxDate
            
        }
        
        datePicker = CompleteDatePicker()
        datePicker.setUp(widthSize: Int(self.view.frame.width), heightSize: 200, displayToday: false, associatedView: textDate)
        datePicker.onDateSelected(listenerDate: {date in
            self.textDate.text = UtilsIsm.DateFormat(date: date, format: self.pref.getDateFormat())
        })
        
        
        
        if(!allowOutOfRange){
            datePicker.minimumDate = minDate
            datePicker.maximumDate = maxDate
        }
        datePicker.date = defaultDate
        self.textDate.text = UtilsIsm.DateFormat(date: defaultDate, format: self.pref.getDateFormat())
        
        
        // Setup and render default recurring transaction
        
        self.scheduleRender(schedule: self.mSchedule)
        
        
        if self.mSchedule.gid! != "" {
            recurringTransactionStackView.isHidden = true
            self.setupForSchedulerUpdate(schedule: self.mSchedule)
            self.selectCategory.isEnabled = false
        }
        if self.mExpense.gid! != "" {
            recurringTransactionStackView.isHidden = true
            self.setupForUpdate(expense: mExpense)
        }
        
        
    }
    
    func setupForUpdate(expense:Expense) {
        self.title = NSLocalizedString("newExpenseEdit", comment: "Edit Expense")
        self.textDescription.text = expense.title
        self.textAmount.text = "\(expense.amount!)"
        self.txtNote.text = expense.comment!
        //self.textDate.date = Date(timeIntervalSince1970: Double(expense.transaction_date))
        self.textDate.text =  UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(expense.transaction_date)), format: self.pref.getDateFormat())
        self.datePicker.date = Date(timeIntervalSince1970: Double(expense.transaction_date))
    }
    
    func setupForSchedulerUpdate(schedule: Schedule) {
        self.title = NSLocalizedString("newExpenseEdit", comment: "Edit Expense")
        self.mExpense = Expense()
        self.mExpense.fromAnyObject(value: schedule.transaction_str ?? [:])
        self.selectCategory.text = self.mExpense.category_str
        self.loadSuggestions(forCategory: self.mExpense.category_str)
        self.textDescription.text = self.mExpense.title
        self.txtNote.text = self.mExpense.comment
        self.textAmount.text = "\(self.mExpense.amount!)"
        //self.textDate.date = Date(timeIntervalSince1970: Double(self.mExpense.transaction_date))
        self.textDate.text =  UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(self.mExpense.transaction_date)), format: self.pref.getDateFormat())
        self.datePicker.date = Date(timeIntervalSince1970: Double(self.mExpense.transaction_date))
        self.recurringTransactionStackView.isHidden = true
        self.schedulerPickerViewContainer.isHidden = false
        self.dateStackView.isHidden = true
        self.scheduleRender(schedule:schedule)
    }
    
    @objc func calculatorTapped(tapGestureRecognizer: UITapGestureRecognizer) {
       
        let cal = TBUtils.getCalculator()
        cal.delegate = self
        self.present(cal, animated: true, completion: nil)
    }
    
    func setUpActivity() {
        
        flavor = Flavor()
        pref = MyPreferences()
        mSchedule = Schedule()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.firestoreRef = appDelegate.firestoreRef

        self.navigationItem.leftBarButtonItem  = cancelButton
        self.navigationItem.rightBarButtonItem = saveButton
        self.title = NSLocalizedString("NEVCAddExpense", comment: "Add Expense")
    }
    
    func layoutComponent() {
        
        self.view.addSubview(contentScroll)
        contentScroll.addSubview(stackFormContent)
        
    }
    
    func setupValidator() {
        
        self.validtor = Validator()
        self.validtor.registerField(selectCategory, errorLabel: selectCategoryError, rules: [RequiredRule(message: NSLocalizedString("text_required", comment: "Required"))])
    }
    
    @objc func enableRecurringTransaction(_ sender: UISwitch){
        let pref = AccessPref()
       
        if (!pref.isProAccount()) {
            sender.isOn = false
            IsmUtils.promtForPro(navContoller: self, featureName: NSLocalizedString("txtProfeatureBody", comment: "") )
            return
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
        
        mSchedule = Schedule()
        mSchedule.transaction_type = Scheduler.TRANSACTION_TYPE_EXPENSE
        mSchedule.type = ScheduleType.MONTHLY
        mSchedule.step = 1
        mSchedule.weeklyDay = -1
        mSchedule.monthlyOption = -1
        mSchedule.numberEvent = 2
        mSchedule.dateLimitOccur = 0
        mSchedule.typeMaxOccur = ScheduleCount.FOR_EVER
        mSchedule.setNextOccur(firstGoesOff: Int(Date().timeIntervalSince1970))
        mSchedule.setLastOccurred(mSchedule.nextOccurred)
        
        return mSchedule
    }
    
    
    func scheduleRender(schedule:Schedule) {
        
        let timeStr = Utils.timeFormat(Int(schedule.nextOccurred))
        let dateStr = Utils.formatTimeStamp(Int(schedule.nextOccurred))
        labelRepeatSequence.appendValue(value: schedule.verboseSchedule())
        labelFirstGoesOff.appendValue(value: "\(dateStr) \(timeStr)")
        
    }
    
    
    func onSelectRecurringTransaction(_ sender: UISegmentedControl) {
        let pref = AccessPref()
       
        if (!pref.isProAccount()) {
            recurringTransactionSwitch.isOn = false
            IsmUtils.promtForPro(navContoller: self, featureName: NSLocalizedString("txtProfeatureBody", comment: "") )
        }
        
       
    }
    
    
   
    
    func pullPayees()  {
        
        let payees = appDelegate.getPayees()
        self.mPayeeItems = []
        var selectedItem = -1
        var index = 0
        
        for payee in payees {
        
            self.mPayeeItems.append(PickerItem(id: 0, gid: payee.gid, title: payee.name)!)
            if self.mExpense.payee_gid != "" && payee.gid == self.mExpense.payee_gid {
                selectedItem = index
                
                self.txtPayee.text = payee.name
            }
            index += 1
        
        }
        
        self.payeePicker.setUp(widthSize: Int(self.view.frame.width), heightSize: 220, items: self.mPayeeItems, inputText: self.txtPayee as UITextField, inputTextErr: UILabel())
        self.txtPayee.inputView = self.payeePicker
        self.txtPayee.inputAccessoryView = self.payeePicker.toolBar
        self.payeePicker.setSelected(index: selectedItem)
        
    }
    
    
    func pullAccounts() {
        
        let accounts = appDelegate.getAccounts()
        
        self.mAccountItems = []
        var selectedItem = -1
        var index = 0
        
        for account in accounts {
        
            self.mAccountItems.append(PickerItem(id: 0, gid: account.gid, title: account.name)!)
            if self.mExpense.account_gid != "" && account.gid == self.mExpense.account_gid {
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
    
    func setUpCategory() {
        
        print("load category \(categories.count)")
        
        var mItems:[PickerItem] = []
        var selectedItem = -1
        var index = 0
        for category in categories {
        
            mItems.append(PickerItem(id: 0, gid: category.gid, title: category.title)!)
            
            if (self.mExpense.category_gid != "" && category.gid == self.mExpense.category_gid) {
                selectedItem = index
                self.selectCategory.text = category.title
                self.loadSuggestions(forCategory: category.title)
                
            }
            index += 1
        
        }
        self.categoryPicker.delegateSet = self
        self.categoryPicker.setUp(widthSize: Int(self.view.frame.width), heightSize: 220, items: mItems, inputText: self.selectCategory, inputTextErr: self.selectCategoryError)
        self.categoryPicker.setSelected(index: selectedItem)
        
    }

    
    @objc func cancel(_ sender: AnyObject) {
        
        //self.appDelegate.navigateTo(instance: ViewController())
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
        
    }
    
    @objc func save(_ sender: UIBarButtonItem) {
        
       self.validtor.validate(self)
        
        
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        // turn the fields to red
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
            }
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.isHidden = false
        }
    }
    
    func validationSuccessful() {
        
        let fbExpense = FbExpense(reference: self.firestoreRef)
       
        let pref = MyPreferences()
        
        mExpense.amount = UtilsIsm.readNumberInput(value: self.textAmount.text!)
        if mExpense.amount == nil {
            mExpense.amount = 0.0
        }
        
        
        
        mExpense.user_gid = pref.getUserIdentifier()
        if mSchedule.gid == "" {
            mExpense.category_gid = categoryPicker.getGid()
            mExpense.category_str = selectCategory.text!
        }
        if textDescription.text! == "" {
            textDescription.text = selectCategory.text!
        }
        
        mExpense.payee_gid = payeePicker.getGid()
        mExpense.payee_str = txtPayee.text!
        mExpense.account_gid = accountPicker.getGid()
        mExpense.account_str = txtAccount.text!
        mExpense.title = textDescription.text!
        mExpense.comment = txtNote.text!
        mExpense.active = 1
        mExpense.transaction_date = Int(datePicker.date.timeIntervalSince1970)
        
        
        if recurringTransactionSwitch.isOn || mSchedule.gid! != "" {
            
            saveSchedule(expense: mExpense)
            
            
        } else {
            mExpense.budget_gid = budgetGid
            if mExpense.gid != "" {
                
                mExpense.last_update = Int(Date().timeIntervalSince1970)
                fbExpense.update(mExpense, completion: {(expense) in
                    
                }, error_message: {(error) in
                    print(error)
                })
                //self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true)

                
            } else {
                
                mExpense.insert_date = Int(Date().timeIntervalSince1970)
                fbExpense.write(mExpense, completion: {(expense) in
                    
                }, error_message: {(error) in
                    print(error)
                })
                let container = appDelegate.persistentContainer
                IdeaExpensesHelper.insertExpense(viewContext: container.viewContext, forCategory: mExpense.category_str, andName: mExpense.title)
                //self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true)
                
            }
           
            
        }
    }
    
    func saveSchedule(expense:Expense) {
        
        let fbSchedule:FbSchedule = FbSchedule(reference: self.firestoreRef)
       
        mSchedule.active = 1;
        
        mSchedule.transaction_title = expense.title!
        mSchedule.transaction_str = expense.toAnyObject()
        
        if mSchedule.gid != "" {
            
            mSchedule.last_update = Int(Date().timeIntervalSince1970)
            _=fbSchedule.update(mSchedule, completion: {(schedule) in
                
            }, error_message: {(error) in
                print(error)
            })
        } else {
            
            mSchedule.user_gid = self.pref.getUserIdentifier()
            mSchedule.transaction_gid = expense.gid!
            mSchedule.transaction_type = Scheduler.TRANSACTION_TYPE_EXPENSE
            mSchedule.insert_date = Int(Date().timeIntervalSince1970)
            fbSchedule.write(mSchedule, completion: {(schedule) in
                
            }, error_message: {(error) in
                print(error)
            })
        }
        
        self.navigationController?.pushViewController(RecurringTransactionViewController(), animated: true)
    
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
    
    
    @objc func doneButtonAction () {
        
        switch self.currentTag {
            case 1:
                self.textDescription.resignFirstResponder()
                break
            case 2:
                self.textAmount.resignFirstResponder()
                break
            default:
                break
        }
    }

    func onCalResult(value: String) {
        self.textAmount.text = value
    }
    
}


