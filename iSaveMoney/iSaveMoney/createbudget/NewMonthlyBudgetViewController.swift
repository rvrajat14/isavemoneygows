//
//  NewMonthlyBudgetViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 6/9/16.
//  Copyright © 2016 UlmatCorpit. All rights reserved.
//

import UIKit
import Firebase
import SwiftValidator
import ISMLBase
import ISMLDataService
import ToolsBoxModule

class NewMonthlyBudgetViewController: BaseScreenViewController, DateDelegate, ValidationDelegate, CalDelegate {
    
    

    func dateSelected(tag: Int, cancel: Bool) {
        
        switch tag {
        case 1:
            
            self.startDate.resignFirstResponder()
            if cancel == false {
                self.startDate.text = dateFormatter.string(from: startDateSelector.date)
                self.startDateError.text = ""
                self.startDate.layer.borderWidth = 0.0
                
            }

            break
        case 2:
            
            self.endDate.resignFirstResponder()
            
            if cancel == false {
                self.endDate.text = dateFormatter.string(from: endDateSelector.date)
                self.endDateError.text = ""
                self.endDate.layer.borderWidth = 0.0
                
            
            }
           
            break
        default:
            break
        }
    }
    

    static var viewIdentifier:String = "NewMonthlyBudgetViewController"
    
    var startDateSelector:CalendarPicker!
    var endDateSelector:CalendarPicker!
    var budgetType:BudgetType = BudgetType.PERSONAL
    

    
    let months = [NSLocalizedString("January", comment: "January"),
        NSLocalizedString( "February", comment:  "February"),
        NSLocalizedString( "March", comment:  "March"),
        NSLocalizedString( "April", comment:  "April"),
        NSLocalizedString( "May", comment:  "May"),
        NSLocalizedString( "June", comment:  "June"),
        NSLocalizedString( "July", comment:  "July"),
        NSLocalizedString( "August", comment:  "August"),
        NSLocalizedString( "September", comment:  "September"),
        NSLocalizedString( "October", comment:  "October"),
        NSLocalizedString( "November", comment:  "November"),
        NSLocalizedString( "December", comment:  "December")]

    
    
    
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var startDateError: UILabel!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var endDateError: UILabel!
    @IBOutlet weak var newButton: ButtonWithArrow!
    @IBOutlet weak var advancedOptionsWrapper: UIStackView!
    @IBOutlet weak var advanceOptionsButton: UIButton!
    @IBOutlet weak var textInitialAmount: UITextField!
    @IBOutlet weak var textBugdetName: UITextField!
    @IBOutlet weak var swithEnableOutRange: UISwitch!
    @IBOutlet weak var openCalculator: UIButton!
    
    var dateFormatter: DateFormatter!
    var validator:Validator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("newBudget", comment: "New Budget")
        let cancelButton = UIBarButtonItem(image: UIImage(named: "back_icon"), landscapeImagePhone: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(cancel(_:)))
        self.navigationItem.leftBarButtonItem  = cancelButton
        
        self.startDateError.text = ""
        self.endDateError.text = ""

        self.pref = MyPreferences()
        // Create date formatter
        dateFormatter = DateFormatter()
        // Set date format
        dateFormatter.dateFormat = pref.getDateFormat().replacingOccurrences(of: "m", with: "M")
        
        print("Is selected \(swithEnableOutRange.isSelected)")
        swithEnableOutRange.isOn = false
        textInitialAmount.keyboardType = .decimalPad
        setButtonState(state: false)
        advanceOptionsButton.addTarget(self, action: #selector(toggleAdvance), for: .touchUpInside)
        
        
        let imageView = UIImageView()
        let image = UIImage(named: "right_chevron")
        imageView.image = image
        imageView.alpha = 0.5
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.gray
        imageView.frame = CGRect(x: 5, y: 0, width: 30, height: 30)
        
        let imageViewStartDate = UIImageView()
        imageViewStartDate.image = image
        imageViewStartDate.alpha = 0.5
        imageViewStartDate.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageViewStartDate.tintColor = UIColor.gray
        imageViewStartDate.frame = CGRect(x: 5, y: 0, width: 30, height: 30)
        startDate.rightView = imageViewStartDate
        startDate.rightViewMode = UITextField.ViewMode.always

        
        let imageViewEndDate = UIImageView()
        imageViewEndDate.image = image
        imageViewEndDate.alpha = 0.5
        imageViewEndDate.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageViewEndDate.tintColor = UIColor.gray
        imageViewEndDate.frame = CGRect(x: 5, y: 0, width: 30, height: 30)
        endDate.rightView = imageViewEndDate
        endDate.rightViewMode = UITextField.ViewMode.always

        newButton.imageView?.tintColor = UIColor.white
        newButton.tintColor = UIColor.white
        newButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        setUpPicker()
        
        self.validator = Validator()
        self.validator.registerField(startDate, errorLabel: startDateError, rules: [RequiredRule(message: NSLocalizedString("text_required", comment: "Required"))])
        self.validator.registerField(endDate, errorLabel: endDateError, rules: [RequiredRule(message: NSLocalizedString("text_required", comment: "Required")), ])
        
        openCalculator.addTarget(self, action: #selector(calculatorTapped), for: .touchUpInside)
    }
    
    @objc func calculatorTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let cal = TBUtils.getCalculator()
        cal.delegate = self
        self.present(cal, animated: true, completion: nil)
    }
    func onCalResult(value: String) {
        self.textInitialAmount.text = value
    }

    func setButtonState(state: Bool) {
        self.advancedOptionsWrapper.isHidden = !state
        let textDisp = self.advancedOptionsWrapper.isHidden ? NSLocalizedString("text_advance", comment: "Advanced"): NSLocalizedString("text_simple", comment: "Simple")
        self.advanceOptionsButton.setTitle(textDisp, for: .normal)
    }
    
    @objc func toggleAdvance(){
        print("Toggle now ")
        setButtonState(state: self.advancedOptionsWrapper.isHidden)
    }
    
    func setUpPicker() {
        
        ////date
        startDateSelector = CalendarPicker()
        self.startDateSelector.delegate = self
        self.startDateSelector.tag = 1
        startDateSelector.setUp(widthSize: Int(self.view.frame.width), heightSize: 220, selectedDate: Date(), displayToday: false, dformat: self.pref.getDateFormat())
        self.startDate.inputView = startDateSelector
        self.startDate.inputAccessoryView = startDateSelector.toolBar
        self.startDate.text = dateFormatter.string(from: startDateSelector.date)
       
        
        endDateSelector = CalendarPicker()
        self.endDateSelector.delegate = self
        self.endDateSelector.tag = 2
        endDateSelector.setUp(widthSize: Int(self.view.frame.width), heightSize: 220, selectedDate: (Date()+86400*30), displayToday: false, dformat: self.pref.getDateFormat())
        self.endDate.inputView = endDateSelector
        self.endDate.inputAccessoryView = endDateSelector.toolBar
        self.endDate.text = dateFormatter.string(from: endDateSelector.date)
        
        
    }
    
    
    func validationSuccessful() {
        let pref = MyPreferences()
        let budget:Budget = Budget()
        budget.start_date = Int(startDateSelector.date.timeIntervalSince1970)
        budget.end_date = Int(endDateSelector.date.timeIntervalSince1970)
        if budget.end_date < budget.start_date {
            let alter = UIAlertController(title: NSLocalizedString("text_error", comment: "Error"), message: NSLocalizedString("end_date_shouldbe_greater", comment: "Date range error"), preferredStyle: .alert)
            alter.addAction(UIAlertAction(title: NSLocalizedString("text_ok", comment: "OK"), style: .default, handler: nil))
            self.present(alter, animated: true, completion: nil)
            return 
        }
  
        budget.active = 1
        budget.owner = pref.getUserIdentifier()
        budget.insert_date = Int(Date().timeIntervalSince1970)
        budget.type = BudgetType.PERSONAL.rawValue
        budget.comment = IsmUtils.makeTitleFor(budget: budget)
        if(!self.advancedOptionsWrapper.isHidden) {
            budget.comment = textBugdetName.text!
            budget.initialBalance = UtilsIsm.readNumberInput(value: self.textInitialAmount.text!)
            budget.allowOutRange = swithEnableOutRange.isOn
        }
      
        budget.owner_name = pref.getUserEmail()
        budget.last_view = Int(Date().timeIntervalSince1970)
        
        
        var budgetSections:[BudgetSection] = []
        
        if(NSLocalizedString("userLang", comment: "lang") == "fr") {
           budgetSections = BudgetUtil.readTemplateFile(filename: "personnal_budget-fr")
        }else {
           budgetSections = BudgetUtil.readTemplateFile(filename: "personnal_budget")
        }
        
        
        let args:NSDictionary = [
            "budget": budget,
            "category": budgetSections
        ]
        
        let addCats = AddCategoriesViewController(nibName: "AddCategoriesViewController", bundle: nil)
        addCats.params = args
        self.navigationController?.pushViewController(addCats, animated: true)
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

    @objc func save() {
        
        validator.validate(self)
        
        
    }
    
    //Cancel payee
       @objc func cancel(_ sender: UIBarButtonItem) {
           
           appDelegate.navigateTo(instance: ViewController())
       }
    
    
}
