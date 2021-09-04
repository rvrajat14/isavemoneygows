//
//  DayBookViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 3/4/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import ISMLDataService
import ISMLBase

class DayBookViewController: BaseScreenViewController, UITableViewDataSource, UITableViewDelegate {

    static var viewIdentifier:String = "DayBookViewController"
    
    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var txtEndDate: UITextField!
    @IBOutlet weak var labelIncome: UILabel!
    @IBOutlet weak var labelExpense: UILabel!
    @IBOutlet weak var bookTableView: UITableView!
    
    @IBOutlet weak var detailsView: UIView!
    
    @IBOutlet weak var dateRangeStack: UIStackView!
    
    @IBOutlet weak var filterSelected: UISegmentedControl!
    
    
    var startDateSelector:DatePicker!
    var endDateSelector:DatePicker!
    var mBudget:Budget!
    
    var mTransactions:[IsmTransaction] = []
    var mIncomeTransactions:[IsmTransaction] = []
    var mExpenseTransactions:[IsmTransaction] = []
    
  
    var formatter: NumberFormatter!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("dayBook", comment: "Day Book")
        let cancelButton = UIBarButtonItem(image: UIImage(named: "back_icon"), landscapeImagePhone: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(cancel(_:)))
        self.navigationItem.leftBarButtonItem  = cancelButton
        
        self.txtStartDate.tag = 1
        self.txtEndDate.tag = 2
        
        
        self.bookTableView.delegate = self
        self.bookTableView.dataSource = self
        self.bookTableView.rowHeight = UITableView.automaticDimension
        self.bookTableView.separatorColor = UIColor(named: "seperatorColor")
        self.bookTableView.backgroundColor = UIColor.clear
        dateRangeStack.isHidden = true
        
        //
        
        self.bookTableView.register(UINib(nibName: "DaybookViewCell", bundle: nil), forCellReuseIdentifier: "DaybookViewCell")
        formatter = NumberFormatter()
        formatter.numberStyle = .currency
        filterSelected.tintColor = flavor.getAccentColor()
        
        
         self.txtStartDate.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        
         self.txtEndDate.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        
        self.detailsView.layer.cornerRadius = 5.0
        self.detailsView.layer.borderColor = UIColor(white:0.96, alpha:1.0).cgColor
        self.detailsView.layer.borderWidth = 1.0
        //
        
        let image = UIImage(named: "date_range")
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
        self.firestoreRef = appDelegate.firestoreRef
        self.pref = MyPreferences()

//        navigationController?.navigationBar.tintColor = flavor.getNavigationBarColor()
//        navigationController?.navigationBar.barTintColor = flavor.getPrimaryColor()
        //navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:flavor.getNavigationBarColor(), NSAttributedString.Key.font: UIFont(name: "Lato-Bold", size: 18)!]
        
        loadCurrentBudget()
     
        // Do any additional setup after loading the view.
    }

    internal func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return UITableView.automaticDimension
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
      
        
        if Int(startDateSelector.date.timeIntervalSince1970) <=  Int(endDateSelector.date.timeIntervalSince1970) {
            
            //mBudget.start_date = Int(startDateSelector.date.timeIntervalSince1970)
            
            //mBudget.end_date = Int(endDateSelector.date.timeIntervalSince1970)
            
            
        } else {
        
        
            //mBudget.start_date = Int(startDateSelector.date.timeIntervalSince1970)
            //mBudget.end_date = Int(startDateSelector.date.timeIntervalSince1970)
            
            startDateSelector.date  = startDateSelector.date
            endDateSelector.date = startDateSelector.date
            
            self.txtStartDate.text = UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(startDateSelector.date.timeIntervalSince1970)), format: self.pref.getDateFormat())
            self.txtEndDate.text = UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(startDateSelector.date.timeIntervalSince1970)), format: self.pref.getDateFormat())
            
        }
        
        //self.txtStartDate.text = Utils.DateFormat(date: Date(timeIntervalSince1970: Double(self.mBudget.start_date)))
        //self.txtEndDate.text = Utils.DateFormat(date: Date(timeIntervalSince1970: Double(self.mBudget.end_date)))
        
        //self.setUpPicker(budget: self.mBudget)
        
        //self.loadTransaction(budget: self.mBudget)
        
        let start_data:Int = Int(UtilsIsm.firstHourOfTheDay(varDate: startDateSelector.date).timeIntervalSince1970)
        let end_data:Int = Int(UtilsIsm.lastHourOfTheDay(varDate: endDateSelector.date).timeIntervalSince1970)
        
        self.loadTransaction(budget: self.mBudget, start_date: start_data,  end_date: end_data)
    }
    
    func loadCurrentBudget() {
        
        //load budget
        
        let currentBudget = self.pref.getSelectedMonthlyBudget()
        
        let fbBudget = FbBudget(reference: self.firestoreRef)
        //
        
        self.indicatorShow()
        if currentBudget != "" {// if preference gid exists
            
            fbBudget.get(currentBudget, completed: {(budget) in
                if budget.gid != "" { // if preference budget found
                    
                    self.mBudget = budget
                    
                    if budget.comment != "" {
                        
                        //self.txtName.text = budget.comment
                        
                    } else {
                        
                        //self.txtName.text = Utils.makeTitleFor(startDate: budget.start_date, endDate: budget.end_date)
                        
                    }
                    
                    self.txtStartDate.text = UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(self.mBudget.start_date)), format: self.pref.getDateFormat())
                    self.txtEndDate.text = UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(self.mBudget.end_date)), format: self.pref.getDateFormat())
                    
                    self.setUpPicker(budget: self.mBudget)
                    
                    let date = Date()
                    
                    let start_data:Int = Int(UtilsIsm.firstHourOfTheDay(varDate: date).timeIntervalSince1970)
                    let end_data:Int = Int(UtilsIsm.lastHourOfTheDay(varDate: date).timeIntervalSince1970)
                    
                    self.loadTransaction(budget: self.mBudget, start_date: start_data,  end_date: end_data)
                    
                }
                
            }, not_found: {(message) in
                
                print(message)
                
                
            })
            
         
        }
        
        
    }
    
    
    func setUpPicker(budget: Budget) {
        
        ////date
        startDateSelector = DatePicker()
        startDateSelector.setUp(widthSize: Int(self.view.frame.width), heightSize: 200,
                                selectedDate: Date(timeIntervalSince1970: Double(budget.start_date))
            ,inputText: self.txtStartDate, inputTextErr: UILabel(), date_format: self.pref.getDateFormat())
        self.txtStartDate.inputView = startDateSelector
        self.txtStartDate.inputAccessoryView = startDateSelector.toolBar
        
        startDateSelector.minimumDate = Date(timeIntervalSince1970: Double(budget.start_date))
        startDateSelector.maximumDate = Date(timeIntervalSince1970: Double(budget.end_date))
        
        endDateSelector = DatePicker()
        endDateSelector.setUp(widthSize: Int(self.view.frame.width), heightSize: 200,
                              selectedDate: Date(timeIntervalSince1970: Double(budget.end_date))
            ,inputText: self.txtEndDate, inputTextErr: UILabel(), date_format: self.pref.getDateFormat())
        self.txtEndDate.inputView = endDateSelector
        self.txtEndDate.inputAccessoryView = endDateSelector.toolBar
        
        endDateSelector.minimumDate = Date(timeIntervalSince1970: Double(budget.start_date))
        endDateSelector.maximumDate = Date(timeIntervalSince1970: Double(budget.end_date))
        
    }

    
    func loadTransaction(budget: Budget, start_date: Int, end_date: Int) {
    
        
        let start:String = UtilsIsm.DateTimeFormat(date: Date(timeIntervalSince1970: Double(start_date)))
        let end:String = UtilsIsm.DateTimeFormat(date: Date(timeIntervalSince1970: Double(end_date)))
        let fbIncome:FbIncome = FbIncome(reference: self.firestoreRef)
        
        
        fbIncome.getByBudgetGid(budget.gid, complete: {(incomesList) in
            
            self.mIncomeTransactions = []
            for income in incomesList {
                
                let dateDisplay:String = UtilsIsm.DateTimeFormat(date: Date(timeIntervalSince1970: Double(income.transaction_date)))
            
                if income.gid != ""  && income.transaction_date >= start_date &&  income.transaction_date <= end_date {
                    
                    let transaction = IsmTransaction()
                    
                    transaction.name = income.title!
                    transaction.date = income.transaction_date!
                    transaction.amount = income.amount!
                    transaction.type = .INCOMING
                    
                    self.mIncomeTransactions.append(transaction)
                }
                
            }
            
            self.reloadTable()
            
        }, error_message: {(error) in
            print(error.errorMessage)
        })
        
        
        
        
        let fbExpense:FbExpense = FbExpense(reference: self.firestoreRef)
        fbExpense.getByBudgetGid(budget.gid, complete: {(expensesList) in
            
            self.mExpenseTransactions = []
            for expense in expensesList {
                
                var dateDisplay:String = UtilsIsm.DateTimeFormat(date: Date(timeIntervalSince1970: Double(expense.transaction_date)))
                
                if (expense.gid != "" && expense.transaction_date >= start_date &&  expense.transaction_date <= end_date){
                    
                    let transaction = IsmTransaction()
                    
                    transaction.name = expense.title!
                    transaction.date = expense.transaction_date!
                    transaction.amount = expense.amount!
                    transaction.type = .OUTGOING
                    
                    self.mExpenseTransactions.append(transaction)
                }
                
            }
            
            self.indicatorHide()
            self.reloadTable()
            
        }, error_message: {(error) in
            print(error)
        })
        //self.indicatorShow()
        
        
    
    }
    
    ///
    @IBAction func backButton(_ sender: Any) {
        
        appDelegate.navigateTo(instance: ViewController())
    }
    
    //
    
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        if (mTransactions.count>0) {
            
         
            self.bookTableView.separatorStyle = .singleLine
            self.bookTableView.backgroundView = nil
            return mTransactions.count
            
        } else {
            
            let messageLabel = UILabel()
            messageLabel.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            
            messageLabel.text = NSLocalizedString("dayBookNoDataAvailable", comment: "No data is currently available. Please pull down to refresh.");
            
            messageLabel.textColor = UIColor.black
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment =  NSTextAlignment.center;
            
            messageLabel.sizeToFit()
            messageLabel.font = UIFont(name: "Palatino-Italic", size: 20)
            
            self.bookTableView.backgroundView = messageLabel
            //self.bookTableView.separatorStyle = .none
            self.bookTableView.separatorColor = UIColor(named: "seperatorColor")
            
            return mTransactions.count
            
        }
    
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
       
        let transaction: IsmTransaction = mTransactions[indexPath.row]
        
        
        
         let drawerCell = tableView.dequeueReusableCell(withIdentifier: "DaybookViewCell", for: indexPath) as! DaybookViewCell
         
         
         drawerCell.textTitle.text = transaction.name
        drawerCell.txtAmount.text = UtilsIsm.formartCurrency(value: transaction.amount, local: pref.getCurrency())
      
         drawerCell.txtDate.text = UtilsIsm.DateTimeFormat(date: Date(timeIntervalSince1970: Double(transaction.date)))
        
        if transaction.type == .OUTGOING {
            
            drawerCell.txtAmount.textColor = Const.RED
        }else {
            drawerCell.txtAmount.textColor = Const.BLUE
        }
        
        
        
        return drawerCell
        
        
        
    }
    
    
    func reloadTable() {
    
        
        self.mTransactions = []
        var totalIncome = 0.0
        var totalExpense = 0.0
        
        for transaction in mIncomeTransactions {
        
            self.mTransactions.append(transaction)
            
            totalIncome  += transaction.amount
        }
        
        
        for transaction in mExpenseTransactions {
            
            transaction.amount = transaction.amount * -1
            self.mTransactions.append(transaction)
            
            totalExpense  += transaction.amount
        }
        
        
        self.labelIncome.text = UtilsIsm.formartCurrency(value:totalIncome, local: self.pref.getCurrency())
        self.labelIncome.textColor = Const.BLUE
        //"+\(self.formatter.string(from: totalIncome as NSNumber)!)"
        
        self.labelExpense.text = UtilsIsm.formartCurrency(value:totalExpense, local: self.pref.getCurrency())
            //self.formatter.string(from: totalExpense as NSNumber)
        self.labelExpense.textColor = Const.RED
        
        self.bookTableView.reloadData()
    }
    //Cancel payee
    @objc func cancel(_ sender: UIBarButtonItem) {
        
        //appDelegate.navigateTo(instance: ViewController())
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func selectFilter(_ sender: UISegmentedControl) {
        
        
        switch filterSelected.selectedSegmentIndex {
        case 0:
            
            dateRangeStack.isHidden = true
            
            let date = Date()
            
            let start_data:Int = Int(UtilsIsm.firstHourOfTheDay(varDate: date).timeIntervalSince1970)
            let end_data:Int = Int(UtilsIsm.lastHourOfTheDay(varDate: date).timeIntervalSince1970)
            
            self.loadTransaction(budget: self.mBudget, start_date: start_data,  end_date: end_data)
            break
            
        case 1:
            
            dateRangeStack.isHidden = true
            
            let date = Date()
            let pastDate = UtilsIsm.getPastDay(date: date, number: -1)
            
            let start_data:Int = Int(UtilsIsm.firstHourOfTheDay(varDate: pastDate).timeIntervalSince1970)
            let end_data:Int = Int(UtilsIsm.lastHourOfTheDay(varDate: pastDate).timeIntervalSince1970)
            
            self.loadTransaction(budget: self.mBudget, start_date: start_data,  end_date: end_data)
            
            break
            
        case 2:
            
            dateRangeStack.isHidden = false
            
            
            let date = Date()
            let pastDate = UtilsIsm.getPastDay(date: date, number: -7)
            
            
            self.txtStartDate.text = UtilsIsm.DateFormat(date: pastDate, format: self.pref.getDateFormat())
            self.txtEndDate.text = UtilsIsm.DateFormat(date: date, format: self.pref.getDateFormat())
            
            
            let start_data:Int = Int(UtilsIsm.firstHourOfTheDay(varDate: pastDate).timeIntervalSince1970)
            let end_data:Int = Int(UtilsIsm.lastHourOfTheDay(varDate: date).timeIntervalSince1970)
            
            self.loadTransaction(budget: self.mBudget, start_date: start_data,  end_date: end_data)
            break
            
        default:
            break
        }
        
    }
    
   

}
