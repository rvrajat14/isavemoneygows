//
//  JSONBudget.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 11/28/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//
import Foundation
import UIKit
import ISMLDataService
import ISMLBase

class JSONBudget:NSObject {
    
    var budgetObject:BudgetObject!
    var budget:Budget!
    
    public init(budget_object:BudgetObject){
        budgetObject = budget_object
    }
    
    func makeJson() -> [String: Any] {
    
        var budgetJSON:[String: Any] = [:]
        budget = budgetObject.formBudget()
        budgetJSON = budget.toAnyObject() as! [String : Any]
    
    
        budgetJSON["lang"] = NSLocalizedString("userLang", comment: "en")
        budgetJSON["net_dispose_income"] = NSLocalizedString("netDisposeIncomes", comment: "")
        budgetJSON["total_expenditure"] = NSLocalizedString("totalExpenditure", comment: "")
        budgetJSON["budget_month"] = IsmUtils.makeTitleFor(budget: budget)
        budgetJSON["incomes"] = self.getIncomes(budgetObject: budgetObject)
        budgetJSON["categories"] = self.getCategories(budgetObject: budgetObject)
        
        //labels
        budgetJSON["budget_name"] = NSLocalizedString("csvTitle", comment: "budget title")
        budgetJSON["sheet_budget"] = NSLocalizedString("sheet_budget", comment: "title")
        budgetJSON["sheet_actual"] = NSLocalizedString("sheet_actual", comment: "title")
        budgetJSON["sheet_variance"] = NSLocalizedString("sheet_variance", comment: "title")
        budgetJSON["sheet_incomes"] = NSLocalizedString("sheet_incomes", comment: "title")
        budgetJSON["sheet_expenses"] = NSLocalizedString("sheet_expenses", comment: "title")
        budgetJSON["sheet_saving"] = NSLocalizedString("sheet_saving", comment: "title")
       
    
        return budgetJSON;
    }
    
    
    func getIncomes(budgetObject:BudgetObject) -> [NSDictionary] {
    
        var incomes:[NSDictionary] = []

    
        for (_, income) in (budgetObject.incomesDict as [String:Income]) {
    
            incomes.append(income.toAnyObject())
    
        }
    
        return incomes
    }
    
    
    func getCategories(budgetObject:BudgetObject) -> [NSDictionary] {
    
        var categories:[NSDictionary] = []
    
        for (_, categoryObject) in (budgetObject.categoriesDict as [String:CategoryObject]) {
            
            var categoryDico:[String : Any] = categoryObject.getCategory().toAnyObject() as! [String : Any]
            categoryDico["expenses"] = self.getExpenses(categoryObj: categoryObject)
            categories.append(categoryDico as NSDictionary)
            
        }
      
        return categories;
    }
    
    
    func getExpenses(categoryObj:CategoryObject) -> [NSDictionary]{
    
        var expenses:[NSDictionary] = []
        
        for (_, expense) in (categoryObj.expensesDict as [String: Expense]) {
    
            expenses.append(expense.toAnyObject())
        
        }
        
        return expenses
    }
}
