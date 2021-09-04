//
//  Category.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 6/29/16.
//  Copyright © 2016 UlmatCorpit. All rights reserved.
//





///-------------createCategory----------------------

import Firebase
import FirebaseDatabase
public class BudgetCategory{
    public var gid:String!
    public var category_gid:String!
    public var user_gid:String!
    public var budget_gid:String!
    public var category_root:String!
    public var type:Int!
    public var title:String!
    public var amount:Double!
    public var spent:Double!
    public var comment:String!
    public var active:Int!
    public var invalid:Int = 1
    public var status:Int = 1
    public var insert_date:Int!
    public var last_update:Int!
    
    public init() {
        self.gid = ""
        self.category_gid = ""
        self.user_gid = ""
        self.budget_gid = ""
        self.category_root = ""
        self.type = 0
        self.title = ""
        self.amount = 0.0
        self.spent = 0.0
        self.comment = ""
        self.active = 0
        self.invalid = 1
        self.insert_date = 0
        self.last_update = 0
    }
    public init(gid:String,
         category_gid:String,
         user_gid:String,
         budget_gid:String,
         category_root:String,
         type:Int,
         title:String,
         amount:Double,
         spent:Double,
         comment:String,
         active:Int,
         insert_date:Int,
         last_update:Int
         ) {
        self.gid = gid
        self.category_gid = category_gid
        self.user_gid = user_gid
        self.budget_gid = budget_gid
        self.category_root = category_root
        self.type = type
        self.title = title
        self.amount = amount
        self.spent = spent
        self.comment = comment
        self.active = active
        self.active = invalid
        self.insert_date = insert_date
        self.last_update = last_update
    }
    public init(snapshot: DataSnapshot!) {
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
        self.spent = value?["spent"] as? Double ?? 0.0
        self.comment = value?["comment"] as? String ?? ""
        self.active = value?["active"] as? Int ?? 0
        self.invalid = value?["invalid"] as? Int ?? 1
        self.insert_date = value?["insert_date"] as? Int ?? 0
        self.last_update = value?["last_update"] as? Int ?? 0
    }
    
    
    public init(dataMap: [String:Any]) {
        
        self.gid = dataMap["gid"] as? String ?? ""
        self.category_gid = dataMap["category_gid"] as? String ?? ""
        self.user_gid = dataMap["user_gid"] as? String ?? ""
        self.budget_gid = dataMap["budget_gid"] as? String ?? ""
        self.category_root = dataMap["category_root"] as? String ?? ""
        self.type = dataMap["type"] as? Int ?? 0
        self.title = dataMap["title"] as? String ?? ""
        self.amount = dataMap["amount"] as? Double ?? 0.0
        self.spent = dataMap["spent"] as? Double ?? 0.0
        self.comment = dataMap["comment"] as? String ?? ""
        self.active = dataMap["active"] as? Int ?? 0
        self.invalid = dataMap["invalid"] as? Int ?? 1
        self.insert_date = dataMap["insert_date"] as? Int ?? 0
        self.last_update = dataMap["last_update"] as? Int ?? 0
    }
    public func setGid (_ gid: String) {
        self.gid = gid
    }
    public func setCategoryGid (_ category_gid: String) {
        self.category_gid = category_gid
    }
    public func setUserGid (_ user_gid: String) {
        self.user_gid = user_gid
    }
    public func setBudgetGid (_ budget_gid: String) {
        self.budget_gid = budget_gid
    }
    public func setCategoryRoot (_ category_root: String) {
        self.category_root = category_root
    }
    public func setType (_ type: Int) {
        self.type = type
    }
    public func setTitle (_ title: String) {
        self.title = title
    }
    public func setAmount (_ amount: Double) {
        self.amount = amount
    }
    public func setSpent (_ spent: Double) {
        self.spent = spent
    }
    public func setComment (_ comment: String) {
        self.comment = comment
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
            "category_gid": self.category_gid as String,
            "user_gid": self.user_gid as String,
            "budget_gid": self.budget_gid as String,
            "category_root": self.category_root as String,
            "type": self.type as Int,
            "title": self.title as String,
            "amount": self.amount as Double,
            "spent": self.spent as Double,
            "comment": self.comment as String,
            "active": self.active as Int,
            "insert_date": self.insert_date as Int,
            "last_update": self.last_update as Int
        ]
    }
}
