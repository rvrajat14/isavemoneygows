//
//  ExpensesCollection.swift
//  ISMLDataService
//
//  Created by Sai Akhil on 18/08/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseDatabase
import ISMLBase

public class ExpensesCollection {
    let firestoreRef: Firestore
    var pref: MyPreferences!
    var mPayerRef:DatabaseQuery!
    var payerDict: [String: Payer]
    
    var mNotifier: (([Expense]) -> Void)!
    
    public init(reference: Firestore) {
        
        self.firestoreRef = reference
        self.pref = MyPreferences()
        payerDict = [:]
    }
    
 
    
    public func getByAccountGid(_ account_gid:String,onComplete: @escaping ([Expense])->Void,onError: @escaping (FbError)->Void){
       let fbExpense:FbExpense = FbExpense(reference: self.firestoreRef)
        
        fbExpense.getByAccountGid(account_gid, complete: {(expenses) in
            
            onComplete(expenses)
            
        }, error_message: {(error) in
            
            onError(error)
        })
    }
    
    
}
