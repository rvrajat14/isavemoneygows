//
//  Account.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 6/29/16.
//  Copyright © 2016 UlmatCorpit. All rights reserved.
//





///-------------createAccount----------------------

import Firebase
import FirebaseFirestore
import FirebaseDatabase
public class Account{
    public var gid:String!
    public var name:String!
    public var user_gid:String!
    public var type:Int!
    public var balance:Double!
    public var deposit:Double!
    public var withdraw:Double!
    public var active:Int!
    public var expenses:Double = 0.0
    public var incomes:Double = 0.0
    public var transfers_in:Double = 0.0
    public var transfers_out:Double = 0.0
    public var invalid_expenses = 1
    public var invalid_incomes = 1
    public var invalid_transfers_in = 1
    public var invalid_transfers_out = 1
    public var invalid:Int!
    public var insert_date:Int!
    public var last_update:Int!
    public var telephone:String!
    public var address:String!
    public var other_notes:String!
     
    public init() {
        self.gid = ""
        self.name = ""
        self.user_gid = ""
        self.other_notes = ""
        self.telephone = ""
        self.address = ""
        self.type = 0
        self.balance = 0.0
        self.deposit = 0.0
        self.withdraw = 0.0
        self.active = 0
        self.invalid = 1
        self.insert_date = 0
        self.last_update = 0
    }
    public init(gid:String,
         name:String,
         user_gid:String,
         type:Int,
         balance:Double,
         deposit:Double,
         withdraw:Double,
         active:Int,
         invalid:Int,
         insert_date:Int,
         last_update:Int,
         telephone:String,
         address:String,
         other_notes:String
         ) {
        self.gid = gid
        self.name = name
        self.user_gid = user_gid
        self.type = type
        self.balance = balance
        self.deposit = deposit
        self.withdraw = withdraw
        self.active = active
        self.invalid = invalid
        self.insert_date = insert_date
        self.last_update = last_update
        self.other_notes = other_notes
        self.telephone = telephone
        self.address = address
    }
    public init(snapshot: DataSnapshot!) {
        let value = snapshot.value as? NSDictionary
        self.gid = snapshot.key
        self.other_notes = value?["other_notes"] as? String ?? ""
        self.telephone = value?["telephone"] as? String ?? ""
        self.address = value?["address"] as? String ?? ""
        self.gid = value?["gid"] as? String ?? ""
        self.name = value?["name"] as? String ?? ""
        self.user_gid = value?["user_gid"] as? String ?? ""
        self.type = value?["type"] as? Int ?? 0
        self.balance = value?["balance"] as? Double ?? 0.0
        self.deposit = value?["deposit"] as? Double ?? 0.0
        self.withdraw = value?["withdraw"] as? Double ?? 0.0
        self.active = value?["active"] as? Int ?? 0
        
        self.expenses = value?["expenses"] as? Double ?? 0.0
        self.incomes = value?["incomes"] as? Double ?? 0.0
        self.transfers_in = value?["transfers_in"] as? Double ?? 0.0
        self.transfers_out = value?["transfers_out"] as? Double ?? 0.0
        self.invalid_expenses = value?["invalid_expenses"] as? Int ?? 0
        self.invalid_incomes = value?["invalid_incomes"] as? Int ?? 0
        self.invalid_transfers_in = value?["invalid_transfers_in"] as? Int ?? 0
        self.invalid_transfers_out = value?["invalid_transfers_out"] as? Int ?? 0
        
        self.invalid = value?["invalid"] as? Int ?? 0
        self.insert_date = value?["insert_date"] as? Int ?? 0
        self.last_update = value?["last_update"] as? Int ?? 0
    }
    
    public init(dataMap: [String:Any]) {
        
        self.gid = dataMap["gid"] as? String ?? ""
        self.name = dataMap["name"] as? String ?? ""
        self.user_gid = dataMap["user_gid"] as? String ?? ""
        self.type = dataMap["type"] as? Int ?? 0
        self.balance = dataMap["balance"] as? Double ?? 0.0
        self.deposit = dataMap["deposit"] as? Double ?? 0.0
        self.withdraw = dataMap["withdraw"] as? Double ?? 0.0
        self.active = dataMap["active"] as? Int ?? 0
        
        self.expenses = dataMap["expenses"] as? Double ?? 0.0
        self.incomes = dataMap["incomes"] as? Double ?? 0.0
        self.transfers_in = dataMap["transfers_in"] as? Double ?? 0.0
        self.transfers_out = dataMap["transfers_out"] as? Double ?? 0.0
        self.invalid_expenses = dataMap["invalid_expenses"] as? Int ?? 0
        self.invalid_incomes = dataMap["invalid_incomes"] as? Int ?? 0
        self.invalid_transfers_in = dataMap["invalid_transfers_in"] as? Int ?? 0
        self.invalid_transfers_out = dataMap["invalid_transfers_out"] as? Int ?? 0
        
        self.invalid = dataMap["invalid"] as? Int ?? 0
        self.insert_date = dataMap["insert_date"] as? Int ?? 0
        self.last_update = dataMap["last_update"] as? Int ?? 0
        
        self.telephone = dataMap["telephone"] as? String ?? ""
        self.address = dataMap["address"] as? String ?? ""
        self.other_notes = dataMap["other_notes"] as? String ?? ""
    }
    public func setGid (_ gid: String) {
        self.gid = gid
    }
    public func setName (_ name: String) {
        self.name = name
    }
    public func setUserGid (_ user_gid: String) {
        self.user_gid = user_gid
    }
    public func setType (_ type: Int) {
        self.type = type
    }
    public func setBalance (_ balance: Double) {
        self.balance = balance
    }
    public func setDeposit (_ deposit: Double) {
        self.deposit = deposit
    }
    public func setWithdraw (_ withdraw: Double) {
        self.withdraw = withdraw
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
    public func setTelephone (_ telephone: String) {
        self.telephone = telephone
    }
    public func setAddress (_ address: String) {
        self.address = address
    }
    public func setOtherNotes (_ otherNotes: String) {
        self.other_notes = otherNotes
    }
    public func toAnyObject() -> NSDictionary {
        return [
            "gid": self.gid as String,
            "name": self.name as String,
            "user_gid": self.user_gid as String,
            "type": self.type as Int,
            "balance": self.balance as Double,
            "deposit": self.deposit as Double,
            "withdraw": self.withdraw as Double,
            "active": self.active as Int,
            "invalid": self.invalid as Int,
            "insert_date": self.insert_date as Int,
            "last_update": self.last_update as Int,
            "telephone":self.telephone as String,
            "address":self.address as String,
            "other_notes":self.other_notes as String
        ]
    }
}
