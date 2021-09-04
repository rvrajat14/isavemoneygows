//
//  ExpenseRow.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 12/8/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit

public class ExpenseRow:Expense {
    
    public static let HEADER:Int = 0
    public static let EXPENSE:Int = 1
     
    public var type:Int!
    public var budget:Double!
    public var spent:Double!
    public var remaining:Double!
    
    public override init() {
       super.init()
    }
    
    public init(expense:Expense) {
        
        super.init()
        self.gid = expense.gid
        self.budget_gid = expense.budget_gid
        self.user_gid = expense.user_gid
        self.category_gid = expense.category_gid
        self.category_str = expense.category_str
        self.payee_gid = expense.payee_gid
        self.payee_str = expense.payee_str
        self.account_gid = expense.account_gid
        self.account_str = expense.account_str
        self.schedule_gid = expense.schedule_gid
        self.title = expense.title
        self.amount = expense.amount
        self.comment = expense.comment
        self.transaction_date = expense.transaction_date
        self.active = expense.active
        self.insert_date = expense.insert_date
        self.last_update = expense.last_update
    }
}
