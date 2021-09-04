//
//  CloneBudgetViewController.swift
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
import CoreData

class CloneBudgetViewController: BaseFormViewController , DateDelegate{

    static var viewIdentifier:String = "CloneBudgetViewController"
    
    @IBOutlet weak var txtDateSource: UITextField!
    //@IBOutlet weak var txtDatePicked: UITextField!
    //@IBOutlet weak var txtDatePickedError: UILabel!
    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var txtStartDateError: UILabel!
    @IBOutlet weak var txtEndDate: UITextField!
    @IBOutlet weak var txtEndDateError: UILabel!
    //@IBOutlet weak var switchDateOption: UISegmentedControl!
    
    //@IBOutlet weak var singleDate: UIStackView!
   
    @IBOutlet weak var toggleIncludeIncomes: UISwitch!
    @IBOutlet weak var toggleIncludeTransactions: UISwitch!
    @IBOutlet weak var toggleRolloverCategories: UISwitch!
    @IBOutlet weak var toggleRolloverSaving: UISwitch!
    
    @IBOutlet weak var labelErrorMessage: UILabel!
    
    var oMonthYearPickerView: MonthPicker!
    var startDateSelector:CalendarPicker!
    var endDateSelector:CalendarPicker!
    var selectedMonth = 0
    var selectedYear = 0

    var mBudget:Budget!
    var copyIncomeCompleted = false
    var copyExpenseCompleted = false
    
    var mBudgetObject:BudgetObject!
    var categoriesDico:[AnyHashable : Any] = [:]
    var incomesDico:[AnyHashable : Any] = [:]
    var expensesDico:[AnyHashable : Any] = [:]
    var dateFormatter: DateFormatter!
    
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

    
    func dateSelected(tag: Int, cancel: Bool) {
        
        switch tag {
        case 1:
            self.txtStartDate.resignFirstResponder()
            if cancel == false {
                self.txtStartDate.text = dateFormatter.string(from: startDateSelector.date)
                self.txtStartDateError.text = ""
                self.txtStartDate.layer.borderWidth = 0.0
            
            }
            
            break
        case 2:
            
            self.txtEndDate.resignFirstResponder()
            
            if cancel == false {
                self.txtEndDate.text = dateFormatter.string(from: endDateSelector.date)
                self.txtEndDateError.text = ""
                self.txtEndDate.layer.borderWidth = 0.0
                
            }
            
            break
        default:
            break
        }
    }
    lazy var saveButton:UIBarButtonItem = {
        return UIBarButtonItem(title: NSLocalizedString("text_save", comment: "Save"),
                               style: .done,
                               target: self,
                               action:  #selector(CloneBudgetViewController.save(_:)))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancelButton = UIBarButtonItem(image: UIImage(named: "back_icon"), landscapeImagePhone: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(cancel(_:)))
        self.navigationItem.leftBarButtonItem  = cancelButton
        self.navigationItem.rightBarButtonItem  = saveButton
        
        self.title = NSLocalizedString("CloneBudget", comment: "Clone Budget")
        //self.txtDatePickedError.text = ""
        self.txtStartDateError.text = ""
        self.txtEndDateError.text = ""
        //self.txtDatePicked.tag = 0
        self.txtStartDate.tag = 1
        self.txtEndDate.tag = 2
        
        
        dateFormatter = DateFormatter()
        // Set date format
        dateFormatter.dateFormat = pref.getDateFormat().replacingOccurrences(of: "m", with: "M")
        
        
        mBudgetObject = params["mBudgetObject"] as? BudgetObject ?? nil
        
        //
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
        
//        navigationController?.navigationBar.tintColor = flavor.getNavigationBarColor()
//        navigationController?.navigationBar.barTintColor = flavor.getPrimaryColor()
        //navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:flavor.getNavigationBarColor(), NSAttributedString.Key.font: UIFont(name: "Lato-Bold", size: 18)!]
        
        //switchDateOption.tintColor = flavor.getAccentColor()
        
        setUpPicker()
        loadCurrentBudget()
        self.labelErrorMessage.isHidden = true

        
        // Do any additional setup after loading the view.
    }
    
    
    func setUpPicker() {
        
        self.mBudget = mBudgetObject.formBudget()
        ////date
        startDateSelector = CalendarPicker()
        self.startDateSelector.delegate = self
        self.startDateSelector.tag = 1
        startDateSelector.setUp(widthSize: Int(self.view.frame.width), heightSize: 220, selectedDate: (Date(timeIntervalSince1970: Double(self.mBudget.end_date))+86400), displayToday: false, dformat: self.pref.getDateFormat())
        self.txtStartDate.inputView = startDateSelector
        self.txtStartDate.inputAccessoryView = startDateSelector.toolBar
        self.txtStartDate.text = dateFormatter.string(from: startDateSelector.date)
        
        
        
        endDateSelector = CalendarPicker()
        self.endDateSelector.delegate = self
        self.endDateSelector.tag = 2
        endDateSelector.setUp(widthSize: Int(self.view.frame.width), heightSize: 220, selectedDate: (Date(timeIntervalSince1970: Double(self.mBudget.end_date))+(Double(self.mBudget.end_date) - Double(self.mBudget.start_date))), displayToday: false, dformat: self.pref.getDateFormat())
        self.txtEndDate.inputView = endDateSelector
        self.txtEndDate.inputAccessoryView = endDateSelector.toolBar
        self.txtEndDate.text = dateFormatter.string(from: endDateSelector.date)
        
        
    }

    
    func loadCurrentBudget() {
        
        //load budget
        
        self.mBudget = mBudgetObject.formBudget()
        
        if mBudget.comment != "" {
            
            self.txtDateSource.text = mBudget.comment
            
        } else {
            
            self.txtDateSource.text = IsmUtils.makeTitleFor(budget: mBudget)
        }
        
        
    }
    

    //cancel
    @objc func cancel(_ sender: Any) {
        
       //appDelegate.navigateTo(instance: ViewController())
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //save
    @objc func save(_ sender: Any) {
        
        
    if(Int(startDateSelector.date.timeIntervalSince1970)>=Int(endDateSelector.date.timeIntervalSince1970)) {
            self.labelErrorMessage.isHidden = false
            self.labelErrorMessage.text = NSLocalizedString("text_end_date_isless", comment: "")
            return
            
        }
        var error_count = 0
        
        if txtStartDate.text == "" {
            self.txtStartDate.layer.borderWidth = 1.0
            let red = UIColor(red: 244.0/255.0, green: 67.0/255.0, blue: 54.0/255.0, alpha: 1.0)
            self.txtStartDate.layer.borderColor = red.cgColor
            self.txtStartDateError.text = NSLocalizedString("CloneBudgetSelectDate", comment: "Select a date")
            error_count += 1
        } else {
            self.txtStartDateError.text = ""
            self.txtStartDate.layer.borderWidth = 0.0
        }
        
        if txtEndDate.text == "" {
            self.txtEndDate.layer.borderWidth = 1.0
            let red = UIColor(red: 244.0/255.0, green: 67.0/255.0, blue: 54.0/255.0, alpha: 1.0)
            self.txtEndDate.layer.borderColor = red.cgColor
            self.txtEndDateError.text = NSLocalizedString("CloneBudgetSelectEndDate", comment: "Select a date")
            error_count += 1
        } else {
            self.txtEndDateError.text = ""
            self.txtEndDate.layer.borderWidth = 0.0
        }
        

    
        print("Error count \(error_count)")
        
        if error_count > 0 {
            return
        }
        
        
        let budget:Budget = Budget()
        
        budget.start_date = Int(startDateSelector.date.timeIntervalSince1970)
        budget.end_date = Int(endDateSelector.date.timeIntervalSince1970)
        
        budget.active = 1
        budget.owner = self.pref.getUserIdentifier()
        budget.insert_date = Int(Date().timeIntervalSince1970)
        budget.type = mBudget.type
        budget.last_view = Int(Date().timeIntervalSince1970)
        budget.comment = IsmUtils.makeTitleFor(budget: budget)
        
        let pref = MyPreferences()
        let fbBudget:FbBudget = FbBudget(reference: self.firestoreRef)
        
        fbBudget.write(budget, returnSaved: {(budgetDoc) in
            
            budget.gid = budgetDoc.gid
           
            
            let userOwnBudget = UserOwnBudget(dataMap: [:])
            userOwnBudget.gid = budgetDoc.gid
            userOwnBudget.userGid = budget.owner
            userOwnBudget.budgetGid = budgetDoc.gid
            userOwnBudget.start_date = budget.start_date
            userOwnBudget.owner = budget.owner
            userOwnBudget.active = 1
            userOwnBudget.end_date = budget.end_date
            userOwnBudget.last_used = Int(Date().timeIntervalSince1970)
            userOwnBudget.budgetTitle = budget.comment
            
//            var lastThree = self.appDelegate.getLastThreeBudgets()
//            if lastThree.count > 0 {
//                lastThree.insert(userOwnBudget, at: 0)
//            }else{
//                lastThree.append(userOwnBudget)
//            }
//
//            if lastThree.count > 3 {
//               lastThree.remove(at: 3)
//            }
//
//            self.appDelegate.setLastThreeBudgets(lastThree: lastThree)
            
            let container: NSPersistentContainer = self.appDelegate.persistentContainer
            pref.setSelectedMonthlyBudget(userOwnBudget.budgetGid)
            RecentBudgetsHelper.insertBudget(viewContext: container.viewContext, forId: userOwnBudget.budgetGid, andName: IsmUtils.makeTitleFor(user_own: userOwnBudget))
         
            self.appDelegate.notifyDrawer()
            pref.setSelectedMonthlyBudget(budget.gid)
            self.copyCategories(budget_src: self.mBudget,  budget_des: budgetDoc)
            
        })
        
        
    }
    
    
    func copyIncomes(budget_src: Budget, budget_des: Budget, spent: Double) {
        
        
        let fbIncome:FbIncome = FbIncome(reference: self.firestoreRef)
        
        var totalIncome = 0.0
        
        for (_, income) in self.mBudgetObject.incomesDict {
            
            totalIncome += income.amount
            income.gid = ""
            income.budget_gid = budget_des.gid
            income.user_gid = self.pref.getUserIdentifier()
            income.insert_date = Int(Date().timeIntervalSince1970)
            income.transaction_date = self.getDateToSet(transaction_date: income.transaction_date, budget: budget_src, budget_des: budget_des)
            income.last_update = 0
            
            if self.toggleIncludeIncomes.isOn {
                
                fbIncome.write(income, completion: {(income) in
                    
                }, error_message: {(error) in
                    print(error)
                })
            }
            
        
            //incomesDico["/\(income.gid!)"] = income.toAnyObject()
            
        }
        
        if self.toggleRolloverSaving.isOn {
            
            let mIncome = Income()
            mIncome.budget_gid = self.pref.getSelectedMonthlyBudget()
            mIncome.user_gid = self.pref.getUserIdentifier()
            mIncome.title = IsmUtils.makeTitleFor(budget: budget_src)+NSLocalizedString("CloneBudgetRollOver", comment: " roll over")
            mIncome.amount = (totalIncome - spent)
            mIncome.active = 1
            mIncome.transaction_date = budget_des.start_date
            mIncome.insert_date = Int(Date().timeIntervalSince1970)
            
            fbIncome.write(mIncome, completion: {(income) in
                
            }, error_message: {(error) in
                print(error)
            })
            
            //incomesDico["/\(mIncome.gid!)"] = mIncome.toAnyObject()
            
        }
        
        
        //appDelegate.setLastThreeBudgets(lastThree: [])
        appDelegate.navigateTo(instance: ViewController())
        
        
    }
    
    
    func copyCategories(budget_src: Budget, budget_des: Budget) {
        
        
        let fbCategory:FbCategory = FbCategory(reference: self.firestoreRef)
        
        var totalSpent = 0.0
        
        for (_, categoryObject) in self.mBudgetObject.categoriesDict {
            
            let category:BudgetCategory = categoryObject.getCategory()
            let source_category = category.gid
            category.gid = ""
            category.budget_gid = budget_des.gid
            category.user_gid = self.pref.getUserIdentifier()
            
            if self.toggleRolloverCategories.isOn {
                
                category.amount = category.amount + (category.amount - category.spent)
            }
            category.spent = 0
            category.insert_date = Int(Date().timeIntervalSince1970)
            category.last_update = 0
            category.invalid = 1
            
           
            fbCategory.write(category, completion: {(category) in
             
            }, error_message: {(error) in
                print(error)
            })
            
            
                
            totalSpent = totalSpent + self.copyExpenses(category_gid_src: source_category!, category_gid_des: category.gid!, budget_src: budget_src, budget_des: budget_des)
            

            
        }
        
        
        self.copyIncomes(budget_src: budget_src, budget_des: budget_des, spent: totalSpent)
        
    }
    
    func copyExpenses(category_gid_src: String, category_gid_des: String, budget_src: Budget, budget_des: Budget) -> Double {
       
        let fbExpense:FbExpense = FbExpense(reference: self.firestoreRef)
        var totalSpent:Double = 0.0
        
        for (_, expense) in (self.mBudgetObject.categoriesDict[category_gid_src]?.expensesDict)! {
            
            expense.gid = ""
            expense.user_gid = self.pref.getUserIdentifier()
            expense.budget_gid = budget_des.gid
            expense.category_gid = category_gid_des
            expense.transaction_date = self.getDateToSet(transaction_date: expense.transaction_date, budget: budget_src, budget_des: budget_des)
            expense.insert_date = Int(Date().timeIntervalSince1970)
            expense.last_update = 0
            
            totalSpent = totalSpent + expense.amount
            
            if self.toggleIncludeTransactions.isOn {
                fbExpense.write(expense, completion: {(expense) in
                   
                }, error_message: {(error) in
                    print(error)
                })
            }
            
           
        }
    
        return totalSpent
    
    }
    
    
    func getDateToSet(transaction_date: Int, budget: Budget, budget_des: Budget) -> Int {
        
        
        
        var newTransactionDate = (transaction_date - budget.start_date) + budget_des.start_date
        
        if newTransactionDate > budget_des.end_date {
        
            newTransactionDate = budget_des.end_date
        }
        
       
        
        return newTransactionDate
    }

    
}
