//
//  FbUserPurchases.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 8/27/18.
//  Copyright © 2018 UlmatCorpit. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

public class FbUserPurchases {
    
    let dbReference: Firestore
    let USER_PURCHASES = Const.ENVIRONEMENT+"user_purchases"
    var mNotifier: ((UserPurchases) -> Void)!
    
    
    /** public init(reference: DatabaseReference) **/
    
    public init(reference: Firestore) {
        self.dbReference = reference
    }
    
    /** public func write() **/
    public func write(_ userPurchases: UserPurchases, listener: @escaping (UserPurchases)->Void) -> Void {
        
        let newUserRef = self.dbReference.collection(USER_PURCHASES).document()
        userPurchases.gid = newUserRef.documentID
    
        let userPurchasesDitionary = userPurchases.toAnyObject()
        self.dbReference.collection(USER_PURCHASES).document(newUserRef.documentID).setData(userPurchasesDitionary as! [String : Any])
        listener(userPurchases)
    
    }
    
    
    
    /** public func update(:UserPurchases) **/
    public func update(_ userPurchases: UserPurchases, listener: @escaping (UserPurchases)->Void) -> Void {
    
        let userPurchasesDitionary = userPurchases.toAnyObject()
        self.dbReference.collection(USER_PURCHASES).document(userPurchases.gid).updateData(userPurchasesDitionary as! [AnyHashable : Any])
        listener(userPurchases)
    }
    
    
    
    public func get(user_purchases_gid:String, notifier: (([UserPurchases]) -> Void)!) {
        
        self.dbReference.collection(USER_PURCHASES).whereField("user_gid", isEqualTo: user_purchases_gid).getDocuments(completion: {(purchasesQuery, error) in
            
            if error != nil {
                let error:FbError = FbError()
                error.errorCode = 101
                error.errorMessage = "Error getting documents: \(error)"
            } else {
                
                var userPurchases:[UserPurchases] = []
                for document in purchasesQuery!.documents {
                    
                    let userPurchase = UserPurchases(dataMap: document.data(), gid: document.documentID)
                    userPurchases.append(userPurchase)
                    
                }
                
                notifier(userPurchases)
                
            }
        })
        
    
    }
    
}
