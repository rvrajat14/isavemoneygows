//
//  PayersCollection.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 4/9/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseDatabase

public class PayersCollection {
    
    let firestoreRef: Firestore
    var pref: MyPreferences!
    var mPayerRef:DatabaseQuery!
    var payerDict: [String: Payer]
    
    var mNotifier: (([Payer]) -> Void)!
    
    public init(reference: Firestore) {
        
        self.firestoreRef = reference
        self.pref = MyPreferences()
        payerDict = [:]
    }
    
    public func startSync(notifier: @escaping ([Payer]) -> Void){
    
        self.mNotifier = notifier
        self.startSync()
    }
    
    
    public func startSync()  {
        
        
        print("Payer .startSync()")
        
        let fbPayer:FbPayer = FbPayer(reference: self.firestoreRef)
        fbPayer.getUserPayer(self.pref.getUserIdentifier(), complete: {(payers) in
            
            for payer in payers {
                
                self.payerDict[payer.gid] = payer
            }
            
            if self.mNotifier != nil {
                self.mNotifier(self.getPayer())
            }
            
        }, error_message: {(error) in
            
            print(error)
        })
        
        
        
    }
    
  
    
    public func getPayer() -> [Payer] {
        
        var mPayer:[Payer] = []
        
        for (_, payer) in payerDict {
            
            mPayer.append(payer)
        }
        mPayer = mPayer.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
        
        return mPayer
    }
    
}
