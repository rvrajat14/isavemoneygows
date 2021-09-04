//
//  UserCollection.swift
//  ISMLDataService
//
//  Created by Sai Akhil on 03/08/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseDatabase
import ISMLBase

public class UserCollection {
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
    
    public func getUser(_ user_gid:String,onComplete: @escaping (PUser)->Void,onError: @escaping (String)->Void){
        let fbUser = FbUser(reference: self.firestoreRef)
        fbUser.get(userGid: user_gid, listner: { user in
            onComplete(user)
        }, error_message: {(error) in
            onError(error)
        })
    }
    
    
    public func update(_ user:PUser,onComplete: @escaping (PUser)->Void,onError: @escaping (String)->Void){
        let fbUser = FbUser(reference: self.firestoreRef)
        fbUser.update(user, completion: {(user) in
            onComplete(user)
        }, error_message: { error in
            onError(error)
        })
    }
    
    public func delete(_ user_gid:String){
        let fbUser = FbUser(reference: self.firestoreRef)
        fbUser.removeUser(user_gid)
    }
    
}
