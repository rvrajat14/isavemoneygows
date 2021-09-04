//
//  Budget.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 6/28/16.
//  Copyright © 2016 UlmatCorpit. All rights reserved.
//

//import Foundation
//import RealmSwift



///-------------createBudget----------------------

import Firebase
import FirebaseDatabase
public class Budget {
    
    public var gid:String!
    public var start_date:Int!
    public var end_date:Int!
    public var type:Int!
    public var expenses:Double!
    public var incomes:Double!
    public var planned:Double!
    public var comment:String!
    public var month_year:String!
    public var active:Int!
    public var status:Int = 1
    public var insert_date:Int!
    public var last_update:Int!
    public var owner:String!
    public var owner_name:String!
    public var last_view:Int = 0
    public var minRegionDate = -1
    public var maxRegionDate = -1
    
    public init() {
        self.gid = ""
        self.start_date = 0
        self.end_date = 0
        self.type = 0
        self.expenses = 0.0
        self.incomes = 0.0
        self.planned = 0.0
        self.comment = ""
        self.month_year = ""
        self.active = 0
        self.insert_date = 0
        self.last_update = 0
        self.owner = ""
        self.owner_name = ""
    }
    public init(gid:String,
         start_date:Int,
         end_date:Int,
         type:Int,
         expenses:Double,
         incomes:Double,
         planned:Double,
         comment:String,
         month_year:String,
         active:Int,
         insert_date:Int,
         last_update:Int,
         owner:String,
         owner_name:String
         ) {
        self.gid = gid
        self.start_date = start_date
        self.end_date = end_date
        self.type = type
        self.expenses = expenses
        self.incomes = incomes
        self.planned = planned
        self.comment = comment
        self.month_year = month_year
        self.active = active
        self.insert_date = insert_date
        self.last_update = last_update
        self.owner = owner
        self.owner_name = owner_name
    }
    public init(snapshot: DataSnapshot!) {
        let value = snapshot.value as? NSDictionary
        
     
        self.gid = snapshot.key
        self.gid = value?["gid"] as? String ?? ""
        self.start_date = value?["start_date"] as? Int ?? 0
        self.end_date = value?["end_date"] as? Int ?? 0
        self.type = value?["type"] as? Int ?? 0
        self.expenses = value?["expenses"] as? Double ?? 0.0
        self.incomes = value?["incomes"] as? Double ?? 0.0
        self.planned = value?["planned"] as? Double ?? 0.0
        self.comment = value?["comment"] as? String ?? ""
        self.month_year = value?["month_year"] as? String ?? ""
        self.active = value?["active"] as? Int ?? 0
        self.insert_date = value?["insert_date"] as? Int ?? 0
        self.last_update = value?["last_update"] as? Int ?? 0
        self.owner = value?["owner"] as? String ?? ""
        self.owner_name = value?["owner_name"] as? String ?? ""
        
    }
    
    public init(value: [String:Any]) {
        
        self.gid = value["gid"] as? String ?? ""
        self.start_date = value["start_date"] as? Int ?? 0
        self.end_date = value["end_date"] as? Int ?? 0
        self.type = value["type"] as? Int ?? 0
        self.expenses = value["expenses"] as? Double ?? 0.0
        self.incomes = value["incomes"] as? Double ?? 0.0
        self.planned = value["planned"] as? Double ?? 0.0
        self.comment = value["comment"] as? String ?? ""
        self.month_year = value["month_year"] as? String ?? ""
        self.active = value["active"] as? Int ?? 0
        self.insert_date = value["insert_date"] as? Int ?? 0
        self.last_update = value["last_update"] as? Int ?? 0
        self.owner = value["owner"] as? String ?? ""
        self.owner_name = value["owner_name"] as? String ?? ""
        
    }
    
    public func setGid (_ gid: String) {
        self.gid = gid
    }
    public func setStartDate (_ start_date: Int) {
        self.start_date = start_date
    }
    public func setEndDate (_ end_date: Int) {
        self.end_date = end_date
    }
    public func setType (_ type: Int) {
        self.type = type
    }
    public func setExpenses (_ expenses: Double) {
        self.expenses = expenses
    }
    public func setIncomes (_ incomes: Double) {
        self.incomes = incomes
    }
    public func setPlanned (_ planned: Double) {
        self.planned = planned
    }
    public func setComment (_ comment: String) {
        self.comment = comment
    }
    public func setMonthYear (_ month_year: String) {
        self.month_year = month_year
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
    public func setOwner (_ owner: String) {
        self.owner = owner
    }
    public func setOwnerName (_ owner_name: String) {
        self.owner_name = owner_name
    }
    public func toAnyObject() -> NSDictionary {
        return [
            "gid": self.gid as String,
            "start_date": self.start_date as Int,
            "end_date": self.end_date as Int,
            "type": self.type as Int,
            "expenses": self.expenses as Double,
            "incomes": self.incomes as Double,
            "planned": self.planned as Double,
            "comment": self.comment as String,
            "month_year": self.month_year as String,
            "active": self.active as Int,
            "insert_date": self.insert_date as Int,
            "last_update": self.last_update as Int,
            "owner": self.owner as String,
            "owner_name": self.owner_name as String,
        ]
    }
}
