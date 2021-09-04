//
// FbUser.swift
// iSaveMoney
//
// Created by Armel Koudoum on 1/15/17.
// Copyright © 2017 UlmatCorpit. All rights reserved.
//


///-------------createPayee----------------------

import Firebase
import FirebaseFirestore
import ISMLBase

public class FbPayee{
    let dbReference: Firestore
    let PAYEES = Environment.ENVIRONEMENT+"payees"
    let EXPENSES = Environment.ENVIRONEMENT+"expenses"
    
    
    
    /** public init(reference: DatabaseReference) **/
    public init() {
        self.dbReference = Firestore.firestore()
    }
    public init(reference: Firestore) {
        self.dbReference = reference
    }
    
    
    
    /** public func write() **/
    public func write(_ payee: Payee, completion: @escaping (Payee)->Void, error_message: @escaping (String)->Void) {
        
        let payeeRef = self.dbReference.collection(PAYEES).document()
        payee.gid = payeeRef.documentID
        
//        self.dbReference
//            .collection(PAYEES)
//            .document(payee.gid)
        payeeRef.setData(payee.toAnyObject() as! [String : Any], completion: {(error) in
                if let error = error {
                    error_message("Unable to create payee. \(error)")
                }else{
                    completion(payee)
                }
                
            })
    }
    
    
    
    /** public func update(:Payee) **/
    public func update(_ payee: Payee, completion: @escaping (Payee)->Void, error_message: @escaping (String)->Void){
        
        self.dbReference
            .collection(PAYEES)
            .document(payee.gid)
            .updateData(payee.toAnyObject() as! [String : Any], completion: {(error) in
                if let error = error {
                    error_message("Unable to update payee. \(error)")
                }else{
                    completion(payee)
                }
                
            })
    }
    
    
    
    /** public func get(:payee_gid: String) **/
    public func get(_ payee_gid: String, listener: @escaping (Payee) -> Void, error_message: @escaping (String)->Void) {
        
        self.dbReference.collection(PAYEES).document(payee_gid).getDocument( completion: { (payeeDoc, error) in
            
            
            if let payee = payeeDoc.flatMap({
                $0.data().flatMap({ (data) in
                    return Payee(dataMap: data)
                })
            }) {
                print("Payee: \(payee)")
                listener(payee)
            } else {
                print("Unable to load the payee")
                error_message("Unable to load the payee. \(payee_gid)")
            }
            
        })
    }
    
    
    
    /** public func delete(:payee_gid: String) **/
    public func delete(_ payee_gid: String) {
        
        self.dbReference.collection(PAYEES).document(payee_gid).delete()
    }
    
    public func getPayeeExpenses(_ user_gid:String, _ payee_gid:String, complete: @escaping ([Expense])->Void, error_message: @escaping (FbError)->Void){
        self.dbReference.collection(EXPENSES)
        .whereField("user_gid", isEqualTo: user_gid)
        .whereField("payee_gid", isEqualTo: payee_gid)
        //.order(by: "transaction_date", descending: true)
        .getDocuments(completion: { (expensesDocs, error)  in
            
            var expensesList = [Expense]()
            
            if let error = error {
                
                let errorM:FbError = FbError()
                errorM.errorCode = 101
                errorM.errorMessage = "Error getting Expenses: \(error)"
                error_message(errorM)
            } else {
                
                for document in expensesDocs!.documents {
                    
                    expensesList.append(Expense(dataMap: document.data()))
                    
                }
                expensesList.sort(by: {$0.transaction_date > $1.transaction_date})
                
                complete(expensesList)
            }
            
        })
    }
    
    
    public func getUserPayee(_ user_gid: String, complete: @escaping ([Payee])->Void, error_message: @escaping (FbError)->Void) {
        
        
        self.dbReference.collection(PAYEES)
            .whereField("user_gid", isEqualTo: user_gid)
            .getDocuments(completion: { (payeesDocs, error)  in
                
                var payeesList = [Payee]()
                
                if let error = error {
                    
                    let errorM:FbError = FbError()
                    errorM.errorCode = 101
                    errorM.errorMessage = "Error getting payees: \(error)"
                    error_message(errorM)
                } else {
                    
                    for document in payeesDocs!.documents {
                        
                        payeesList.append(Payee(dataMap: document.data()))
                        
                    }
                    
                    complete(payeesList)
                }
                
            })
    }

}
