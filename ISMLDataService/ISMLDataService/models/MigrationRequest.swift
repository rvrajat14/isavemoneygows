//
//  MigrationRequest.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 9/24/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import Foundation
import Firebase
public class MigrationRequest {
    
    public var  gid:String
    public var  email:String
    public var  status:Bool = true
    public var  insert_date:Int
    
    
    public init() {
        self.gid = ""
        self.email = ""
        self.status = true
        self.insert_date = 0
    }
    
    
    public func toAnyObject() -> NSDictionary {
        
        return [
            "gid": self.gid as String,
            "email": self.email as String,
            "status": self.status as Bool,
            "insert_date": self.insert_date as Int
        ]
    }

    
}
