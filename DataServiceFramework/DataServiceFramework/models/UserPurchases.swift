//
//  UserPurchases.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 8/25/18.
//  Copyright © 2018 UlmatCorpit. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
public class UserPurchases {
    
    public var gid: String
    public var user_gid: String
    public var purchased_platform: String //android or ios
    public var order_number: String
    public var order_date: Int
    public var active: Int // 0 for off and 1 for on
    public var description: String
    public var sku: String
    public var insert_date: Int
    public var last_update:Int!
    
    public init() {
        
        self.gid = ""
        self.user_gid = ""
        self.purchased_platform = ""
        self.description = ""
        self.sku = ""
        self.order_number = ""
        self.order_date = 0
        self.active = 0
        self.insert_date = 0
        self.last_update = 0
       
    }
    
    public init(dataMap: [String:Any], gid:String) {
        
        self.gid = gid
        self.gid = dataMap["gid"] as? String ?? ""
        self.user_gid = dataMap["user_gid"] as? String ?? ""
        self.purchased_platform = dataMap["purchased_platform"] as? String ?? ""
        self.description = dataMap["description"] as? String ?? ""
        self.sku = dataMap["sku"] as? String ?? ""
        self.order_number = dataMap["order_number"] as? String ?? ""
        self.order_date = dataMap["order_date"] as? Int ?? 0
        self.active = dataMap["active"] as? Int ?? 0
        self.insert_date = dataMap["insert_date"] as? Int ?? 0
        self.last_update = dataMap["last_update"] as? Int ?? 0
    }
    
    public init(snapshot: DataSnapshot!) {
        let value = snapshot.value as? NSDictionary
        
        self.gid = snapshot.key
        self.gid = value?["gid"] as? String ?? ""
        self.user_gid = value?["user_gid"] as? String ?? ""
        self.purchased_platform = value?["purchased_platform"] as? String ?? ""
        self.description = value?["description"] as? String ?? ""
        self.sku = value?["sku"] as? String ?? ""
        self.order_number = value?["order_number"] as? String ?? ""
        self.order_date = value?["order_date"] as? Int ?? 0
        self.active = value?["active"] as? Int ?? 0
        self.insert_date = value?["insert_date"] as? Int ?? 0
        self.last_update = value?["last_update"] as? Int ?? 0
    }
    
    public func toAnyObject() -> NSDictionary {
        
        return [
            "gid": self.gid as String,
            "user_gid": self.user_gid as String,
            "purchased_platform": self.purchased_platform as String,
            "order_number": self.order_number as String,
            "description": self.description as String,
            "sku": self.sku as String,
            "order_date": self.order_date as Int,
            "active": self.active as Int,
            "insert_date": self.insert_date as Int,
            "last_update": self.last_update as Int
            
        ]
    }
}
