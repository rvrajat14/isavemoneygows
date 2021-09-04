//
//  PayeesCollection.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 4/9/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseDatabase

public class PayeesCollection {
    
    let firestoreRef: Firestore
    var pref: MyPreferences!
    var mPayeeRef:DatabaseQuery!
    var payeeDict: [String: Payee]
    var mNotifier: (([Payee]) -> Void)!
    
    public init(reference: Firestore) {
        
        self.firestoreRef = reference
        self.pref = MyPreferences()
        payeeDict = [:]
    }

    public func startSync(notifier: @escaping ([Payee]) -> Void) {
    
        self.mNotifier = notifier
        self.startSync()
    }
    
    public func startSync()  {
        
        
        print("Payee startSync()")
        
        let fbPayee:FbPayee = FbPayee(reference: self.firestoreRef)
        
        fbPayee.getUserPayee(self.pref.getUserIdentifier(), complete: {(payees) in
            
            for payee in payees {
                self.payeeDict[payee.gid] = payee
            }
            
            if self.mNotifier != nil {
                self.mNotifier(self.getPayee())
            }
            
        }, error_message: {(error) in
            
            print(error.errorMessage)
        })
        
    
    }
    
    
    public func getPayee() -> [Payee] {
        
        var mPayee:[Payee] = []
        
        for (_, payee) in payeeDict {
        
            mPayee.append(payee)
        }
        
        mPayee = mPayee.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
        
        return mPayee
    }
}
