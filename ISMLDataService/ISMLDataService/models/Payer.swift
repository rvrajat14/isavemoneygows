//
//  Payer.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 6/29/16.
//  Copyright © 2016 UlmatCorpit. All rights reserved.
//




///-------------createPayer----------------------

import Firebase
import FirebaseDatabase
public class Payer{
    public var gid:String!
    public var user_gid:String!
    public var name:String!
    public var telephone:String!
    public var address:String!
    public var active:Int!
    public var insert_date:Int!
    public var last_update:Int!
    public var total_amount:Double!
    public var other_notes:String!
    
    public init() {
        self.gid = ""
        self.user_gid = ""
        self.name = ""
        self.telephone = ""
        self.address = ""
        self.active = 0
        self.insert_date = 0
        self.last_update = 0
        self.total_amount = 0.0
        self.other_notes = ""
    }
    public init(gid:String,
         user_gid:String,
         name:String,
         telephone:String,
         address:String,
         active:Int,
         insert_date:Int,
         last_update:Int,
         total_amount:Double,
         other_notes:String
         ) {
        self.gid = gid
        self.user_gid = user_gid
        self.name = name
        self.telephone = telephone
        self.address = address
        self.active = active
        self.insert_date = insert_date
        self.last_update = last_update
        self.total_amount = total_amount
        self.other_notes = other_notes
    }
    public init(snapshot: DataSnapshot!) {
        let value = snapshot.value as? NSDictionary
        self.gid = snapshot.key
        self.gid = value?["gid"] as? String ?? ""
        self.user_gid = value?["user_gid"] as? String ?? ""
        self.name = value?["name"] as? String ?? ""
        self.telephone = value?["telephone"] as? String ?? ""
        self.address = value?["address"] as? String ?? ""
        self.active = value?["active"] as? Int ?? 0
        self.insert_date = value?["insert_date"] as? Int ?? 0
        self.last_update = value?["last_update"] as? Int ?? 0
        self.total_amount = value?["total_amount"] as? Double ?? 0
        self.other_notes = value?["other_notes"] as? String ?? ""
    }
    
    public init(dataMap: [String:Any]) {
        
        self.gid = dataMap["gid"] as? String ?? ""
        self.user_gid = dataMap["user_gid"] as? String ?? ""
        self.name = dataMap["name"] as? String ?? ""
        self.telephone = dataMap["telephone"] as? String ?? ""
        self.address = dataMap["address"] as? String ?? ""
        self.active = dataMap["active"] as? Int ?? 0
        self.insert_date = dataMap["insert_date"] as? Int ?? 0
        self.last_update = dataMap["last_update"] as? Int ?? 0
        self.total_amount = dataMap["total_amount"] as? Double ?? 0
        self.other_notes = dataMap["other_notes"] as? String ?? ""
    }
    public func setGid (_ gid: String) {
        self.gid = gid
    }
    public func setUserGid (_ user_gid: String) {
        self.user_gid = user_gid
    }
    public func setName (_ name: String) {
        self.name = name
    }
    public func setTelephone (_ telephone: String) {
        self.telephone = telephone
    }
    public func setAddress (_ address: String) {
        self.address = address
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
    public func setTotalAmount(_ total_amount:Double){
        self.total_amount = total_amount
    }
    
    public func setOtherNotes(_ other_notes:String){
        self.other_notes = other_notes
    }
    public func toAnyObject() -> NSDictionary {
        return [
            "gid": self.gid as String,
            "user_gid": self.user_gid as String,
            "name": self.name as String,
            "telephone": self.telephone as String,
            "address": self.address as String,
            "active": self.active as Int,
            "insert_date": self.insert_date as Int,
            "last_update": self.last_update as Int,
            "total_amount":self.total_amount as Double,
            "other_notes":self.other_notes as String
        ]
    }
}
