//
//  NewCategoryViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 6/18/16.
//  Copyright © 2016 UlmatCorpit. All rights reserved.
//

import UIKit
import Firebase
import SwiftValidator
import SearchTextField
import FirebaseFirestore
import TinyConstraints
import ISMLBase
import ISMLDataService
import ToolsBoxModule


fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class NewCategoryViewController: BaseViewController, UITextFieldDelegate, ValidationDelegate, CalDelegate, IdeaSelectDelegate {
    
    
    
    
    
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
    
    //text_amount_budget
    lazy var labelAmountBudget: NiceLabel = {
        let label = NiceLabel(title: NSLocalizedString("text_amount_budget", comment: "Amount Budgeted"))
        return label
    }()
   
    lazy var planned:NiceTextField = {
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
        icomp.addSubview(planned)
        planned.topToSuperview()
        planned.leftToSuperview()
        planned.bottomToSuperview()
        icomp.addSubview(calculatorImage)
        calculatorImage.rightToSuperview(offset: -5)
        calculatorImage.centerYToSuperview()
        calculatorImage.leftToRight(of: planned)
        return icomp
    }()
    
    lazy var stackContent:UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [
            descriptionLabelStackView,
            descInputCompisit,
            labelAmountBudget,
            amountInputCompisit])
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
    
    var minDate:Date!
    var maxDate:Date!
    static var viewIdentifier:String = "NewCategoryViewController"
    
    var mCategory:BudgetCategory!
    
    var firestoreRef: Firestore!
    var pref:MyPreferences!
    
    //var mySearchTextField = SearchTextField(frame: CGRect(x: 10, y: 100, width: 200, height: 40))
    var textSuggestion:[String] = []
    var appDelegate:AppDelegate!
    var flavor:Flavor!
    var validator:Validator!
    
    var currentTag:Int = -1
    
    var ideaList:[IdeaRow] = []
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setUpActivity()
        self.layoutComponent()
        self.setupValidator()
        self.setupInitialState()
        
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
            if item.type == .category {
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
        
        
        if params["category"] != nil {
            mCategory = BudgetCategory(dataMap: params["category"] as! [String:Any])
            
            
        }else{
            mCategory = BudgetCategory(dataMap: [:])
        }

        if self.mCategory.gid! != "" {
            self.txtDescription.text = mCategory.title
            self.planned.text = "\(mCategory.amount!)"
            self.title = NSLocalizedString("text_edit_category", comment: "Edit Category")
        }
        textSuggestion = appDelegate.getCategorieSuggestion()
        
    }
    
    func setUpActivity() {
        
        flavor = Flavor()
        pref = MyPreferences()
       
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.firestoreRef = appDelegate.firestoreRef

//        self.navigationController!.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.tintColor = flavor.getNavigationBarColor()
//        navigationController?.navigationBar.barTintColor = flavor.getPrimaryColor()
        //navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:flavor.getNavigationBarColor(), NSAttributedString.Key.font: UIFont(name: "Lato-Bold", size: 18)!]
        self.navigationItem.leftBarButtonItem  = cancelButton
        self.navigationItem.rightBarButtonItem = saveButton
        self.title = NSLocalizedString("text_add_category", comment: "Add Category")
    }
    
    func layoutComponent() {
        
        self.view.addSubview(contentScroll)
        contentScroll.addSubview(stackFormContent)
        
    }
    
    func setupValidator() {
        
        self.validator = Validator()
        self.validator.registerField(txtDescription, errorLabel: labelDescriptionError, rules: [RequiredRule(message: NSLocalizedString("text_required", comment: "Required"))])
    }
    
    @objc func cancel(_ sender: AnyObject) {
        
        //appDelegate.navigateTo(instance: ViewController())
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    func validationSuccessful() {
        let pref = MyPreferences()
        let fbCategory: FbCategory = FbCategory(reference: self.firestoreRef)
        
        if self.planned.text! == "" {
            self.planned.text = "0.0"
        }
        //Go to budget
        
        mCategory.amount = UtilsIsm.readNumberInput(value: self.planned.text!)
//        if let number = number {
//            mCategory.amount = Double(truncating: number)
//        }
        
        //let category = Category()
        
        mCategory.category_gid = ""
        mCategory.user_gid = pref.getUserIdentifier()
        mCategory.budget_gid = appDelegate.selectedBudgetGid
        mCategory.category_root = ""
        mCategory.type = 0
        mCategory.title = self.txtDescription.text!
        //mCategory.amount = Double(self.planned.text!)!
        mCategory.spent = 0.0
        mCategory.comment = ""
        mCategory.active = 1
        
        
        
        
        if mCategory.gid != "" {
            
            mCategory.insert_date = Int(Date().timeIntervalSince1970)
            fbCategory.update(mCategory, completion: {(category) in
                
                print("Save category")
            }, error_message: {(error) in
                print(error)
                // self.goToCategoryDetails ()
            })
            //self.goToCategoryDetails ()
            //self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true)
            
        } else {
            mCategory.last_update = Int(Date().timeIntervalSince1970)
            fbCategory.write(mCategory, completion: {(category) in
                
                print("Update category")
            }, error_message: {(error) in
                print(error)
                //self.returnDashboad()
            })
            //self.returnDashboad()
            //self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true)
            
            
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
    
    @objc func save(_ sender: AnyObject) {
        
        self.validator.validate(self)

    }
    func returnDashboad() {
        appDelegate.navigateTo(instance: ViewController())
        
    }
    
    func goToCategoryDetails () {
    
        let params:NSDictionary = ["minDate": minDate,
                                   "maxDate": maxDate,
                                   "categoryGid": mCategory.gid]
        
        appDelegate.navigateTo(instance: CategoryDetailsViewController(), params: params)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.currentTag = textField.tag
    }
    
    @objc func calculatorTapped(tapGestureRecognizer: UITapGestureRecognizer) {
       
        let cal = TBUtils.getCalculator()
        cal.delegate = self
        self.present(cal, animated: true, completion: nil)
    }
    func onCalResult(value: String) {
        self.planned.text = value
    }
    
    @objc func doneButtonAction () {
        
        switch self.currentTag {
        case 1:
            self.txtDescription.resignFirstResponder()
            break
        case 2:
            self.planned.resignFirstResponder()
            break
        default:
            break
        }
    }
}
