//
//  AddCategoriesViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 1/20/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import SwiftValidator
import ISMLBase
import ISMLDataService
import CoreData

class AddCategoriesViewController: BaseScreenViewController, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate, BudgetItemTableViewDelegate, ModalCategoryDelegate  {
    
    
    
    func valueReturn(sender: BudgetSection, position:Int) {
        
        mBudgetSections[position].active = sender.active
        mBudgetSections[position].title = sender.title
        mBudgetSections[position].value = sender.value
        
        tableView.reloadData()
        self.updateExpenseCount()
        self.updateIncomeCount()
        
    }
    
   
    func incomeEditTableViewCellDidTaped(_ sender: IcomeEditTableViewCell) {
        
        mBudgetSections[sender.tag].active = (mBudgetSections[sender.tag].active + 1) % 2
        self.tableView.reloadData()
        self.updateIncomeCount()
        
    }
    
    func expenseEditTableViewCellDidTaped(_ sender: ExpenseEditTableViewCell) {
        mBudgetSections[sender.tag].active = (mBudgetSections[sender.tag].active + 1) % 2
        self.tableView.reloadData()
        self.updateExpenseCount()
        
    }
    
    func updateIncomeCount() {
        var countIncome = 0;
        for section in mBudgetSections {
            
            if section.type == RowType.income && section.active == 1 {
                countIncome = countIncome + 1
            }
        }
        
        self.incomeAddedText.text = "\(countIncome) \(NSLocalizedString("newBudgetNumberIncomes", comment: "2 Incomes added"))"
    }
    func updateExpenseCount() {
        var countCategory = 0;
        for section in mBudgetSections {
            
            if section.type == RowType.category && section.active == 1 {
                countCategory = countCategory + 1
            }
        }
        
        self.expenseAddedText.text = "\(countCategory) \(NSLocalizedString("newBudgetNumberExpenses", comment: "2 Incomes added"))"
    }
    

    static var viewIdentifier:String = "AddCategoriesViewController"
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonDone: UIButton!
    @IBOutlet weak var incomeAddedText: UILabel!
    @IBOutlet weak var expenseAddedText: UILabel!
    
    var mBudget:Budget!
    var mBudgetSections:[BudgetSection]!
    
    var formatter: NumberFormatter!
    var currentTitle: UITextField!
    var currentAmount: UITextField!
    
    var viewControllerNavController:UINavigationController!
    lazy var cancelButton:UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "back_icon"),
                               landscapeImagePhone: UIImage(named: "back_icon"),
                               style: .plain,
                               target: self,
                               action: #selector(AddCategoriesViewController.cancel(_:)))
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("newBudgetChooseCategory", comment: "Choose category title")
       
        self.tableView.register(UINib(nibName: "BudgetItemViewCell", bundle: nil), forCellReuseIdentifier: "BudgetItemViewCell")
        //self.tableView.register(UINib(nibName: "AddExpenseViewCell", bundle: nil), forCellReuseIdentifier: "AddExpenseViewCell")
        
        mBudget = params["budget"] as? Budget ?? nil
        mBudgetSections = params["category"] as? [BudgetSection] ?? []
        formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        self.navigationItem.leftBarButtonItem  = cancelButton
        //self.navigationItem.rightBarButtonItem = saveButton
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .clear
        self.tableView.separatorColor = UIColor(named: "seperatorColor")
        self.buttonDone.tintColor = UIColor.white
        
       
        self.buttonDone.addTarget(self, action: #selector(AddCategoriesViewController.buttonSave), for: .touchUpInside)
        self.updateExpenseCount()
        self.updateIncomeCount()
        
        let cv:UpdateCategory = UpdateCategory()
        viewControllerNavController = UINavigationController(rootViewController: cv)
        
        
    }

    internal func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return UITableView.automaticDimension
        
    }
    
    
    //cancel
    
    @objc func cancel(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //save
    @objc func buttonSave(_ sender: UIBarButtonItem) {
        
        saveBudget()
    }
    
    func openEditer(sectionItem:BudgetSection, position:Int) {
        
        let vcon = self.viewControllerNavController.topViewController as! UpdateCategory
        vcon.budgetSection = sectionItem
        vcon.position = position
        vcon.delegate = self
        self.present(self.viewControllerNavController, animated: true, completion: nil)
    }
    

    func saveBudget()  {
        
        let pref = MyPreferences()
        let fbBudget:FbBudget = FbBudget(reference: self.firestoreRef)
        fbBudget.write(mBudget, returnSaved: {(budget) in
            
            self.mBudget.gid = budget.gid
            
            
            //var lastThree = self.appDelegate.getLastThreeBudgets()
            let userOwnBudget = UserOwnBudget(dataMap: [:])
            userOwnBudget.gid = budget.gid
            userOwnBudget.userGid = budget.owner
            userOwnBudget.budgetGid = budget.gid
            userOwnBudget.start_date = budget.start_date
            userOwnBudget.owner = budget.owner
            userOwnBudget.active = 1
            userOwnBudget.end_date = budget.end_date
            userOwnBudget.last_used = Int(Date().timeIntervalSince1970)
            userOwnBudget.budgetTitle = budget.comment
            
//            if lastThree.count > 0 {
//                lastThree.insert(userOwnBudget, at: 0)
//            }else{
//                lastThree.append(userOwnBudget)
//            }
//
//            if lastThree.count > 3 {
//                lastThree.remove(at: 3)
//            }
//
//            self.appDelegate.setLastThreeBudgets(lastThree: lastThree)
            
            let container: NSPersistentContainer = self.appDelegate.persistentContainer
            pref.setSelectedMonthlyBudget(userOwnBudget.budgetGid)
            RecentBudgetsHelper.insertBudget(viewContext: container.viewContext, forId: userOwnBudget.budgetGid, andName: IsmUtils.makeTitleFor(user_own: userOwnBudget))
         
            self.appDelegate.notifyDrawer()
            pref.setSelectedMonthlyBudget(self.mBudget.gid)
            
            
            self.addBudgetElements(budget: self.mBudget)
        })
        
        appDelegate.navigateTo(instance: ViewController())
        
        //Set current budget
       
    }
    
    
    func addBudgetElements(budget:Budget)  {
        
        let pref = MyPreferences()
        var numberOfItemAdded = 0
        let today_date = Date()
        var transaction_date = Int(today_date.timeIntervalSince1970)
        
        
        if Int(today_date.timeIntervalSince1970) < budget.start_date || Int(today_date.timeIntervalSince1970) > budget.end_date {
            
            transaction_date = budget.start_date
            
        }
        
        
        let fbIncome:FbIncome = FbIncome(reference: self.firestoreRef)
        let fbCategory:FbCategory = FbCategory(reference: self.firestoreRef)
        for section in mBudgetSections {
        
        
            if section.type == RowType.income && section.active == 1 {
            
                let income:Income = Income()
                income.title = section.title
                income.amount = section.value
                income.budget_gid = budget.gid
                income.user_gid = pref.getUserIdentifier()
                income.transaction_date = transaction_date
                income.insert_date = transaction_date
                
                _ = fbIncome.write(income, completion: {(income) in
                    
                }, error_message: {(error) in
                    
                })
                numberOfItemAdded += 1
                
            } else if section.type == RowType.category && section.active == 1 {
                
                let category:BudgetCategory = BudgetCategory()
                category.title = section.title
                category.amount = section.value
                category.budget_gid = budget.gid
                category.user_gid = pref.getUserIdentifier()
                category.insert_date = transaction_date
                
                _ = fbCategory.write(category, completion: {(category) in
                    
                }, error_message: {(error) in
                    
                })
                numberOfItemAdded += 1
            
            }
        
        }
        
        
        if numberOfItemAdded <= 0 {
            
            let category:BudgetCategory = BudgetCategory()
            category.title = NSLocalizedString("addCategoryItem1", comment: "Uncategorized expenses")
            category.amount = 0.0
            category.budget_gid = budget.gid
            category.user_gid = pref.getUserIdentifier()
            category.insert_date = transaction_date
            
            _ = fbCategory.write(category, completion: {(category) in
                
            }, error_message: {(error) in
                
            })
            
            let income:Income = Income()
            income.title = NSLocalizedString("addCategoryItem2", comment: "Your Income")
            income.amount = 0.0
            income.budget_gid = budget.gid
            income.user_gid = pref.getUserIdentifier()
            income.transaction_date = transaction_date
            income.insert_date = transaction_date
            
            _ = fbIncome.write(income, completion: {(income) in
                
            }, error_message: {(error) in
                
            })
        }
        
        
        //appDelegate.setLastThreeBudgets(lastThree: [])
        appDelegate.navigateTo(instance: ViewController())
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return mBudgetSections.count
    }
    
    
    
    

    func cancelEdit() {
        
        var index = 0
        for section in mBudgetSections {
        
            if section.edit {
                mBudgetSections[index].edit = false
                let indexPath = IndexPath(row: index, section: 0)
                
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
            index += 1
        }
        
        
        
    }
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let budgetSection: BudgetSection = mBudgetSections[indexPath.row]
        
            
        if budgetSection.type == RowType.income {
        
            //EditTableViewCell
            
        let drawerCell = tableView.dequeueReusableCell(withIdentifier: "BudgetItemViewCell", for: indexPath) as! BudgetItemViewCell
            drawerCell.textTitle.text = budgetSection.title
            drawerCell.textAmount.text =
            "\(NSLocalizedString("addCategoryIncome", comment: "Income:")) \(self.formatter.string(from: budgetSection.value as NSNumber)!)"
            drawerCell.textAmount.textColor = Const.GREEN
            drawerCell.myIndex = indexPath.row
            drawerCell.sideColor.backgroundColor = Const.GREEN
         
            drawerCell.delegate = self
            if budgetSection.active == 1 {
                drawerCell.buttonAdd.isHidden = true
                drawerCell.buttonRemove.isHidden = false
           
            }else {
                drawerCell.buttonAdd.isHidden = false
                drawerCell.buttonRemove.isHidden = true
            
            }

            return drawerCell
            
        } else {
        
            let drawerCell = tableView.dequeueReusableCell(withIdentifier: "BudgetItemViewCell", for: indexPath) as! BudgetItemViewCell
            drawerCell.textTitle.text = budgetSection.title
            drawerCell.textAmount.text = "\(NSLocalizedString("addCategoryBudget", comment: "Budget:")) \(self.formatter.string(from: budgetSection.value as NSNumber)!)"
            
            drawerCell.textAmount.textColor = Const.BLUE
            drawerCell.myIndex = indexPath.row
            drawerCell.sideColor.backgroundColor = Const.BLUE
            drawerCell.delegate = self
            drawerCell.delegate = self
             if budgetSection.active == 1 {
                 drawerCell.buttonAdd.isHidden = true
                 drawerCell.buttonRemove.isHidden = false
            
             }else {
                 drawerCell.buttonAdd.isHidden = false
                 drawerCell.buttonRemove.isHidden = true
             
             }

           
            return drawerCell

        }
        
    }
    

    
    // Override to support editing the table view.
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            mBudgetSections.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            //tableView.reloadRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
      
       
         let budgetSection: BudgetSection = mBudgetSections[indexPath.row]
        openEditer(sectionItem: budgetSection, position: indexPath.row)
    }
    
    func tableViewCellIconDidTaped(_ sender: BudgetItemViewCell, type: Int) {
        mBudgetSections[sender.myIndex].active = type
        let indexPath = IndexPath(row: sender.myIndex, section: 0)
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
}
