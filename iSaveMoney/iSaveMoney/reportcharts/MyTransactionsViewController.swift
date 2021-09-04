//
//  MyTransactionsViewController.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 1/10/21.
//  Copyright © 2021 Armel Koudoum. All rights reserved.
//

import UIKit
import ISMLBase
import ISMLDataService

class MyTransactionsViewController: BaseScreenViewController, UITableViewDataSource, UITableViewDelegate {
   

    @IBOutlet weak var transactionTable: UITableView!
    @IBOutlet weak var startDate: TextFieldDateInput!
    @IBOutlet weak var endDate: TextFieldDateInput!
    @IBOutlet weak var txtTotalIncome: NormalTextLabel!
    @IBOutlet weak var txtTotalExpense: NormalTextLabel!
    
    
    var startDateSelector:DatePicker!
    var endDateSelector:DatePicker!
    
    var mTransactions:[IsmTransaction] = []
    var mIncomeTransactions:[IsmTransaction] = []
    var mExpenseTransactions:[IsmTransaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firestoreRef = appDelegate.firestoreRef
        self.pref = MyPreferences()
        
        self.title = NSLocalizedString("mytransactionsTitle", comment: "My Transactions")
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.firestoreRef = appDelegate.firestoreRef
        pref = MyPreferences()
        
        let cancelButton = UIBarButtonItem(image: UIImage(named: "back_icon"), landscapeImagePhone: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(cancel(_:)))
        self.navigationItem.leftBarButtonItem  = cancelButton
        // Do any additional setup after loading the view.
        
        self.transactionTable.delegate = self
        self.transactionTable.dataSource = self
        self.transactionTable.separatorColor = UIColor(named: "seperatorColor")
        self.transactionTable.tableFooterView = UIView(frame: CGRect.zero)
        self.transactionTable.tableFooterView = UIView()
        self.transactionTable.backgroundColor = UIColor.clear
        
        let tableViewCellNib = UINib(nibName: "MyTransactionTableViewCell", bundle: nil)
        self.transactionTable.register(tableViewCellNib, forCellReuseIdentifier: "MyTransactionTableViewCell")
        
        self.startDate.tag = 1
        self.endDate.tag = 2
        self.startDate.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        self.endDate.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        
        startDateSelector = DatePicker()
        startDateSelector.setUp(widthSize: Int(self.view.frame.width), heightSize: 200,
                                selectedDate: Date()
            ,inputText: self.startDate as UITextField, inputTextErr: UILabel(), date_format: self.pref.getDateFormat())
        self.startDate.inputView = startDateSelector
        self.startDate.inputAccessoryView = startDateSelector.toolBar
        
        endDateSelector = DatePicker()
        endDateSelector.setUp(widthSize: Int(self.view.frame.width), heightSize: 200,
                              selectedDate: Date()
            ,inputText: self.endDate as UITextField, inputTextErr: UILabel(), date_format: self.pref.getDateFormat())
        self.endDate.inputView = endDateSelector
        self.endDate.inputAccessoryView = endDateSelector.toolBar
      
        let start_data:Int = Int(UtilsIsm.firstHourOfTheDay(varDate: startDateSelector.date).timeIntervalSince1970)
        let end_data:Int = Int(UtilsIsm.lastHourOfTheDay(varDate: endDateSelector.date).timeIntervalSince1970)
        
        
        self.txtTotalIncome.textAlignment = .left
        self.txtTotalIncome.textColor = Const.BLUE
        self.txtTotalIncome.text = "0.00"
        self.txtTotalExpense.textAlignment = .right
        self.txtTotalExpense.textColor = Const.RED
        self.txtTotalExpense.text = "0.00"
        self.loadTransaction(start_date: start_data, end_date: end_data)
        
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if Int(startDateSelector.date.timeIntervalSince1970) > Int(endDateSelector.date.timeIntervalSince1970) {

            startDateSelector.date  = startDateSelector.date
            endDateSelector.date = startDateSelector.date
            
            self.startDate.text = UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(startDateSelector.date.timeIntervalSince1970)), format: self.pref.getDateFormat())
            self.endDate.text = UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(startDateSelector.date.timeIntervalSince1970)), format: self.pref.getDateFormat())
            
        }
        
        let start_data:Int = Int(UtilsIsm.firstHourOfTheDay(varDate: startDateSelector.date).timeIntervalSince1970)
        let end_data:Int = Int(UtilsIsm.lastHourOfTheDay(varDate: endDateSelector.date).timeIntervalSince1970)
        self.loadTransaction(start_date: start_data,  end_date: end_data)
    }

    @objc func cancel(_ sender: UIBarButtonItem) {

        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transaction: IsmTransaction = mTransactions[indexPath.row]
        let drawerCell = tableView.dequeueReusableCell(withIdentifier: "MyTransactionTableViewCell", for: indexPath) as! MyTransactionTableViewCell
        drawerCell.txtTitle.text = transaction.name
        drawerCell.txtAmount.text = UtilsIsm.formartCurrency(value: transaction.amount, local: pref.getCurrency())
        drawerCell.txtDate.text = UtilsIsm.DateTimeFormat(date: Date(timeIntervalSince1970: Double(transaction.date)))
        
        if transaction.type == .OUTGOING {
            
            drawerCell.txtAmount.textColor = Const.RED
            let img =  UIImage(named: "arrow_out")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            img?.withTintColor(UIColor(named: "tintIconsColor") ?? UIColor.gray)
            drawerCell.imgIndicator.image = img
        }else {
            drawerCell.txtAmount.textColor = Const.BLUE
            let img =  UIImage(named: "arrow_in")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            img?.withTintColor(UIColor(named: "tintIconsColor") ?? UIColor.gray)
            drawerCell.imgIndicator.image = img
        }
        
        if transaction.name.count > 0 {
            let namePrefix = String(transaction.name.prefix(1))
            drawerCell.vwCircleText.setText(text: namePrefix, col: Const.getColorByCharacter(character: namePrefix))
            drawerCell.vwCircleText.setNeedsDisplay()
        }
        
        return drawerCell
    }
    
    
    func loadTransaction(start_date: Int, end_date: Int) {
    
        
        let start:String = UtilsIsm.dateFormatOrTimeFor(Date(timeIntervalSince1970: Double(start_date)), format: self.pref.getDateFormat())
        let end:String = UtilsIsm.dateFormatOrTimeFor(Date(timeIntervalSince1970: Double(end_date)), format: self.pref.getDateFormat())
        self.startDate.text = start
        self.endDate.text = end
        
    
        let fbIncome:FbIncome = FbIncome(reference: self.firestoreRef)
        
        
        fbIncome.getIncomesForDates(userGid: self.pref.getUserIdentifier(), startDate: start_date, endDate: end_date,
                        complete: {(incomesList:[Income]) in
            
            self.mIncomeTransactions = []
            for income in incomesList {
                
                let transaction = IsmTransaction()
                
                transaction.name = income.title!
                transaction.date = income.transaction_date!
                transaction.amount = income.amount!
                transaction.type = .INCOMING
                
                self.mIncomeTransactions.append(transaction)
                
            }
            
            self.reloadTable()
            
        }, error_message: {(error) in
            print(error.errorMessage)
        })
        
        
        
        
        let fbExpense:FbExpense = FbExpense(reference: self.firestoreRef)
        fbExpense.getExpensesForDates(userGid: self.pref.getUserIdentifier(), startDate: start_date, endDate: end_date,
                            complete: {(expensesList:[Expense]) in
            
            self.mExpenseTransactions = []
            for expense in expensesList {
                
                let transaction = IsmTransaction()
                
                transaction.name = expense.title!
                transaction.date = expense.transaction_date!
                transaction.amount = expense.amount!
                transaction.type = .OUTGOING
               
                self.mExpenseTransactions.append(transaction)
                
            }
            
            self.indicatorHide()
            self.reloadTable()
            
        }, error_message: {(error) in
            print(error)
        })
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
        
        self.txtTotalIncome.text = UtilsIsm.formartCurrency(value: totalIncome, local: pref.getCurrency())
        self.txtTotalExpense.text = UtilsIsm.formartCurrency(value: totalExpense, local: pref.getCurrency())
        self.mTransactions = self.mTransactions.sorted(by: {$0.date>$1.date})
        self.transactionTable.reloadData()
    }

}
