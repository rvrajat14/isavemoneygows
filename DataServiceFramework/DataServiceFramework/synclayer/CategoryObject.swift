//
//  CategoryObject.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 4/10/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
public class CategoryObject {
    
    var gid:String!
    var category_gid:String!
    var user_gid:String!
    var budget_gid:String!
    var category_root:String!
    var type:Int!
    var title:String!
    var amount:Double!
    var spent:Double!
    var comment:String!
    var active:Int!
    var invalid:Int = 1
    var insert_date:Int!
    var last_update:Int!
    var pref: MyPreferences!
    
    var mRenderCategory: (([Expense], BudgetCategory, Bool) -> Void)!
    
    public var expensesDict: [String: Expense]
    
    
    public init(dataMap: [String:Any]) {
        
        expensesDict = [:]
        
       
        self.gid = dataMap["gid"] as? String ?? ""
        self.category_gid = dataMap["category_gid"] as? String ?? ""
        self.user_gid = dataMap["user_gid"] as? String ?? ""
        self.budget_gid = dataMap["budget_gid"] as? String ?? ""
        self.category_root = dataMap["category_root"] as? String ?? ""
        self.type = dataMap["type"] as? Int ?? 0
        self.title = dataMap["title"] as? String ?? ""
        self.amount = dataMap["amount"] as? Double ?? 0.0
        self.spent = 0.0
        self.comment = dataMap["comment"] as? String ?? ""
        self.active = dataMap["active"] as? Int ?? 0
        self.invalid = dataMap["invalid"] as? Int ?? 1
        self.insert_date = dataMap["insert_date"] as? Int ?? 0
        self.last_update = dataMap["last_update"] as? Int ?? 0
    }
    

    
    public func initCategory(snapshot: DataSnapshot!) {
        
        let value = snapshot.value as? NSDictionary
        
        self.gid = snapshot.key
        self.gid = value?["gid"] as? String ?? ""
        self.category_gid = value?["category_gid"] as? String ?? ""
        self.user_gid = value?["user_gid"] as? String ?? ""
        self.budget_gid = value?["budget_gid"] as? String ?? ""
        self.category_root = value?["category_root"] as? String ?? ""
        self.type = value?["type"] as? Int ?? 0
        self.title = value?["title"] as? String ?? ""
        self.amount = value?["amount"] as? Double ?? 0.0
        self.spent = 0.0
        self.comment = value?["comment"] as? String ?? ""
        self.active = value?["active"] as? Int ?? 0
        self.invalid = value?["invalid"] as? Int ?? 1
        self.insert_date = value?["insert_date"] as? Int ?? 0
        self.last_update = value?["last_update"] as? Int ?? 0
    }
    


    public func getExpenses() -> [Expense] {
        
        var expenses:[Expense] = []
        
        let expensesResult = self.expensesDict.sorted {
            $0.value.transaction_date < $1.value.transaction_date
        }
        
        for (_, expense) in expensesResult {
            expenses.append(expense)
        }
        
        return expenses
    }
    
    public func getCategory() -> BudgetCategory {
        
        let category = BudgetCategory()
        
        category.gid = self.gid
        category.category_gid = self.category_gid
        category.user_gid = self.user_gid
        category.budget_gid = self.budget_gid
        category.category_root = self.category_root
        category.type = self.type
        category.title = self.title
        category.amount = self.amount
        category.spent = self.spent
        category.comment = self.comment
        category.active = self.active
        category.invalid = self.invalid
        category.insert_date = self.insert_date
        category.last_update = self.last_update
        
        return category
        
    }
    
    public func addExpense(expense: Expense)  {
        
        expensesDict[expense.gid] = expense
        
        self.spent = 0.0
        for (_, oExpense) in expensesDict {
            
            self.spent =  self.spent + oExpense.amount
        }
    }
    
    public func removeExpense(expense: Expense)  {
        
        expensesDict[expense.gid] = nil
        
        self.spent = 0.0
        for (_, oExpense) in expensesDict {
            
            self.spent =  self.spent + oExpense.amount
        }
    }
    
    public func categoryChanged(snapshot: DataSnapshot!) {
        
        let value = snapshot.value as? NSDictionary
        
        self.category_gid = value?["category_gid"] as? String ?? ""
        self.user_gid = value?["user_gid"] as? String ?? ""
        self.budget_gid = value?["budget_gid"] as? String ?? ""
        self.category_root = value?["category_root"] as? String ?? ""
        self.type = value?["type"] as? Int ?? 0
        self.title = value?["title"] as? String ?? ""
        self.amount = value?["amount"] as? Double ?? 0.0
        self.spent = 0.0
        self.comment = value?["comment"] as? String ?? ""
        self.active = value?["active"] as? Int ?? 0
        self.invalid = value?["invalid"] as? Int ?? 1
        self.insert_date = value?["insert_date"] as? Int ?? 0
        self.last_update = value?["last_update"] as? Int ?? 0
    }

}
