//
//  Message.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 4/18/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

public class Message {
    
    public var gid: String
    public var from_user: String
    public var to_user: String
    public var title: String
    public var body: String
    public var insert_date:Int
    public var last_update:Int
    
    
    public init() {
        self.gid = ""
        self.from_user = ""
        self.to_user = ""
        self.title = ""
        self.body = ""
        self.insert_date = 0
        self.last_update = 0
    }
    
    
    public init(snapshot: DataSnapshot!) {
        
        let value = snapshot.value as? NSDictionary
        self.gid = snapshot.key
        self.gid = value?["gid"] as? String ?? ""
        self.from_user = value?["from_user"] as? String ?? ""
        self.to_user = value?["to_user"] as? String ?? ""
        self.title = value?["title"] as? String ?? ""
        self.body = value?["body"] as? String ?? ""
        self.insert_date = value?["insert_date"] as? Int ?? 0
        self.last_update = value?["last_update"] as? Int ?? 0
        
    }
    
    public func toAnyObject() -> NSDictionary {
        
        return [
            "gid": self.gid as String,
            "from_user": self.from_user as String,
            "to_user": self.to_user as String,
            "title": self.title as String,
            "body": self.body as String,
            "insert_date": self.insert_date as Int,
            "last_update": self.last_update as Int
        ]
    }

    
}
