//
//  BudgetObject.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 4/10/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import ISMLBase

public class BudgetObject {
    
    var budget:Budget!

    let firestoreRef:Firestore
    var pref: MyPreferences!
    
    
    public var categoriesDict: [String: CategoryObject]
    public var incomesDict: [String: Income]
    
    var minRegionDate = -1
    var maxRegionDate = -1
    
    var mFbBudget:FbBudget!
    
    var mRenderBudget: (([BudgetSection], Budget, Bool) -> Void)!
    
//    var budgetListenerRegistration:ListenerRegistration!
    var incomesListenerRegistration:ListenerRegistration!
    var categoriesListenerRegistration:ListenerRegistration!
    var expensesListenerRegistration: [ListenerRegistration] = []
    
    public init(reference: Firestore) {
        
        self.firestoreRef = reference
        
        self.pref = MyPreferences()
        categoriesDict = [:]
        incomesDict = [:]
        
    }
    
    public func setBudget(value: Budget) {
        
        self.budget = value
       
    }
    
   
    public func startSync(budgetGid:String, renderBudget: @escaping (([BudgetSection], Budget, Bool)->Void), error_msg: @escaping ((String)->Void)) -> Void {
        
        self.mRenderBudget = renderBudget
        categoriesDict = [:]
        incomesDict = [:]
        
        // let budgetGid = userOwnBudget.budgetGid
        print("TraceBudgetLoad:::loadCurrentBudget :: "+budgetGid)
        
        if budgetGid == "" {
            
            error_msg("TraceBudgetLoad:::invalid budget item uid")
            return
        }
        
        
        print("TraceBudgetLoad:::loadCurrentBudget :: goto sync ")
        
        let fbBudget:FbBudget = FbBudget(reference: self.firestoreRef)
        
        fbBudget.get(budgetGid, completed: {(budget) in
            print("TraceBudgetLoad:::find :: "+budgetGid)
            if (budget.gid!) != "" {
                
                
                self.setBudget(value: budget)
                
                self.mRenderBudget(self.formBudgetParts(), self.formBudget(), budget.status == -1)
                
                self.pullBudgetElements(budgetGid: budget.gid!)
                
               
            } else {
                
                self.pref.setSelectedMonthlyBudget("")
                error_msg("TraceBudgetLoad:::Budget not found with uid: code "+budgetGid)
                self.mRenderBudget([], Budget(), false)
            }
        }, not_found: { (error_message) in
            print("TraceBudgetLoad::Load Budget error \(error_message)")
            print(error_message)
            error_msg(error_message)
            self.pref.setSelectedMonthlyBudget("")
            self.mRenderBudget([], Budget(), false)
        })
        
    }
    
    public func pullBudgetElements(budgetGid: String) {
        
        print("pullBudgetElements :: "+budgetGid)
        mFbBudget = FbBudget(reference: self.firestoreRef)
        
        self.pullIncomes(budgetGid: budgetGid)
        self.pullCategories(budgetGid: budgetGid)
        
        //self.mRenderBudget(self.formBudgetParts(), self.formBudget())
        
    
    }
    
    public func pullIncomes(budgetGid: String) {
        
        self.budget.incomes = 0.0
        
        let fbIncome:FbIncome = FbIncome(reference: self.firestoreRef)
        
        incomesListenerRegistration = fbIncome.getByBudgetGidSync(budgetGid, complete: {(income) in
            
            if income.status == -1 {
                
                if self.incomesDict[income.gid] != nil {
                    self.incomesDict[income.gid] = nil
                }
                
                self.budget.incomes = self.budget.incomes - income.amount
                
            }else{
                
                self.incomesDict[income.gid] = income
                self.budget.incomes = self.budget.incomes + income.amount
            }
            
            self.mRenderBudget(self.formBudgetParts(), self.formBudget(), false)
            
            
        }, error_message: {(error) in
            
            print(error.errorMessage)
        })
        
        
        
    
    }
    
    
    public func pullCategories(budgetGid: String)  {
        
        let fbCategory:FbCategory = FbCategory(reference: self.firestoreRef)
        
        self.budget.expenses = 0.0
        self.budget.planned = 0.0
        
        categoriesListenerRegistration = fbCategory.getByBudgetGidSync(budgetGid, complete: {(category) in
            
            print("Expense get read... categoty \(category.status)")
            if category.status == -1 {
                
                if self.categoriesDict[category.gid] != nil {
                    self.categoriesDict[category.gid] = nil
                }
                self.budget.planned = self.budget.planned - category.amount
                
            }else{
                
                self.categoriesDict[category.gid] = CategoryObject(dataMap: category.toAnyObject() as! [String : Any])
                self.budget.planned = self.budget.planned + category.amount
                
                if category.status == 1 {
                    self.budget.planned = self.budget.planned - category.amount
                    self.syncExpense(categoryGid: category.gid!)
                }
                
            }
            
            self.mRenderBudget(self.formBudgetParts(), self.formBudget(), false)
            
            
            
        }, error_message: {(error) in
            
            print(error.errorMessage)
        })
        
        
        
    }
    
    
    public func syncExpense (categoryGid: String) {
        
        let fbExpense = FbExpense(reference: self.firestoreRef)
        
        print("Expense get read... \(categoryGid)")
        let listener = fbExpense.getByCategoryGidSync(categoryGid, complete: {(expense) in
            
            print("Expense get read...")
            if expense.status == -1 {
                
                if self.categoriesDict[expense.category_gid] != nil {
                    let categoryObject = self.categoriesDict[expense.category_gid]
                    categoryObject?.removeExpense(expense: expense)
                }
                
                
            }else{
                
                let categoryObject = self.categoriesDict[expense.category_gid]
                categoryObject?.addExpense(expense: expense)
                self.categoriesDict[expense.category_gid] = categoryObject
                
                //self.expenses = self.expenses + categoryObject?.spent
                //self.planned = self.planned + categoryObject?.amount
                
            }
            
            self.mRenderBudget(self.formBudgetParts(), self.formBudget(), false)

            
        }, error_message: {(error) in
            print(error.errorMessage)
        })
        
        
        
        expensesListenerRegistration.append(listener)
        
    }
    
    public func stopSync() {
        
//        if budgetListenerRegistration != nil {
//            budgetListenerRegistration.remove()
//        }
//
        if incomesListenerRegistration != nil {
            incomesListenerRegistration.remove()
        }
        
        if categoriesListenerRegistration != nil {
            categoriesListenerRegistration.remove()
        }
        
        for listn in expensesListenerRegistration {
            listn.remove()
        }
      
    }
    
    public func formBudget() -> Budget {
    
        
        self.updateMinMaxDate();
        
        self.budget.minRegionDate = self.minRegionDate
        self.budget.maxRegionDate = self.maxRegionDate
        
        return budget
    }
    
    public func getTransactionsDates() -> [Int] {
        var dates:[Int] = []
        for (_, income) in self.incomesDict {
            dates.append(income.insert_date)
        }
        
        for (_, category) in self.categoriesDict {
          
            for(_, expense) in category.expensesDict {
                dates.append(expense.insert_date)
            }
        }
        
        return dates.sorted()
    }
    
    public func formBudgetParts() -> [BudgetSection] {

        var budgetSectionsItems = [BudgetSection]()
        var incomesSectionsItems = [BudgetSection]()
        var categoriesSectionsItems = [BudgetSection]()
        var totalIncomes = 0.0
        var totalBudgets = 0.0
        var totalSpent = 0.0
        
        let stat = BudgetSection(id: 0, title: "", value: self.budget.incomes, budget: self.budget.planned, spent: self.budget.expenses, date: "", type: RowType.stat)
    
        let totalIncomeRow = BudgetSection(id: 1, title: NSLocalizedString("netDisposeIncomes", comment: "Total Income label on the front page") , value: self.budget.incomes, budget: 0, spent: 0, date: "", type: RowType.totalIncome)
        
        let incomesResult = self.incomesDict.sorted {
            $0.value.title < $1.value.title
        }
        
   
        for (_, income) in incomesResult {
            
            let row = BudgetSection(id: 0, title: income.title, value: income.amount, budget: 0, spent: 0, date: Utils.formatTimeStamp(income.transaction_date), type: RowType.income, gid: income.gid)
      
            incomesSectionsItems.append(row!)
            totalIncomes = totalIncomes + income.amount
        }
        
        
        //display expenses
        let totalExpenseRow = BudgetSection(id: 1, title: NSLocalizedString("totalExpenditure", comment: "Total expenditure"), value: self.budget.expenses, budget: 0, spent: self.budget.expenses, date: "", type: RowType.totalCategory)
        //budgetSectionsItems.append(totalExpenseRow!)
        
        
        let categoriesResult = self.categoriesDict.sorted {
            $0.value.title < $1.value.title
        }

        var countCategories = 0
        for (_, category) in categoriesResult {
      
            let row = BudgetSection(id: 2, title: category.title, value: category.amount, budget: category.amount, spent: category.spent, date: "", type: RowType.category, gid: category.gid)
            
            countCategories = countCategories + 1
            row?.isLast = (countCategories == categoriesResult.count)
            
            totalBudgets = totalBudgets + category.amount
            totalSpent = totalSpent + category.spent
            categoriesSectionsItems.append(row!)
        
        }
        
        stat?.value = totalIncomes
        stat?.budget = totalBudgets
        stat?.spent = totalSpent
        stat?.hasInitialBalance = self.budget.initialBalance != 0
        stat?.initialBalance = self.budget.initialBalance
        
        //form budget display
        //header
        budgetSectionsItems.append(stat!)
        //total incomes
        totalIncomeRow?.value = totalIncomes
        
        //close incomes
        if incomesSectionsItems.count > 0 {
            budgetSectionsItems.append(totalIncomeRow!)
            //list incomes
            budgetSectionsItems.append(contentsOf: incomesSectionsItems)
            
            //budgetSectionsItems.append(BudgetSection(id: 0, title: "", value: 0.0, budget: 0, spent: 0, date: "", type: RowType.endSection, gid: "")!)
            
        }
        //total expense
        totalExpenseRow?.value = totalSpent
        totalExpenseRow?.spent = totalSpent
        if categoriesSectionsItems.count > 0 {
            budgetSectionsItems.append(totalExpenseRow!)
            //list categories
            budgetSectionsItems.append(contentsOf: categoriesSectionsItems)
            //budgetSectionsItems.append(BudgetSection(id: 0, title: "", value: 0.0, budget: 0, spent: 0, date: "", type: RowType.endSection, gid: "")!)
        }
        
        if categoriesSectionsItems.count <= 0 && incomesSectionsItems.count <= 0 {
            budgetSectionsItems.append(BudgetSection(id: 0, title: "", value: 0.0, budget: 0, spent: 0, date: "", type: RowType.emptyBudget, gid: "")!)
        }
        
        //close categorie
        //if categoriesResult.count > 0 {
            
            
        //}
        
        
        return budgetSectionsItems
    }
    
    
    public func formBudgetPartsCfp() -> [BudgetSection] {
        
        var budgetSectionsItems = [BudgetSection]()
        
        //display sommary
        let stat = BudgetSection(id: 0, title: "", value: self.budget.incomes, budget: self.budget.planned, spent: self.budget.expenses, date: "", type: RowType.stat)
        
        budgetSectionsItems.append(stat!)
        
        
        //display expenses
        let titleCategory = BudgetSection(id: 0, title: "SPENDING CATEGORY", value: 0, budget: 0, spent: 0, date: "", type: RowType.title)
        budgetSectionsItems.append(titleCategory!)
        
        for (_, category) in self.categoriesDict {
           
            let row = BudgetSection(id: 2, title: category.title, value: category.amount, budget: category.amount, spent: category.spent, date: "", type: RowType.category, gid: category.gid)
            
            budgetSectionsItems.append(row!)
            
        }
        let totalExpenseRow = BudgetSection(id: 1, title: "Total Actual Expenditure", value: self.budget.expenses, budget: 0, spent: self.budget.expenses, date: "", type: RowType.totalCategory)
        budgetSectionsItems.append(totalExpenseRow!)
        
        
        //display income
        let titleIncome = BudgetSection(id: 0, title: "INCOME CATEGORY", value: 0, budget: 0, spent: 0, date: "", type: RowType.title)
        budgetSectionsItems.append(titleIncome!)
        
        
        for (_, income) in self.incomesDict {
            
            let row = BudgetSection(id: 0, title: income.title, value: income.amount, budget: 0, spent: 0, date: Utils.formatTimeStamp(income.transaction_date), type: RowType.income, gid: income.gid)
            budgetSectionsItems.append(row!)
        }
        let totalIncomeRow = BudgetSection(id: 1, title: "Total income Available(NET)" , value: self.budget.incomes, budget: 0, spent: 0, date: "", type: RowType.totalIncome)
        budgetSectionsItems.append(totalIncomeRow!)
        
        //income vs expense
        let titleIncomeVsExpense = BudgetSection(id: 0, title: "ACTUAL INCOME VS EXPENDITURE TO DATE", value: 0, budget: 0, spent: 0, date: "", type: RowType.title)
        budgetSectionsItems.append(titleIncomeVsExpense!)
        
       /* let titleIncomeVsExpenseValue = BudgetSection(id: 0, title: "ACTUAL INCOME VS EXPENDITURE TO DATE", value: self.incomes, budget: self.planned, spent: self.expenses, date: "", type: RowType.incomeVsExpense)*/
        //budgetSectionsItems.append(titleIncomeVsExpenseValue!)
        
        
        
        return budgetSectionsItems
    }
    
    public func getIncome (incomeGid: String) -> Income {
   
        return incomesDict[incomeGid]!
    }
    
    public func getCategory (categoryGid: String) -> CategoryObject {
        
        return categoriesDict[categoryGid]!
    }
    
    
    public func delete(cleaned: @escaping ()->Void) {
        
        print("DeleteTrace:: Delete budget now...")
        
        let fbBudget:FbBudget = FbBudget(reference: self.firestoreRef)
        
        fbBudget.delete(self.formBudget(), cleanUpCompleted: {(count) in
            
            print("DeleteTrace:: Delete next step... \(count)")
            cleaned()
        })
        
        
    }
    
    public func deleteIncomes(){
        
        let fbIncome = FbIncome(reference: self.firestoreRef)
        
        for (_, income) in incomesDict {
            fbIncome.delete(income)
        }
        
    }
    
    public func deleteCategories() {
        
        let fbCategory:FbCategory = FbCategory(reference: self.firestoreRef)
        
        for (_, categoryObject) in categoriesDict {
        
            fbCategory.delete(categoryObject.getCategory())
            self.deleteExpenses(expenses: categoryObject.getExpenses())
        }
        
    }
    
    public func deleteExpenses(expenses: [Expense]){
        
        let fbExpense:FbExpense = FbExpense(reference: self.firestoreRef)
        
        
        for expense in expenses {
            
            fbExpense.delete(expense)
        }
        
    }
    
    
    public func getListCategories() -> [BudgetCategory] {
        
        var categories:[BudgetCategory] = []
        
        let categoriesResult = self.categoriesDict.sorted {
            $0.value.title < $1.value.title
        }
        
        for (_, category) in categoriesResult {
            
            categories.append(category.getCategory())
            
        }
        
        return categories
        
    }
    
    public func updateMinMaxDate()  {
        
        self.minRegionDate = -1
        self.maxRegionDate = -1
        
        
        var incomeList = [Income]()
        
        
        for (_, income) in self.incomesDict {
            
            incomeList.append(income)
        }
        
        
        if (incomeList.count > 0 && incomeList.count == 1) {
            
            self.minRegionDate = incomeList[0].transaction_date
            self.maxRegionDate = incomeList[0].transaction_date
            
        }
        
        if (incomeList.count > 0 && incomeList.count > 1) {
       
            if (incomeList[0].transaction_date > incomeList[1].transaction_date) {
                self.maxRegionDate = incomeList[0].transaction_date
                self.minRegionDate = incomeList[1].transaction_date
            } else {
                self.maxRegionDate = incomeList[1].transaction_date
                self.minRegionDate = incomeList[0].transaction_date
            }
            
            
            for i in 2 ..< incomeList.count {
                
                if (incomeList[i].transaction_date >  self.maxRegionDate) {
                    
                    self.maxRegionDate = incomeList[i].transaction_date
                    
                }else if (incomeList[i].transaction_date <  self.minRegionDate){
                    
                    self.minRegionDate = incomeList[i].transaction_date
                }
                
            }
            
        }
        
        //expense mini max
        
        var expenseList = [Expense]()
        
        
        for (_, categoryObject) in self.categoriesDict {
            
            
            for (_, expense) in categoryObject.expensesDict {
                
                expenseList.append(expense)
            }
        }
        
        if (self.minRegionDate == -1 ||
            self.maxRegionDate == -1) {
        
            if (expenseList.count > 0 && expenseList.count == 1) {
                
                self.minRegionDate = expenseList[0].transaction_date
                self.maxRegionDate = expenseList[0].transaction_date
                
            }
            
            if (expenseList.count > 0 && expenseList.count > 1) {
                
                if (expenseList[0].transaction_date > expenseList[1].transaction_date) {
                    self.maxRegionDate = expenseList[0].transaction_date
                    self.minRegionDate = expenseList[1].transaction_date
                } else {
                    self.maxRegionDate = expenseList[1].transaction_date
                    self.minRegionDate = expenseList[0].transaction_date
                }
                
                for i in 2 ..< expenseList.count {
                    
                    print("config val expense: \(String(describing: expenseList[i].transaction_date))")
                    
                    if (expenseList[i].transaction_date >  self.maxRegionDate) {
                        
                        self.maxRegionDate = expenseList[i].transaction_date
                        
                    }else if (expenseList[i].transaction_date <  self.minRegionDate){
                        
                        self.minRegionDate = expenseList[i].transaction_date
                    }
                    
                }
                
            }

            
        } else if (expenseList.count > 0) {
            
        
            for i in 0 ..< expenseList.count {
                
                print("config val expense: \(String(describing: expenseList[i].transaction_date))")
                if (expenseList[i].transaction_date >  self.maxRegionDate) {
                    
                    self.maxRegionDate = expenseList[i].transaction_date
                    
                }else if (expenseList[i].transaction_date <  self.minRegionDate){
                    
                    self.minRegionDate = expenseList[i].transaction_date
                }
                
            }
            
        }

        
        
    }
    
    
    
    
}
