//
// FbUser.swift
// iSaveMoney
//
// Created by Armel Koudoum on 1/15/17.
// Copyright © 2017 UlmatCorpit. All rights reserved.
//


///-------------createTransfer----------------------

import Firebase
import FirebaseFirestore
import ISMLBase

public class FbTransfer{
    let dbReference: Firestore
    let TRANSFERS = Const.ENVIRONEMENT+"transfers"
    
    
    
    /** public init(reference: DatabaseReference) **/
    
    public init(reference: Firestore) {
        self.dbReference = reference
    }
    
    
    
    /** public func write() **/
    public func write(_ transfer: Transfer, completion: @escaping (Transfer)->Void, error_message: @escaping (String)->Void) {
        
        let transferRef = self.dbReference.collection(TRANSFERS).document()
        transfer.gid = transferRef.documentID
        self.dbReference
            .collection(TRANSFERS)
            .document(transfer.gid)
            .setData(transfer.toAnyObject() as! [String : Any], completion: {(error) in
                if let error = error {
                    error_message("Unable to create transfer. \(error)")
                }else{
                    completion(transfer)
                }
                
            })
    }
    
    
    
    /** public func update(:Transfer) **/
    public func update(_ transfer: Transfer, completion: @escaping (Transfer)->Void, error_message: @escaping (String)->Void) {
        
        let transferRef = self.dbReference.collection(TRANSFERS).document()
        transfer.gid = transferRef.documentID
        self.dbReference
            .collection(TRANSFERS)
            .document(transfer.gid)
            .updateData(transfer.toAnyObject() as! [String : Any], completion: {(error) in
                if let error = error {
                    error_message("Unable to update transfer. \(error)")
                }else{
                    completion(transfer)
                }
                
            })
    }
    public func ticker(gid: String, state: Int){
        self.dbReference.collection(TRANSFERS).document(gid).updateData(["checked": state])
    }
    
    public func deleteWithGid(_ transfer: String) {
        
    
        self.dbReference.collection(TRANSFERS).document(transfer).delete()
    }
    
    /** public func get(:transfer_gid: String) **/
    public func get(_ transfer_gid: String, listener: @escaping (Transfer) -> Void, error_message: @escaping (String)->Void) {
        
    
        self.dbReference.collection(TRANSFERS)
            .document(transfer_gid).getDocument( completion: { (transferDoc, error) in
            
            
            if let transfer = transferDoc.flatMap({
                $0.data().flatMap({ (data) in
                    return Transfer(dataMap: data)
                })
            }) {
                print("Transfer: \(transfer)")
                listener(transfer)
            } else {
                print("Unable to load the transfer")
                error_message("Unable to load the transfer. \(transfer_gid)")
            }
            
        })
    }
    
    public func getUserTransfers(_ user_gid: String, complete: @escaping ([Transfer])->Void, error_message: @escaping (FbError)->Void) {
        
        
        let query = self.dbReference.collection(TRANSFERS)
            .whereField("user_gid", isEqualTo: user_gid)
        transferReader(query: query, complete: complete, error_message:error_message)
    }
    
    
    public func getAccountTransferTo(_ to_account_gid: String, complete: @escaping ([Transfer])->Void, error_message: @escaping (FbError)->Void) {
        
        
        let query = self.dbReference.collection(TRANSFERS)
            .whereField("to", isEqualTo: to_account_gid)
        transferReader(query: query, complete: complete, error_message:error_message)
    }
    
    public func listenAccountTransferTo(_ to_account_gid: String, complete: @escaping (Transfer)->Void, error_message: @escaping (FbError)->Void) -> ListenerRegistration {
        
        let query = self.dbReference.collection(TRANSFERS)
            .whereField("to", isEqualTo: to_account_gid)
        return transferListener(query: query, complete: complete, error_message:error_message)
    }
    
    public func getAccountTransferFrom(_ from_account_gid: String, complete: @escaping ([Transfer])->Void, error_message: @escaping (FbError)->Void) {
        
        let query = self.dbReference.collection(TRANSFERS)
            .whereField("from", isEqualTo: from_account_gid)
        transferReader(query: query, complete: complete, error_message:error_message)
    }
    
    public func listenAccountTransferFrom(_ from_account_gid: String, complete: @escaping (Transfer)->Void, error_message: @escaping (FbError)->Void) -> ListenerRegistration {
        
        
        let query = self.dbReference.collection(TRANSFERS)
            .whereField("from", isEqualTo: from_account_gid)
        return transferListener(query: query, complete: complete, error_message:error_message)
    }
    
    
    private func transferListener(query: Query,
                                complete: @escaping (Transfer)->Void,
                                error_message: @escaping (FbError)->Void) -> ListenerRegistration {
        return query.addSnapshotListener({querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching documents: \(error!)")
                let errorM:FbError = FbError()
                errorM.errorCode = 101
                errorM.errorMessage = "Error fetching documents: \(error!)"
                error_message(errorM)
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    
                    let transfer = Transfer(dataMap: diff.document.data())
                    transfer.status = 1
                    complete(transfer)
                    
                }
                if (diff.type == .modified) {
                    
                    let transfer = Transfer(dataMap: diff.document.data())
                    transfer.status = 2
                    complete(transfer)
                }
                if (diff.type == .removed) {
                    
                    let transfer = Transfer(dataMap: diff.document.data())
                    transfer.status = -1
                    complete(transfer)
                }
            }
        })
    }
        
    private func transferReader(query: Query, complete: @escaping ([Transfer])->Void, error_message: @escaping (FbError)->Void) {
        query.getDocuments( completion: { (transfersDocs, error)  in
            
            var transafersList = [Transfer]()
            
            if let error = error {
                
                let errorM:FbError = FbError()
                errorM.errorCode = 101
                errorM.errorMessage = "Error getting transfers: \(error)"
                error_message(errorM)
            } else {
                
                for document in transfersDocs!.documents {
                    
                    transafersList.append(Transfer(dataMap: document.data()))
                    
                }
                
                complete(transafersList)
            }
            
        })
    }

}
