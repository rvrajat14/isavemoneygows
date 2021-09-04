//
//  Label.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/12/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import Firebase
import FirebaseDatabase

public class Label {
    
    public var gid:String!
    public var color:Int!
    public var user_gid:String!
    public var title:String!
    public var amount:Double!
    public var comment:String!
    public var transaction_date:String!
    public var active:Int!
    public var insert_date:Int!
    public var last_update:Int!
    
    public init() {
        self.gid = ""
        self.color = -1
        self.user_gid = ""
        self.title = ""
        self.amount = 0.0
        self.comment = ""
        self.active = 0
        self.insert_date = 0
        self.last_update = 0
    }
    
    public init(snapshot: DataSnapshot!) {
        let value = snapshot.value as? NSDictionary
        self.gid = snapshot.key
        self.color = value?["color"] as? Int ?? -1
        self.user_gid = value?["user_gid"] as? String ?? ""
        self.title = value?["title"] as? String ?? ""
        self.amount = value?["amount"] as? Double ?? 0.0
        self.comment = value?["comment"] as? String ?? ""
        self.active = value?["active"] as? Int ?? 0
        self.insert_date = value?["insert_date"] as? Int ?? 0
        self.last_update = value?["last_update"] as? Int ?? 0
    }
    
    public func toAnyObject() -> NSDictionary {
        return [
            "gid": self.gid as String,
            "color": self.color as Int,
            "user_gid": self.user_gid as String,
            "title": self.title as String,
            "amount": self.amount as Double,
            "comment": self.comment as String,
            "active": self.active as Int,
            "insert_date": self.insert_date as Int,
            "last_update": self.last_update as Int
        ]
    }
}
