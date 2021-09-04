//
//  Transfer.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 12/30/16.
//  Copyright © 2016 UlmatCorpit. All rights reserved.
//





///-------------createTransfer----------------------

import Firebase
import FirebaseDatabase
public class Transfer{
    public var gid:String!
    public var user_gid:String!
    public var from:String!
    public var from_str:String!
    public var to:String!
    public var to_str:String!
    public var schedule_gid:String!
    public var note:String!
    public var type:Int!
    public var amount:Double!
    public var comment:String!
    public var transaction_date:Int!
    public var insert_date:Int!
    public var last_update:Int!
    public var active:Int!
    public var checked:Int!
    
    public init() {
        self.gid = ""
        self.user_gid = ""
        self.from = ""
        self.from_str = ""
        self.to = ""
        self.to_str = ""
        self.schedule_gid = ""
        self.note = ""
        self.type = 0
        self.amount = 0.0
        self.comment = ""
        self.transaction_date = 0
        self.insert_date = 0
        self.last_update = 0
        self.active = 0
        self.checked = 0
    }
    public init(gid:String,
         user_gid:String,
         from:String,
         from_str:String,
         to:String,
         to_str:String,
         schedule_gid:String,
         note:String,
         type:Int,
         amount:Double,
         comment:String,
         transaction_date:Int,
         insert_date:Int,
         last_update:Int,
         active:Int,
         checked:Int
         ) {
        self.gid = gid
        self.user_gid = user_gid
        self.from = from
        self.from_str = from_str
        self.to = to
        self.to_str = to_str
        self.schedule_gid = schedule_gid
        self.note = note
        self.type = type
        self.amount = amount
        self.comment = comment
        self.transaction_date = transaction_date
        self.insert_date = insert_date
        self.last_update = last_update
        self.active = active
        self.checked = checked
    }
    public init(snapshot: DataSnapshot!) {
        let value = snapshot.value as? NSDictionary
        self.gid = snapshot.key
        self.gid = value?["gid"] as? String ?? ""
        self.user_gid = value?["user_gid"] as? String ?? ""
        self.from = value?["from"] as? String ?? ""
        self.from_str = value?["from_str"] as? String ?? ""
        self.to = value?["to"] as? String ?? ""
        self.to_str = value?["to_str"] as? String ?? ""
        self.schedule_gid = value?["schedule_gid"] as? String ?? ""
        self.note = value?["note"] as? String ?? ""
        self.type = value?["type"] as? Int ?? 0
        self.amount = value?["amount"] as? Double ?? 0.0
        self.comment = value?["comment"] as? String ?? ""
        self.transaction_date = value?["transaction_date"] as? Int ?? 0
        self.insert_date = value?["insert_date"] as? Int ?? 0
        self.last_update = value?["last_update"] as? Int ?? 0
        self.active = value?["active"] as? Int ?? 0
        self.checked = value?["checked"] as? Int ?? 0
    }
    
    public init(dataMap: [String:Any]) {
        
        self.gid = dataMap["gid"] as? String ?? ""
        self.user_gid = dataMap["user_gid"] as? String ?? ""
        self.from = dataMap["from"] as? String ?? ""
        self.from_str = dataMap["from_str"] as? String ?? ""
        self.to = dataMap["to"] as? String ?? ""
        self.to_str = dataMap["to_str"] as? String ?? ""
        self.schedule_gid = dataMap["schedule_gid"] as? String ?? ""
        self.note = dataMap["note"] as? String ?? ""
        self.type = dataMap["type"] as? Int ?? 0
        self.amount = dataMap["amount"] as? Double ?? 0.0
        self.comment = dataMap["comment"] as? String ?? ""
        self.transaction_date = dataMap["transaction_date"] as? Int ?? 0
        self.insert_date = dataMap["insert_date"] as? Int ?? 0
        self.last_update = dataMap["last_update"] as? Int ?? 0
        self.active = dataMap["active"] as? Int ?? 0
        self.checked = dataMap["checked"] as? Int ?? 0
    }
    public func setGid (_ gid: String) {
        self.gid = gid
    }
    public func setUserGid (_ user_gid: String) {
        self.user_gid = user_gid
    }
    public func setFrom (_ from: String) {
        self.from = from
    }
    public func setFromStr (_ from_str: String) {
        self.from_str = from_str
    }
    public func setTo (_ to: String) {
        self.to = to
    }
    public func setToStr (_ to_str: String) {
        self.to_str = to_str
    }
    public func setScheduleGid (_ schedule_gid: String) {
        self.schedule_gid = schedule_gid
    }
    public func setNote (_ note: String) {
        self.note = note
    }
    public func setType (_ type: Int) {
        self.type = type
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
    public func setInsertDate (_ insert_date: Int) {
        self.insert_date = insert_date
    }
    public func setLastUpdate (_ last_update: Int) {
        self.last_update = last_update
    }
    public func setActive (_ active: Int) {
        self.active = active
    }
    public func toAnyObject() -> NSDictionary {
        return [
            "gid": self.gid as String,
            "user_gid": self.user_gid as String,
            "from": self.from as String,
            "from_str": self.from_str as String,
            "to": self.to as String,
            "to_str": self.to_str as String,
            "schedule_gid": self.schedule_gid as String,
            "note": self.note as String,
            "type": self.type as Int,
            "amount": self.amount as Double,
            "comment": self.comment as String,
            "transaction_date": self.transaction_date as Int,
            "insert_date": self.insert_date as Int,
            "last_update": self.last_update as Int,
            "active": self.active as Int,
            "checked": self.checked as Int
        ]
    }
    
    public func fromAnyObject(value: NSDictionary!) {
        
        self.gid = value?["gid"] as? String ?? ""
        self.user_gid = value?["user_gid"] as? String ?? ""
        self.from = value?["from"] as? String ?? ""
        self.from_str = value?["from_str"] as? String ?? ""
        self.to = value?["to"] as? String ?? ""
        self.to_str = value?["to_str"] as? String ?? ""
        self.schedule_gid = value?["schedule_gid"] as? String ?? ""
        self.note = value?["note"] as? String ?? ""
        self.type = value?["type"] as? Int ?? 0
        self.amount = value?["amount"] as? Double ?? 0.0
        self.comment = value?["comment"] as? String ?? ""
        self.transaction_date = value?["transaction_date"] as? Int ?? 0
        self.insert_date = value?["insert_date"] as? Int ?? 0
        self.last_update = value?["last_update"] as? Int ?? 0
        self.active = value?["active"] as? Int ?? 0
        self.checked = value?["checked"] as? Int ?? 0
    }
}
