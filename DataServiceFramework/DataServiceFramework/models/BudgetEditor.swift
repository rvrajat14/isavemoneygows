//
//  BudgetEditors.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 6/19/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import Foundation

public class BudgetEditor {
    
    public var gid: String
    public var userGid:String
    public var budgetGid:String
    public var user_name:String
    public var user_email:String
    public var status:Int = 1
    
    public init(gid:String, usergid:String, budgetgid:String, username:String, useremail:String){
        
        self.gid = gid
        self.userGid = usergid
        self.budgetGid = budgetgid
        self.user_name = username
        self.user_email = useremail
    }
    
    public init(dataMap: [String : Any]) {
        
        self.gid = dataMap["gid"] as? String ?? ""
        self.userGid = dataMap["userGid"] as? String ?? ""
        self.budgetGid = dataMap["budgetGid"] as? String ?? ""
        self.user_name = dataMap["user_name"] as? String ?? ""
        self.user_email = dataMap["user_email"] as? String ?? ""
    
    }
    
    public func toAnyObject() -> NSDictionary {
        return [
            "gid": self.gid as String,
            "userGid": self.userGid as String,
            "budgetGid": self.budgetGid as String,
            "user_name": self.user_name as String,
            "user_email": self.user_email as String
            
        ]
    }
}
