//
//  User.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 12/31/16.
//  Copyright © 2016 UlmatCorpit. All rights reserved.
//





///-------------createUser----------------------

import Firebase
import FirebaseDatabase
public class PUser{
    public var gid:String!
    public var email:String!
    public var pin_code:String!
    public var first_name:String!
    public var last_name:String!
    public var nick_name:String!
    public var budget_selected:String!
    public var previous_budget:String!
    public var insert_date:Int!
    public var last_update:Int!
    public var active:Int!
    public var needmigration:Bool!
    public var version:String = "ios"
    public var preferences:[String:Any] = [:]
    public var country:String!
    public var phone_number:String!
    
    public init() {
        self.gid = ""
        self.email = ""
        self.pin_code = ""
        self.first_name = ""
        self.last_name = ""
        self.nick_name = ""
        self.budget_selected = ""
        self.previous_budget = ""
        self.insert_date = 0
        self.last_update = 0
        self.active = 0
        self.needmigration = false
        self.version = "ios"
        self.preferences = [:]
        self.country = ""
        self.phone_number = ""
    }
    
    public init(gid:String,
                email:String,
                pin_code:String,
                first_name:String,
                last_name:String,
                nick_name:String,
                budget_selected:String,
                previous_budget:String,
                insert_date:Int,
                last_update:Int,
                active:Int,
                needmigration:Bool,
                country:String,
                phone_number:String
    ) {
        self.gid = gid
        self.email = email
        self.pin_code = pin_code
        self.first_name = first_name
        self.last_name = last_name
        self.nick_name = nick_name
        self.budget_selected = budget_selected
        self.previous_budget = previous_budget
        self.insert_date = insert_date
        self.last_update = last_update
        self.active = active
        self.needmigration = needmigration
        self.country = country
        self.phone_number = phone_number
    }
    
    public init(dataMap: [String:Any]) {
        
        self.gid = dataMap["gid"] as? String ?? ""
        self.email = dataMap["email"] as? String ?? ""
        self.pin_code = dataMap["pin_code"] as? String ?? ""
        self.phone_number = dataMap["phone_number"] as? String ?? ""
        self.first_name = dataMap["first_name"] as? String ?? ""
        self.last_name = dataMap["last_name"] as? String ?? ""
        self.nick_name = dataMap["nick_name"] as? String ?? ""
        self.budget_selected = dataMap["budget_selected"] as? String ?? ""
        self.previous_budget = dataMap["previous_budget"] as? String ?? ""
        self.insert_date = dataMap["insert_date"] as? Int ?? 0
        self.last_update = dataMap["last_update"] as? Int ?? 0
        self.active = dataMap["active"] as? Int ?? 0
        self.version = dataMap["version"] as? String ?? "ios"
        self.preferences = dataMap["preferences"] as? [String:Any] ?? [:]
        self.country = dataMap["country"] as? String ?? ""
        self.needmigration = dataMap["needmigration"] as? Bool ?? false
        
        
        
    }
    
    public init(snapshot: DataSnapshot!) {
        let value = snapshot.value as? NSDictionary
        
        
        
        self.gid = snapshot.key
        self.gid = value?["gid"] as? String ?? ""
        self.phone_number = value?["phone_number"] as? String ?? ""
        self.country = value?["country"] as? String ?? ""
        self.email = value?["email"] as? String ?? ""
        self.pin_code = value?["pin_code"] as? String ?? ""
        self.first_name = value?["first_name"] as? String ?? ""
        self.last_name = value?["last_name"] as? String ?? ""
        self.nick_name = value?["nick_name"] as? String ?? ""
        self.budget_selected = value?["budget_selected"] as? String ?? ""
        self.previous_budget = value?["previous_budget"] as? String ?? ""
        self.insert_date = value?["insert_date"] as? Int ?? 0
        self.last_update = value?["last_update"] as? Int ?? 0
        self.active = value?["active"] as? Int ?? 0
        self.version = value?["version"] as? String ?? "ios"
        self.preferences = value?["preferences"] as? [String:Any] ?? [:]
        self.needmigration = value?["needmigration"] as? Bool ?? false
        
        
        
    }
    public func setGid (_ gid: String) {
        self.gid = gid
    }
    public func setEmail (_ email: String) {
        self.email = email
    }
    public func setPinCode (_ pin_code: String) {
        self.pin_code = pin_code
    }
    public func setFirstName (_ first_name: String) {
        self.first_name = first_name
    }
    public func setLastName (_ last_name: String) {
        self.last_name = last_name
    }
    public func setNickName (_ nick_name: String) {
        self.nick_name = nick_name
    }
    public func setBudgetSelected (_ budget_selected: String) {
        self.budget_selected = budget_selected
    }
    public func setPreviousBudget (_ previous_budget: String) {
        self.previous_budget = previous_budget
    }
    public func setInsertDate (_ insert_date: Int) {
        self.insert_date = insert_date
    }
    public func setLastUpdate (_ last_update: Int) {
        self.last_update = last_update
    }
    public func setActive (_ active: Int) {
        self.active = active
    }
    public func setCountry(_ country:String){
        self.country = country
    }
    public func toAnyObject() -> NSDictionary {
        return [
            "gid": self.gid as String,
            "email": self.email as String,
            "pin_code": self.pin_code as String,
            "first_name": self.first_name ?? "",
            "version": self.version,
            "last_name": self.last_name as String,
            "nick_name": self.nick_name as String,
            "budget_selected": self.budget_selected as String,
            "previous_budget": self.previous_budget as String,
            "insert_date": self.insert_date as Int,
            "last_update": self.last_update as Int,
            "active": self.active as Int,
            "version": self.version as String,
            "preferences": self.preferences as [String:Any],
            "needmigration": self.needmigration as Bool,
            "phone_number" : self.phone_number as String,
            "country" : self.country as String
        ]
    }
}
