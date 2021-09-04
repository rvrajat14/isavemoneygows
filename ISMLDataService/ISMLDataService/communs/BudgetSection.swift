//
//  BudgetSection.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 6/11/16.
//  Copyright © 2016 UlmatCorpit. All rights reserved.
//

import UIKit

public class BudgetSection {
    
    public var gid:String!
    public var id: Int!
    public var title: String!
    public var value: Double
    public var budget: Double!
    public var spent: Double!
    public var date: String!
    public var type: RowType
    public var edit: Bool
    public var items:[String] = []
    public var active = 0
    public var isLast = false
    public var hasInitialBalance = false
    public var initialBalance = 0.0
    
    
    public init?(id: Int?, title:String?, value: Double, budget: Double?, spent: Double?, date: String?, type: RowType) {
        
        self.id = id
        self.title = title
        self.value = value
        self.budget = budget
        self.spent = spent
        self.date = date
        self.type = type
        self.edit = false
        
        
    
    }
    
    public init?(id: Int?, title:String?, value: Double, budget: Double?, spent: Double?, date: String?, type: RowType, gid: String?) {
        
        self.id = id
        self.title = title
        self.value = value
        self.budget = budget
        self.spent = spent
        self.date = date
        self.type = type
        self.edit = false
        self.gid = gid
        
    }
    public func toAnyObject() -> NSDictionary {
        return [
        "gid":self.gid,
        "id":self.id,
        "title":self.title,
        "value":self.value,
        "budget":self.budget,
        "spent":self.spent,
        "date":self.date,
        "type":self.type,
        "edit":self.edit,
        "items":self.items,
        "active":self.active
            ]
    }
}
