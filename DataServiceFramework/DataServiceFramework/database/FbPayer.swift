//
// FbUser.swift
// iSaveMoney
//
// Created by Armel Koudoum on 1/15/17.
// Copyright © 2017 UlmatCorpit. All rights reserved.
//


///-------------createPayer----------------------

import Firebase
import FirebaseFirestore

public class FbPayer{
    let dbReference: Firestore
    let PAYERS = Const.ENVIRONEMENT+"payers"
    
    
    
    /** public init(reference: DatabaseReference) **/
    
    public init(reference: Firestore) {
        self.dbReference = reference
    }
    
    
    
    /** public func write() **/
    public func write(_ payer: Payer, completion: @escaping (Payer)->Void, error_message: @escaping (String)->Void) {
        
        let payerRef = self.dbReference.collection(PAYERS).document()
        payer.gid = payerRef.documentID
        
        self.dbReference
            .collection(PAYERS)
            .document(payer.gid)
            .setData(payer.toAnyObject() as! [String : Any], completion: {(error) in
                if let error = error {
                    error_message("Unable to create payer. \(error)")
                }else{
                    completion(payer)
                }
                
            })
    }
    
    
    
    /** public func update(:Payer) **/
    public func update(_ payer: Payer, completion: @escaping (Payer)->Void, error_message: @escaping (String)->Void) {
        
        self.dbReference
            .collection(PAYERS)
            .document(payer.gid)
            .updateData(payer.toAnyObject() as! [String : Any], completion: {(error) in
                if let error = error {
                    error_message("Unable to update payer. \(error)")
                }else{
                    completion(payer)
                }
                
            })
    }
    
    
    public func get(_ payer_gid: String, listener: @escaping (Payer) -> Void, error_message: @escaping (String)->Void) {
        
        self.dbReference.collection(PAYERS).document(payer_gid).getDocument( completion: { (payerDoc, error) in
            
            
            if let payer = payerDoc.flatMap({
                $0.data().flatMap({ (data) in
                    return Payer(dataMap: data)
                })
            }) {
                print("Payer: \(payer)")
                listener(payer)
            } else {
                print("Unable to load the payer")
                error_message("Unable to load the payer. \(payer_gid)")
            }
            
        })
    }
    
    
    
    /** public func delete(:payer_gid: String) **/
    public func delete(_ payer_gid: String) {
        
        self.dbReference.collection(PAYERS).document(payer_gid).delete()
    }
    
    public func getUserPayer(_ user_gid: String, complete: @escaping ([Payer])->Void, error_message: @escaping (FbError)->Void) {
        
        
        self.dbReference.collection(PAYERS)
            .whereField("user_gid", isEqualTo: user_gid)
            .getDocuments( completion: { (payersDocs, error)  in
                
                var payersList = [Payer]()
                
                if let error = error {
                    
                    let errorM:FbError = FbError()
                    errorM.errorCode = 101
                    errorM.errorMessage = "Error getting payers: \(error)"
                    error_message(errorM)
                } else {
                    
                    for document in payersDocs!.documents {
                        
                        payersList.append(Payer(dataMap: document.data()))
                        
                    }
                    
                    complete(payersList)
                }
                
            })
    }
}
