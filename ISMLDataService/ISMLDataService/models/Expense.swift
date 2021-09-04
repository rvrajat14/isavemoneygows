//
//  Expense.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 6/29/16.
//  Copyright © 2016 UlmatCorpit. All rights reserved.
//





///-------------createExpense----------------------

import Firebase
import FirebaseDatabase
public class Expense{
    public var gid:String!
    public var budget_gid:String!
    public var user_gid:String!
    public var category_gid:String!
    public var category_str:String!
    public var payee_gid:String!
    public var payee_str:String!
    public var account_gid:String!
    public var account_str:String!
    public var schedule_gid:String!
    public var title:String!
    public var amount:Double!
    public var comment:String!
    public var transaction_date:Int!
    public var active:Int!
    public var status:Int = 1
    public var insert_date:Int!
    public var last_update:Int!
    public var checked:Int!
    
    public init() {
        self.gid = ""
        self.budget_gid = ""
        self.user_gid = ""
        self.category_gid = ""
        self.category_str = ""
        self.payee_gid = ""
        self.payee_str = ""
        self.account_gid = ""
        self.account_str = ""
        self.schedule_gid = ""
        self.title = ""
        self.amount = 0.0
        self.comment = ""
        self.transaction_date = 0
        self.active = 0
        self.insert_date = 0
        self.last_update = 0
        self.checked = 0
    }
    public init(gid:String,
         budget_gid:String,
         user_gid:String,
         category_gid:String,
         category_str:String,
         payee_gid:String,
         payee_str:String,
         account_gid:String,
         account_str:String,
         schedule_gid:String,
         title:String,
         amount:Double,
         comment:String,
         transaction_date:Int,
         active:Int,
         insert_date:Int,
         last_update:Int,
         checked:Int
         ) {
        self.gid = gid
        self.budget_gid = budget_gid
        self.user_gid = user_gid
        self.category_gid = category_gid
        self.category_str = category_str
        self.payee_gid = payee_gid
        self.payee_str = payee_str
        self.account_gid = account_gid
        self.account_str = account_str
        self.schedule_gid = schedule_gid
        self.title = title
        self.amount = amount
        self.comment = comment
        self.transaction_date = transaction_date
        self.active = active
        self.insert_date = insert_date
        self.last_update = last_update
        self.checked = checked
    }
    public init(snapshot: DataSnapshot!) {
        let value = snapshot.value as? NSDictionary
        self.gid = snapshot.key
        self.gid = value?["gid"] as? String ?? ""
        self.budget_gid = value?["budget_gid"] as? String ?? ""
        self.user_gid = value?["user_gid"] as? String ?? ""
        self.category_gid = value?["category_gid"] as? String ?? ""
        self.category_str = value?["category_str"] as? String ?? ""
        self.payee_gid = value?["payee_gid"] as? String ?? ""
        self.payee_str = value?["payee_str"] as? String ?? ""
        self.account_gid = value?["account_gid"] as? String ?? ""
        self.account_str = value?["account_str"] as? String ?? ""
        self.schedule_gid = value?["schedule_gid"] as? String ?? ""
        self.title = value?["title"] as? String ?? ""
        self.amount = value?["amount"] as? Double ?? 0.0
        self.comment = value?["comment"] as? String ?? ""
        self.transaction_date = value?["transaction_date"] as? Int ?? 0
        self.active = value?["active"] as? Int ?? 0
        self.insert_date = value?["insert_date"] as? Int ?? 0
        self.last_update = value?["last_update"] as? Int ?? 0
        self.checked = value?["checked"] as? Int ?? 0
    }
    
    public init(dataMap: [String:Any]) {
       
        self.gid = dataMap["gid"] as? String ?? ""
        self.budget_gid = dataMap["budget_gid"] as? String ?? ""
        self.user_gid = dataMap["user_gid"] as? String ?? ""
        self.category_gid = dataMap["category_gid"] as? String ?? ""
        self.category_str = dataMap["category_str"] as? String ?? ""
        self.payee_gid = dataMap["payee_gid"] as? String ?? ""
        self.payee_str = dataMap["payee_str"] as? String ?? ""
        self.account_gid = dataMap["account_gid"] as? String ?? ""
        self.account_str = dataMap["account_str"] as? String ?? ""
        self.schedule_gid = dataMap["schedule_gid"] as? String ?? ""
        self.title = dataMap["title"] as? String ?? ""
        self.amount = dataMap["amount"] as? Double ?? 0.0
        self.comment = dataMap["comment"] as? String ?? ""
        self.transaction_date = dataMap["transaction_date"] as? Int ?? 0
        self.active = dataMap["active"] as? Int ?? 0
        self.insert_date = dataMap["insert_date"] as? Int ?? 0
        self.last_update = dataMap["last_update"] as? Int ?? 0
        self.checked = dataMap["checked"] as? Int ?? 0
    }
    public func setGid (_ gid: String) {
        self.gid = gid
    }
    public func setBudgetGid (_ budget_gid: String) {
        self.budget_gid = budget_gid
    }
    public func setUserGid (_ user_gid: String) {
        self.user_gid = user_gid
    }
    public func setCategoryGid (_ category_gid: String) {
        self.category_gid = category_gid
    }
    public func setCategoryStr (_ category_str: String) {
        self.category_str = category_str
    }
    public func setPayeeGid (_ payee_gid: String) {
        self.payee_gid = payee_gid
    }
    public func setPayeeStr (_ payee_str: String) {
        self.payee_str = payee_str
    }
    public func setAccountGid (_ account_gid: String) {
        self.account_gid = account_gid
    }
    public func setAccountStr (_ account_str: String) {
        self.account_str = account_str
    }
    public func setScheduleGid (_ schedule_gid: String) {
        self.schedule_gid = schedule_gid
    }
    public func setTitle (_ title: String) {
        self.title = title
    }
    public func setAmount (_ amount: Double) {
        self.amount = amount
    }
    public func setComment (_ comment: String) {
        self.comment = comment
    }
    public func setTransactionDate (_ transaction_date: Int) {
        self.transaction_date = transaction_date
    }
    public func setActive (_ active: Int) {
        self.active = active
    }
    public func setInsertDate (_ insert_date: Int) {
        self.insert_date = insert_date
    }
    public func setLastUpdate (_ last_update: Int) {
        self.last_update = last_update
    }
    public func toAnyObject() -> NSDictionary {
        return [
            "gid": self.gid as String,
            "budget_gid": self.budget_gid as String,
            "user_gid": self.user_gid as String,
            "category_gid": self.category_gid as String,
            "category_str": self.category_str as String,
            "payee_gid": self.payee_gid as String,
            "payee_str": self.payee_str as String,
            "account_gid": self.account_gid as String,
            "account_str": self.account_str as String,
            "schedule_gid": self.schedule_gid as String,
            "title": self.title as String,
            "amount": self.amount as Double,
            "comment": self.comment as String,
            "transaction_date": self.transaction_date as Int,
            "active": self.active as Int,
            "insert_date": self.insert_date as Int,
            "last_update": self.last_update as Int,
            "checked": self.checked as Int
        ]
    }
    
    
    public func fromAnyObject(value: NSDictionary!) {
        
        self.gid = value?["gid"] as? String ?? ""
        self.budget_gid = value?["budget_gid"] as? String ?? ""
        self.user_gid = value?["user_gid"] as? String ?? ""
        self.category_gid = value?["category_gid"] as? String ?? ""
        self.category_str = value?["category_str"] as? String ?? ""
        self.payee_gid = value?["payee_gid"] as? String ?? ""
        self.payee_str = value?["payee_str"] as? String ?? ""
        self.account_gid = value?["account_gid"] as? String ?? ""
        self.account_str = value?["account_str"] as? String ?? ""
        self.schedule_gid = value?["schedule_gid"] as? String ?? ""
        self.title = value?["title"] as? String ?? ""
        self.amount = value?["amount"] as? Double ?? 0.0
        self.comment = value?["comment"] as? String ?? ""
        self.transaction_date = value?["transaction_date"] as? Int ?? 0
        self.active = value?["active"] as? Int ?? 0
        self.insert_date = value?["insert_date"] as? Int ?? 0
        self.last_update = value?["last_update"] as? Int ?? 0
        self.checked = value?["checked"] as? Int ?? 0
    }
}
