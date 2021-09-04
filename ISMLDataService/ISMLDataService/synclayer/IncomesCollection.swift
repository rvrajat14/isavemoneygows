//
//  IncomesCollection.swift
//  ISMLDataService
//
//  Created by Sai Akhil on 31/07/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseDatabase
import ISMLBase

public class IncomesCollection {
    let firestoreRef: Firestore
    var pref: MyPreferences!
    var mPayerRef:DatabaseQuery!
    var payerDict: [String: Payer]
    
    var mNotifier: (([Income]) -> Void)!
    
    public init(reference: Firestore) {
        
        self.firestoreRef = reference
        self.pref = MyPreferences()
        payerDict = [:]
    }
    
    
    public func getByPayerGid(_ payer_gid:String,onComplete: @escaping ([Income])->Void,onError: @escaping (FbError)->Void){
        let fbIncome:FbIncome = FbIncome(reference: self.firestoreRef)
        
        fbIncome.getByPayerGid(self.pref.getUserIdentifier(), payer_gid, complete: {(incomes) in
            
            onComplete(incomes)
            
        }, error_message: {(error) in
            
            onError(error)
        })
    }
    
    public func getByAccountGid(_ account_gid:String,onComplete: @escaping ([Income])->Void,onError: @escaping (FbError)->Void){
        let fbIncome:FbIncome = FbIncome(reference: self.firestoreRef)
        
        fbIncome.getByAccountGid(account_gid, complete: {(incomes) in
            
            onComplete(incomes)
            
        }, error_message: {(error) in
            
            onError(error)
        })
    }
    
    
}
