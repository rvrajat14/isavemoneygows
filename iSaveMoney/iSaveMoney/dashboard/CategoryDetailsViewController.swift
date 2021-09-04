//
//  CategoryDetailsViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/23/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import ISMLBase
import ISMLDataService

class CategoryDetailsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, AddExpenDelegate {
    
    

    static var viewIdentifier:String = "CategoryDetailsViewController"
    var categoryGid:String!
    var mExpenses:[ExpenseRow] = []
    var mapExpenses:[String:Expense] = [:]
    var headerCategory:ExpenseRow!
    var firestoreRef: Firestore!
    var pref:MyPreferences!
    var minDate:Date!
    var maxDate:Date!
    
    var expensesTableView: UITableView!
    
    //var formatter: NumberFormatter!
    var mCategory:BudgetCategory!
    
    var mCategoryObject: CategoryObject!
    var appDelegate:AppDelegate!
    var flavor:Flavor!
    
    var categoryListener:ListenerRegistration!
    var expensesListener:ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flavor = Flavor()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.firestoreRef = appDelegate.firestoreRef
        self.pref = MyPreferences()
        self.setUpActivity()
        self.layoutComponent()
        
    }
    
    func setUpActivity() {

        self.title = NSLocalizedString("CategoryDetailsTitle", comment: "Title")
        
        let cancelButton = UIBarButtonItem(image: UIImage(named: "back_icon"), landscapeImagePhone: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(CategoryDetailsViewController.cancel(_:)))
        let editButton = UIBarButtonItem(title: NSLocalizedString("text_edit", comment: "Edit"), style: .done, target: self, action:  #selector(CategoryDetailsViewController.edit(_:)))
        
        self.navigationItem.leftBarButtonItem  = cancelButton
        self.navigationItem.rightBarButtonItem = editButton
    }

    func layoutComponent() {
        minDate = params["minDate"] as? Date
        maxDate = params["maxDate"] as? Date
        categoryGid = params["categoryGid"]  as? String ?? ""
        
        
        self.expensesTableView = {
            let table = UITableView()
            return table
        }()
        
        self.view.addSubview(self.expensesTableView)
        
        self.expensesTableView.register(CategoryHeaderTableViewCell.self, forCellReuseIdentifier: "categoryHeaderTableViewCell")
        self.expensesTableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "transactionTableViewCell")
        self.expensesTableView.delegate = self
        self.expensesTableView.dataSource = self
        self.expensesTableView.separatorColor = UIColor(named: "seperatorColor")
        self.expensesTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.expensesTableView.backgroundColor = UIColor.clear
        
        self.expensesTableView.edgesToSuperview()
    }
    override func viewWillAppear(_ animated: Bool) {
        loadCategory()
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        if categoryListener != nil {
            categoryListener.remove()
        }
        
        if expensesListener != nil {
            expensesListener.remove()
        }
        
    }
    
    func renderUI() {
        
        self.mExpenses = []
        var expensesList:[ExpenseRow] = []
        
        self.headerCategory.remaining = self.headerCategory.budget - self.headerCategory.spent
        self.mExpenses.append(self.headerCategory)
        for (_, expense) in mapExpenses {
            
            let expenseRow = ExpenseRow(expense: expense)
            expenseRow.type = ExpenseRow.EXPENSE
            
            expensesList.append(expenseRow)
        }
        expensesList = expensesList.sorted(by: {$0.transaction_date>$1.transaction_date})
        self.mExpenses.append(contentsOf: expensesList)
        
        self.expensesTableView.reloadData()
    }
    
    func loadCategory () {
        
        
        self.mExpenses = []
        let fbCategory = FbCategory(reference: self.firestoreRef)
        
        categoryListener = fbCategory.getSync(self.categoryGid, listener: {(category) in
            
            if category.status == -1 {
                self.alertRemoved()
                return
            }
            
            self.mCategory = category
            
//            if self.headerCategory != nil {
//                self.headerCategory.title = category.title
//                self.headerCategory.budget = category.amount
//            } else{
//                self.headerCategory = ExpenseRow()
//                self.headerCategory.type = ExpenseRow.HEADER
//                self.headerCategory.title = category.title
//                self.headerCategory.budget = category.amount
//                self.headerCategory.spent = 0
//            }
//
//
//
//
            
           
            
            if category.status == 2 {
                self.headerCategory.title = category.title
                self.headerCategory.budget = category.amount
                self.renderUI()
                return
            }
            
            
            self.headerCategory = ExpenseRow()
            self.headerCategory.type = ExpenseRow.HEADER
            self.headerCategory.title = category.title
            self.headerCategory.budget = category.amount
            self.headerCategory.spent = 0
            self.renderUI()
            if category.status == 1 {
                self.headerCategory.spent = 0
                self.loadExpenses(categoriGid: category.gid)
                self.expensesTableView.reloadData()
            }
            
        }, error_message: {(error) in
            print(error)
        })
        
     
        
    }
    
    func loadExpenses(categoriGid:String) {
        
        let fbExpense = FbExpense(reference: self.firestoreRef)
        
        expensesListener = fbExpense.getByCategoryGidSync(categoriGid, complete: {(expense) in
            
            if(expense.status == -1 &&  self.mapExpenses[expense.gid] != nil) {
                
                self.mapExpenses[expense.gid] = nil
                self.headerCategory.spent = self.headerCategory.spent - expense.amount
            } else {
                
                self.headerCategory.spent = self.headerCategory.spent + expense.amount
                self.mapExpenses[expense.gid] = expense
            }
            
            self.renderUI()
            
            
        }, error_message: {(error) in
            print(error.errorMessage)
        })
    }
    
    func alertRemoved() {
        let alert = UIAlertController(title: NSLocalizedString("category_removed_title", comment: "title"),
                                      message: NSLocalizedString("category_removed", comment: "body"),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("category_removed_ok", comment: "ok"),
                                      style: .default, handler: {_ in
                                        //self.appDelegate.navigateTo(instance: ViewController())
                                        //self.navigationController?.popViewController(animated: true)
                                        self.dismiss(animated: true)
        }))
        
        self.present(alert, animated: true)
    }
    
    
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (mExpenses.count>0) {
            
            self.expensesTableView.separatorStyle = .singleLine
            self.expensesTableView.backgroundView = nil
            return mExpenses.count;
            
        } else {
            
            let messageLabel = UILabel()
            messageLabel.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            
            messageLabel.text = NSLocalizedString("CategoryDetailsNoData", comment: "No data is currently available. Please pull down to refresh.");
            
            messageLabel.textColor = UIColor.black
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment =  NSTextAlignment.center;
            
            messageLabel.sizeToFit()
            messageLabel.font = UIFont(name: "Palatino-Italic", size: 20)
            
            self.expensesTableView.backgroundView = messageLabel
            self.expensesTableView.separatorStyle = .none
            
        }
        
        return 0;
        
        //return budgetSections.count
    }
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let expense: ExpenseRow = mExpenses[indexPath.row]
        //categoryDetailsTableViewCell
        
        if expense.type == ExpenseRow.HEADER {
            
            let drawerCell = tableView.dequeueReusableCell(withIdentifier: "categoryHeaderTableViewCell", for: indexPath) as! CategoryHeaderTableViewCell
            
            drawerCell.addDelegate = self
            
            drawerCell.categoryTitle.text = expense.title
            
            drawerCell.remainingValueLabel.text = UtilsIsm.formartCurrency(value: expense.remaining, local: self.pref.getCurrency())
            
            drawerCell.actualSpendValueLabel.text = UtilsIsm.formartCurrency(value: expense.spent, local: self.pref.getCurrency())
            
            drawerCell.budgetSpendValueLabel.text = UtilsIsm.formartCurrency(value: expense.budget, local: self.pref.getCurrency())
            
            if expense.budget! <= 0 {
                
                drawerCell.remainingValueLabel.text = "N/A"
                drawerCell.budgetSpendValueLabel.text = "N/A"
            }
            
            drawerCell.progressGraph.reDraw(expense.budget!,
                                            spent: expense.spent!,
                                            color: UIColor(named: "progressLevelColor")!,
                                            bgColor: UIColor(named: "progressBaseColor")!)
            
            drawerCell.progressGraph.setNeedsDisplay()
            
            
            if expense.budget == 0 {
                drawerCell.progressGraph.isHidden = true
            }
            
            let namePrefix = String(expense.title.prefix(1))
            drawerCell.leterCircled.setText(text: namePrefix, col: Const.getColorByCharacter(character: namePrefix))
            drawerCell.leterCircled.setNeedsDisplay()
            
            
            return drawerCell
        } else {
            
            let drawerCell = tableView.dequeueReusableCell(withIdentifier: "transactionTableViewCell", for: indexPath) as! TransactionTableViewCell
            
            
            drawerCell.transactionTitle.text = Utils.trimText(text: expense.title)
            
            drawerCell.transactionValueLabel.text = UtilsIsm.formartCurrency(value: expense.amount, local: self.pref.getCurrency())
           
            
            drawerCell.transactionDateLabel.text = UtilsIsm.DateTimeFormat(date: Date(timeIntervalSince1970: Double(expense.transaction_date)))
            
            let namePrefix = String(expense.title.prefix(1))
            drawerCell.leterCircled.setText(text: namePrefix, col: Const.getColorByCharacter(character: namePrefix))
            
            drawerCell.leterCircled.setNeedsDisplay()
            
            return drawerCell
        }
        
        
        
        
    }
    
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let expense: ExpenseRow = mExpenses[indexPath.row]
        
        if expense.type == ExpenseRow.HEADER {
            
            if mCategory != nil {
                
                let params:NSDictionary = ["minDate": self.minDate,
                                           "maxDate": self.maxDate,
                                           "category": mCategory]

            }
            
            return
        } else if expense.gid != "" {
            
            
            let oExpense = self.mapExpenses[expense.gid]
            
            let fbBudget = FbBudget(reference: appDelegate.firestoreRef)
            fbBudget.get(expense.budget_gid, completed: { budget in
                let params:NSDictionary = ["minDate": self.minDate,
                                           "maxDate": self.maxDate,
                                           "expense": oExpense?.toAnyObject() ?? [:]]
                let expenseVC = NewExpenseViewController()
                expenseVC.params = params
                expenseVC.allowOutOfRange = budget.allowOutRange
                expenseVC.budgetGid = budget.gid
                //self.navigationController?.pushViewController(expenseVC, animated: true)
                self.present(UINavigationController(rootViewController: expenseVC), animated: true)
            }, not_found: { error in
                
            })
            
            
        }


    }
    
    // Override to support editing the table view.
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let expense: ExpenseRow = mExpenses[indexPath.row]
        
        
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            let fbExpense:FbExpense = FbExpense(reference: self.firestoreRef)
            fbExpense.delete(expense)
            mExpenses.remove(at: indexPath.row)
            
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.

        let expense: ExpenseRow = mExpenses[indexPath.row]
        
        
        return expense.type != ExpenseRow.HEADER
    }
    

    
    @objc func cancel(_ sender: UIBarButtonItem) {
        //self.changeViewController(ViewController.viewIdentifier)
        
        //appDelegate.navigateTo(instance: ViewController())
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    
    @objc func edit(_ sender: UIBarButtonItem) {
        
        if mCategory != nil {
            
            let params:NSDictionary = ["minDate": self.minDate,
                                       "maxDate": self.maxDate,
                                       "category": mCategory.toAnyObject()]
            

            let newCat = NewCategoryViewController()
            newCat.params = params
            //self.navigationController?.pushViewController(newCat, animated: true)
            self.present(UINavigationController(rootViewController: newCat), animated: true)
        }

    }
    
    internal func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        
        let expense: ExpenseRow = mExpenses[indexPath.row]
        var rowHeight:CGFloat = 40.0
        
        
        switch expense.type {
            
        case ExpenseRow.HEADER:
            rowHeight = 72.0
            
        case ExpenseRow.EXPENSE:
            rowHeight = 48.0
            
        default:
            rowHeight = 44.0
        }
        
        
        return rowHeight
        
    }
  
    func onPressButton() {
        let fbBudget = FbBudget(reference: appDelegate.firestoreRef)
        fbBudget.get(self.mCategory.budget_gid, completed: { budget in
            let args:NSDictionary = [
                "minDate": Date(timeIntervalSince1970: Double(budget.start_date)),
                "maxDate": Date(timeIntervalSince1970: Double(budget.end_date)),
                "initialCategory": self.mCategory.gid ?? ""
            ]
            
            let newExp = NewExpenseViewController()
            newExp.params = args
            newExp.allowOutOfRange = budget.allowOutRange
            newExp.budgetGid = budget.gid
            //self.navigationController?.pushViewController(newExp, animated: true)
            self.present(UINavigationController(rootViewController: newExp), animated: true)
        }, not_found: { error in
            
        })
    }
    
}
