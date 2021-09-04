//
// FbUser.swift
// iSaveMoney
//
// Created by Armel Koudoum on 1/15/17.
// Copyright © 2017 UlmatCorpit. All rights reserved.
//
import Firebase
import FirebaseFirestore
public class FbAccount{
    let dbReference: Firestore
    let ACCOUNTS = Const.ENVIRONEMENT+"accounts"
    
    
    
    /** public init(reference: DatabaseReference) **/
    
    public init(reference: Firestore) {
        self.dbReference = reference
    }
    
    
    
    /** public func write() **/
    public func write(_ account: Account, completion: @escaping (Account)->Void, error_message: @escaping (String)->Void) {
        
        let incomeRef = self.dbReference.collection(ACCOUNTS).document()
        account.gid = incomeRef.documentID
        
    self.dbReference.collection(ACCOUNTS).document(account.gid).setData(account.toAnyObject() as! [String : Any], completion: {(error) in
            if let error = error {
                error_message("Unable to create the account. \(error)")
            }else{
                completion(account)
            }
        })
        
    }
    
    
    
    /** public func update(:Account) **/
    public func update(_ account: Account, completion: @escaping (Account)->Void, error_message: @escaping (String)->Void) {
        
    self.dbReference.collection(ACCOUNTS).document(account.gid).updateData(account.toAnyObject() as! [String : Any], completion: {(error) in
            if let error = error {
                error_message("Unable to create the account. \(error)")
            }else{
                completion(account)
            }
        })
    }
    

    
    /** public func get(:account_gid: String) **/

        
    public func get(account_gid:String, listener: @escaping (Account) -> Void, error_message: @escaping (String)->Void) {
        
        self.dbReference.collection(ACCOUNTS).document(account_gid).getDocument( completion: { (userDoc, error) in
            
            
            if let account = userDoc.flatMap({
                $0.data().flatMap({ (data) in
                    return Account(dataMap: data)
                })
            }) {
                print("Account: \(account)")
                listener(account)
            } else {
                print("Unable to load the account")
                error_message("Unable to load the income. \(account_gid)")
            }
            
        })
        
    }
    
    
    
    
    /** public func delete(:account_gid: String) **/
    public func delete(_ account_gid: String) {
        self.dbReference.collection(ACCOUNTS).document(account_gid).delete()
    }
    
    
    public func getUserAccounts(_ user_gid: String, complete: @escaping ([Account])->Void, error_message: @escaping (FbError)->Void) {
        
        
        self.dbReference.collection(ACCOUNTS)
            .whereField("user_gid", isEqualTo: user_gid)
            .getDocuments(completion: { (accountsDocs, error)  in
                
                var accountsList = [Account]()
                
                if let error = error {
                    
                    let errorM:FbError = FbError()
                    errorM.errorCode = 101
                    errorM.errorMessage = "Error getting accounta: \(error)"
                    error_message(errorM)
                } else {
                    
                    for document in accountsDocs!.documents {
                        
                        accountsList.append(Account(dataMap: document.data()))
                        
                    }
                    
                    complete(accountsList)
                }
                
            })
    }
}
