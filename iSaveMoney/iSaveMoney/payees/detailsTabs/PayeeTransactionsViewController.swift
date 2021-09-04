//
//  ExpensesViewController.swift
//  iSaveMoneyAcc
//
//  Created by Sai Akhil on 26/07/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import Firebase
import ISMLBase
import ISMLDataService

class PayeeTransactionsViewController: BaseScreenViewController,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let payeeCell = tableView.dequeueReusableCell(withIdentifier: "PAYEE_DETAILS_CELL", for: indexPath) as! ExpensePayeeTableViewCell
            
            payeeCell.payeeName.text = payee?.name
            payeeCell.payeeAddress.text = payee?.address
            payeeCell.createdDate.text = UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(payee!.insert_date)), format: self.pref.getDateFormat())
            payeeCell.amount.text = UtilsIsm.formartCurrency(value: payee?.total_expenses ?? 0.0, local: self.pref.getCurrency())
            return payeeCell
        }
        
        let expenseCell = tableView.dequeueReusableCell(withIdentifier: "EXPENSE_CELL", for: indexPath) as! ExpensesTableViewCell
        let expense = expenses[indexPath.row-1]
        expenseCell.expenseName.text = expense.title
        expenseCell.expenseDate.text = UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(expense.transaction_date)), format: self.pref.getDateFormat())
        expenseCell.expenseAmount.text = UtilsIsm.formartCurrency(value: expense.amount, local: "")
        return expenseCell
    }
    
    var expenses:[Expense] = []
    var payee:Payee?
    var mPayeeCollection: PayeesCollection!
    var tabsViewController:PayeeTabsViewController? = nil
    
    lazy var tableView:UITableView = {
        
        let table = UITableView()
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.payee = params["payee"] as? Payee ?? nil
        self.tabsViewController = params["tabController"] as? PayeeTabsViewController ?? nil
        mPayeeCollection = PayeesCollection()
        
        self.view.addSubview(self.tableView)
        self.tableView.register(UINib(nibName: "ExpensesTableViewCell", bundle: nil), forCellReuseIdentifier: "EXPENSE_CELL")
        self.tableView.register(UINib(nibName: "ExpensePayeeTableViewCell", bundle: nil), forCellReuseIdentifier: "PAYEE_DETAILS_CELL")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = UIColor(named: "seperatorColor")
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.backgroundColor = UIColor.clear

       
        self.tableView.edgesToSuperview(insets: .top(48), usingSafeArea: true)


        if self.tabsViewController?.expenses != nil{
            self.expenses =  self.tabsViewController!.expenses!
            self.tableView.reloadData()
            return
        }
        
        mPayeeCollection.getPayeeExpenses(self.payee?.gid ?? "", onComplete: {(expenses) in
            self.expenses = expenses
            self.payee?.total_expenses = self.totalExpense(expenses: expenses)
            self.tableView.reloadData()
            self.tabsViewController?.expenses = expenses
        }, onError: {(error) in


        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        if mPayeeCollection != nil {
            mPayeeCollection.stopListner()
        }
    }
    deinit {
        if mPayeeCollection != nil {
            mPayeeCollection.stopListner()
        }
    }
    
    //
    
    // Override to support editing the table view.
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let confirmDetele = ConfirmDelete()
            let expense = self.expenses[indexPath.row - 1]
            let alert = confirmDetele.display(itemName: expense.title,
                                              feedback: {_ in
                                                
                                                let fbExpense = FbExpense(reference: self.appDelegate.firestoreRef)
                                                fbExpense.get(expense.gid, listener: {expense in
                                                    expense.payee_gid = ""
                                                    expense.payee_str = ""
                                                    fbExpense.update(expense)
                                                }, error_message: { err in
                                                    
                                                })
                                                //fbExpense.deleteWithGid(expense.gid)
                                               
                                              })
            self.present(alert, animated: true)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return indexPath.row > 0
    }
    
    private func totalExpense(expenses: [Expense]) -> Double{
           var total = 0.0;
           for expense in expenses {
               total = total + expense.amount
           }
           
           return total
       }
}
