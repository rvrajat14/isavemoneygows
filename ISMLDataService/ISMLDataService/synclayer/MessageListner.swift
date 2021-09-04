//
//  MessageListner.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 4/18/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import ISMLBase

public class MessageListner {
    
    let dbReference: DatabaseReference
    var pref: MyPreferences!
    var mMessageRef:DatabaseQuery!
    
    var mNotifier: ((Message) -> Void)!
    
    public init(reference: DatabaseReference) {
        
        self.dbReference = reference
        self.pref = MyPreferences()
    }
    
    public func startSync(notifier: @escaping (Message) -> Void){
        
        self.mNotifier = notifier
        self.startSync()
    }
    
    
    public func startSync()  {
        
        self.stopSync()
        print("Payer .startSync()")
        
        let fbMessage:FbMessage = FbMessage(reference: self.dbReference)
        
        
        mMessageRef = fbMessage.get(self.pref.getUserIdentifier())
        
        //Child added
        mMessageRef.observe(.childAdded, with: {(snapshotMessage) -> Void in
            
            print("Message .childAdded")
            
            let message = Message(snapshot: snapshotMessage )
            
            if message.gid != "" {
                
                if self.mNotifier != nil {
                    self.mNotifier(message)
                }
            }
            
        })
        
    }
    
    public func stopSync() {
        print("Message .stopSync()")
        
        mMessageRef?.removeAllObservers()
    }
    
    
}
