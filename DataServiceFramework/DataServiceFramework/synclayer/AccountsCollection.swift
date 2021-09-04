//
//  AccountsCollection.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 4/9/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

public class AccountsCollection {
    
    let firestoreRef: Firestore
    var pref: MyPreferences!
   
    var accountsDict: [String: Account]
    
    public init(reference: Firestore) {
        
        self.firestoreRef = reference
        self.pref = MyPreferences()
        accountsDict = [:]
    }
    
    
    public func startSync()  {
        
       
        print("Account .startSync()")
        
        let fbAccount:FbAccount = FbAccount(reference: self.firestoreRef)
        
        fbAccount.getUserAccounts(self.pref.getUserIdentifier(), complete: {(accounts) in
            
            for account in accounts {
                self.accountsDict[account.gid] = account
            }
        }, error_message: {(error) in
            
            print(error.errorMessage)
        })
        
        
    }
    
    
    
    public func getAccount() -> [Account] {
        
        var mAccount:[Account] = []
        
        for (_, account) in accountsDict {
            
            mAccount.append(account)
        }
        
        mAccount = mAccount.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
        
        return mAccount
    }
    

}
