//
//  FbPreferences.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 8/27/18.
//  Copyright © 2018 UlmatCorpit. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

public class FbPreferences {
    
    let dbReference: Firestore
    let PREFERENCES = Const.ENVIRONEMENT+"preferences"
    var mNotifier: ((Preferences) -> Void)!
    
    
    /** public init(reference: Firestore) **/
    
    public init(reference: Firestore) {
        
         self.dbReference = reference
    }
    
    public func savePreference(preferences: [String:Any], user_gid:String) {
        
        var pref = preferences
        pref["gid"] = user_gid
        pref["prefUserIdentifier"] = user_gid
        self.dbReference.collection(PREFERENCES).document(user_gid).updateData(pref)
        
    }
    
    public func savePref(user_gid:String, key:String, value:Any) {
        
        self.dbReference.collection(PREFERENCES).document(user_gid).setData([key:value], merge: true)
        
    }
    
    /** public func write() **/
    public func write(_ preferences: Preferences) -> String {
        
        if preferences.gid != nil {
            let preferencesDitionary = preferences.toAnyObject()
            
        self.dbReference.collection(PREFERENCES).document(preferences.gid).setData(preferencesDitionary)
            
        }
        
        return preferences.gid
    }
    
    
    
    /** public func update(:UserPurchases) **/
    public func update(_ preferences: Preferences) -> Void {
        
        if preferences.gid != nil {
            let preferencesDitionary = preferences.toAnyObject()
        self.dbReference.collection(PREFERENCES).document(preferences.gid).updateData(preferencesDitionary)
            
        }
    }
    
    
    /** public func get(notifier: ((Preferences) -> Void)!) **/
    public func get(user_gid:String,
             notifier: @escaping (Preferences) -> Void,
             errorReturn: @escaping (FbError)->Void) {
        
        self.dbReference.collection(PREFERENCES)
            .document(user_gid).getDocument(completion: { (documentQuery, error) in
                
                
                if let preferences = documentQuery.flatMap({
                    $0.data().flatMap({ (data) in
                        return Preferences(value: data)
                    })
                }) {
                    print("Preferences: \(preferences)")
                    notifier(preferences)
                } else {
                    var errorMessage = FbError()
                    errorMessage.errorMessage = "Unable to load the user preferences associated with the email."
                    print("Error getting documents: \(error)")
                    errorReturn(errorMessage)
                }
                
                
                
            })
        
    }


    
}

