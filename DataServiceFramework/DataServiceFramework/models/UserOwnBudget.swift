//
//  UserOwnBudgets.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 6/19/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import Foundation

public class UserOwnBudget {
    
    public var gid:String
    public var userGid:String
    public var budgetGid:String
    public var owner:String
    public var budgetTitle:String
    public var start_date:Int
    public var end_date:Int
    public var last_used:Int = 0
    public var active:Int = 1
    public var status:Int = 1
    public var unread:Bool = false
    
    public init(gid:String, usergid:String, budgetGid:String, owner:String, budgetTitle:String, startdate:Int, enddate:Int, last_used:Int, active:Int){
        
        self.gid = gid
        self.userGid = usergid
        self.budgetGid = budgetGid
        self.owner = owner
        self.budgetTitle = budgetTitle
        self.start_date = startdate
        self.end_date = enddate
        self.last_used = last_used
        self.active = active
        
        
    }
    
    public init(dataMap: [String : Any]) {
        
        self.gid = dataMap["gid"] as? String ?? ""
        self.userGid = dataMap["userGid"] as? String ?? ""
        self.budgetGid = dataMap["budgetGid"] as? String ?? ""
        self.owner = dataMap["owner"] as? String ?? ""
        self.budgetTitle = dataMap["budgetTitle"] as? String ?? ""
        self.start_date = dataMap["start_date"] as? Int ?? 0
        self.end_date = dataMap["end_date"] as? Int ?? 0
        self.last_used = dataMap["last_used"] as? Int ?? 0
        self.active = dataMap["active"] as? Int ?? 0
        self.unread = dataMap["unread"] as? Bool ?? false
        
    }
    
    public func toAnyObject() -> NSDictionary {
        return [
            "gid": self.gid as String,
            "userGid": self.userGid as String,
            "budgetGid": self.budgetGid as String,
            "owner": self.owner as String,
            "budgetTitle": self.budgetTitle as String,
            "start_date": self.start_date as Int,
            "end_date": self.end_date as Int,
            "last_used": self.last_used as Int,
            "active": self.active as Int,
            "unread": self.unread as Bool
            
        ]
    }
}
