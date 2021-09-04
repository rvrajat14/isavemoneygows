//
//  ConfigBudgetViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 3/4/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import Firebase
import SwiftValidator
import FirebaseFirestore
import ISMLDataService
import ISMLBase
import ToolsBoxModule

class ConfigBudgetViewController: BaseFormViewController, DateDelegate, CalDelegate {
   
    

    static var viewIdentifier:String = "ConfigBudgetViewController"
    
    var startDateSelector:CompleteDatePicker!
    var endDateSelector:CompleteDatePicker!
    var mBudget:Budget!
    
    var dateFormatter: DateFormatter!
    
    var minDate:Int!
    var maxDate:Int!
    var mRecordedDate:[Int] = []
    
    @IBOutlet weak var txtStartDate: TextFieldDateInput!
    @IBOutlet weak var txtStartDateError: UILabel!
    @IBOutlet weak var txtEndDate: TextFieldDateInput!
    @IBOutlet weak var txtEndDateError: UILabel!
    @IBOutlet weak var advancedOptionsWrapper: UIStackView!
    @IBOutlet weak var advanceOptionsButton: UIButton!
    @IBOutlet weak var textInitialAmount: UITextField!
    @IBOutlet weak var textBugdetName: UITextField!
    @IBOutlet weak var swithEnableOutRange: UISwitch!
    @IBOutlet weak var calculatorOpen: UIButton!
    func dateSelected(tag: Int, cancel: Bool) {
        
        switch tag {
        case 1:
            
            self.txtStartDate.resignFirstResponder()
            if cancel == false {
                //self.txtStartDate.text = dateFormatter.string(from: startDateSelector.date)
                //self.txtStartDateError.text = ""
                //self.txtStartDate.layer.borderWidth = 0.0
                
            
            }
            
            break
        case 2:
            
            self.txtEndDate.resignFirstResponder()
            
            if cancel == false {
                //self.txtEndDate.text = dateFormatter.string(from: endDateSelector.date)
                //self.txtEndDateError.text = ""
                //self.txtEndDate.layer.borderWidth = 0.0
                
                
            }
            
            break
        default:
            break
        }
        
        
        self.mBudget.comment = ""
        self.mBudget.start_date = Int(startDateSelector.date.timeIntervalSince1970)
        self.mBudget.end_date = Int(endDateSelector.date.timeIntervalSince1970)
        self.textBugdetName.text = IsmUtils.makeTitleFor(budget: self.mBudget)
    
        
    }
    
    lazy var saveButton:UIBarButtonItem = {
        return UIBarButtonItem(title: NSLocalizedString("text_save", comment: "Save"),
                               style: .done,
                               target: self,
                               action:  #selector(ConfigBudgetViewController.save(_:)))
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("configureBudget", comment: "Configure Budget")
        let cancelButton = UIBarButtonItem(image: UIImage(named: "back_icon"), landscapeImagePhone: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(cancel(_:)))
        self.navigationItem.leftBarButtonItem  = cancelButton
        self.navigationItem.rightBarButtonItem = saveButton
        
        textInitialAmount.keyboardType = .numberPad
        setButtonState(state: false)
        advanceOptionsButton.addTarget(self, action: #selector(toggleAdvance), for: .touchUpInside)
        
        self.txtStartDateError.text = ""
        self.txtEndDateError.text = ""
        self.txtStartDate.tag = 1
        self.txtEndDate.tag = 2
        
        dateFormatter = DateFormatter()
        // Set date format
        dateFormatter.dateFormat = pref.getDateFormat().replacingOccurrences(of: "m", with: "M")
        
        minDate = params["minDate"] as? Int ?? 0
        maxDate = params["maxDate"] as? Int ?? 0
        mBudget = params["mBudget"] as? Budget ?? nil
        mRecordedDate = params["dates"] as? [Int] ?? []
     
        //
      
        
        let image = UIImage(named: "right_chevron")
        let imageViewStartDate = UIImageView()
        imageViewStartDate.image = image
        imageViewStartDate.alpha = 0.5
        imageViewStartDate.image = imageViewStartDate.image!.withRenderingMode(.alwaysTemplate)
        imageViewStartDate.tintColor = UIColor.gray
        imageViewStartDate.frame = CGRect(x: 5, y: 0, width: 30, height: 30)
        txtStartDate.rightView = imageViewStartDate
        txtStartDate.rightViewMode = UITextField.ViewMode.always
        
        
        let imageViewEndDate = UIImageView()
        imageViewEndDate.image = image
        imageViewEndDate.alpha = 0.5
        imageViewEndDate.image = imageViewEndDate.image!.withRenderingMode(.alwaysTemplate)
        imageViewEndDate.tintColor = UIColor.gray
        imageViewEndDate.frame = CGRect(x: 5, y: 0, width: 30, height: 30)
        txtEndDate.rightView = imageViewEndDate
        txtEndDate.rightViewMode = UITextField.ViewMode.always
        
        //
    
       
        //Date(timeIntervalSince1970: Double(self.mBudget.end_date))
        
        self.setUpPicker()
        print("New budget \(mBudget.toAnyObject())")
        
        textBugdetName.text = mBudget.comment
        swithEnableOutRange.isOn = mBudget.allowOutRange
        textInitialAmount.text = "\(mBudget.initialBalance)"
        // Do any additional setup after loading the view.
//        navigationController?.navigationBar.tintColor = flavor.getNavigationBarColor()
//        navigationController?.navigationBar.barTintColor = flavor.getPrimaryColor()
        
        
        addDoneButtonOnKeyboard()
        
        self.view.backgroundColor = UIColor(named: "pageBgColor")
        
        calculatorOpen.addTarget(self, action: #selector(calculatorTapped), for: .touchUpInside)
    }
    
    @objc func calculatorTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let cal = TBUtils.getCalculator()
        cal.delegate = self
        self.present(cal, animated: true, completion: nil)
    }

    func onCalResult(value: String) {
        self.textInitialAmount.text = value
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    //cancel
    @objc func cancel(_ sender: Any) {
        //appDelegate.navigateTo(instance: ViewController())
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //save
    @objc func save(_ sender: Any) {
        
        if self.mBudget.start_date >=  self.mBudget.end_date  {
            
            let alert = UIAlertController(title: NSLocalizedString("text_error", comment: "title"), message: NSLocalizedString("text_end_date_isless", comment: "Date range error"), preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("text_ok", comment: "Ok"), style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
            return
        }
        
        if textBugdetName.text! == "" {
            self.mBudget.comment = IsmUtils.makeTitleFor(budget: mBudget)
        } else {
        
            self.mBudget.comment = textBugdetName.text!
        }
        
        self.mBudget.start_date = Int(startDateSelector.date.timeIntervalSince1970)
        self.mBudget.end_date = Int(endDateSelector.date.timeIntervalSince1970)
        
        if(!self.advancedOptionsWrapper.isHidden) {
            self.mBudget.comment = textBugdetName.text!
            self.mBudget.initialBalance = UtilsIsm.readNumberInput(value: self.textInitialAmount.text!)
            self.mBudget.allowOutRange = swithEnableOutRange.isOn
        }
        
        let fbBudget = FbBudget(reference: self.firestoreRef)
        
        _ = fbBudget.update(self.mBudget)
        
        appDelegate.navigateTo(instance: ViewController())
    }
    
    
    func setUpPicker() {
        
        self.txtStartDate.text =
        UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(self.mBudget.start_date)), format: self.pref.getDateFormat())
        //Date(timeIntervalSince1970: Double(self.mBudget.start_date))
        self.txtEndDate.text =
        UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(self.mBudget.end_date)), format: self.pref.getDateFormat())
        
        startDateSelector = CompleteDatePicker()
        startDateSelector.setUp(widthSize: Int(self.view.frame.width), heightSize: 220, displayToday: false, associatedView: self.txtStartDate)
        startDateSelector.date = Date(timeIntervalSince1970: Double(self.mBudget.start_date))
        startDateSelector.onDateSelected(listenerDate: {date in
            self.txtStartDate.text = UtilsIsm.DateFormat(date: date, format: self.pref.getDateFormat())
        })
        self.txtStartDate.inputView = startDateSelector
        self.txtStartDate.inputAccessoryView = startDateSelector.toolBar
        //self.txtStartDate.text = dateFormatter.string(from: startDateSelector.date)

        
        
        endDateSelector = CompleteDatePicker()
        endDateSelector.setUp(widthSize: Int(self.view.frame.width), heightSize: 220, displayToday: false, associatedView: self.txtEndDate)
        endDateSelector.date = Date(timeIntervalSince1970: Double(self.mBudget.end_date))
        endDateSelector.onDateSelected(listenerDate: {date in
            self.txtEndDate.text = UtilsIsm.DateFormat(date: date, format: self.pref.getDateFormat())
        })
        self.txtEndDate.inputView = endDateSelector
        self.txtEndDate.inputAccessoryView = endDateSelector.toolBar
        //self.txtEndDate.text = dateFormatter.string(from: endDateSelector.date)

        
    }
    
    
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("text_done", comment: "done"), style: UIBarButtonItem.Style.done, target: self, action: #selector(ConfigBudgetViewController.doneButtonAction))
        
        doneToolbar.barStyle = UIBarStyle.default
        doneToolbar.isTranslucent = true
        doneToolbar.tintColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        doneToolbar.sizeToFit()
        doneToolbar.setItems([flexSpace, done], animated: true)
        doneToolbar.sizeToFit()
        doneToolbar.isUserInteractionEnabled = true
        
        self.textBugdetName.inputAccessoryView = doneToolbar
        
        
    }
    
    @objc func doneButtonAction () {
        
        self.textBugdetName.resignFirstResponder()
       
    }
  
}
