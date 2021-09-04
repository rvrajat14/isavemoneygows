//
//  FbMessage.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 4/18/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

public class FbMessage {
    
    let dbReference: DatabaseReference
    let MESSAGES = Const.ENVIRONEMENT+"messages"
    
    public init(reference: DatabaseReference) {
        self.dbReference = reference
    }
    
    
    public func write(_ message: Message) -> String {
        
        let key = self.dbReference.child("\(MESSAGES)/\(message.to_user)").childByAutoId().key!
        message.gid = key
        let messageDitionary = message.toAnyObject()
        let childUpdates = ["\(MESSAGES)/\(message.to_user)/\(key)": messageDitionary]
        self.dbReference.updateChildValues(childUpdates)
        return message.gid
    }
    
    
    
    public func get(_ user_gid: String) -> DatabaseQuery {
        return self.dbReference.child("\(MESSAGES)/\(user_gid)")
    }
    
    
    public func delete(_ message: Message) {
        
        self.dbReference.child("\(MESSAGES)/\(message.to_user)/\(message.gid)").removeValue()
    }
    
}
