//
// FbUser.swift
// iSaveMoney
//
// Created by Armel Koudoum on 1/15/17.
// Copyright © 2017 UlmatCorpit. All rights reserved.
//


///-------------createIncome----------------------

import Firebase
import FirebaseFirestore

public class FbIncome {
    
    let dbReference: Firestore
    let INCOMES = Const.ENVIRONEMENT+"incomes"
    
    /** public init(reference: DatabaseReference) **/
    public init(reference: Firestore) {
        
        self.dbReference = reference
    }
    
    
    
    /** public func write() **/
    public func write(_ income: Income, completion: @escaping (Income)->Void, error_message: @escaping (String)->Void) {
        
        let incomeRef = self.dbReference.collection(INCOMES).document()
        income.gid = incomeRef.documentID
        self.dbReference
            .collection(INCOMES)
            .document(income.gid)
            .setData(income.toAnyObject() as! [String : Any], completion: {(error) in
                if let error = error {
                    error_message("Unable to create the user profile. \(error)")
                }else{
                    completion(income)
                }
                
            })
        
    }
    
    
    
    /** public func update(:Income) **/
    public func update(_ income: Income , completion: @escaping (Income)->Void, error_message: @escaping (String)->Void){
        self.dbReference
            .collection(INCOMES)
            .document(income.gid)
            .updateData(income.toAnyObject() as! [String : Any], completion: {(error) in
                if let error = error {
                    error_message("Unable to create the user profile. \(error)")
                }else{
                    completion(income)
                }
                
            })
    }
    
    
    
 
    public func get(income_gid:String, listener: @escaping (Income) -> Void, error_message: @escaping (String)->Void) {
        
    
        self.dbReference.collection(INCOMES).document(income_gid).getDocument(completion: { (userDoc, error) in
            
            
            if let income = userDoc.flatMap({
                $0.data().flatMap({ (data) in
                    return Income(dataMap: data)
                })
            }) {
                
                listener(income)
            } else {
                print("Unable to load the income")
                error_message("Unable to load the income. \(income_gid)")
            }
            
        })
        
    }
    
    
    
    /** public func delete(:income_gid: String) **/
    public func delete(_ income: Income) {
        
       self.dbReference.collection(INCOMES).document(income.gid).delete()
        
    }
    
    /** public func getByBudgetGid() **/
    public func getByBudgetGid(_ budget_gid: String, complete: @escaping ([Income])->Void, error_message: @escaping (FbError)->Void) {
        
        self.dbReference.collection(INCOMES)
            .whereField("budget_gid", isEqualTo: budget_gid)
            .order(by: "title")
            .getDocuments(completion: { (incomesDocs, error)  in
                
                var incomesList = [Income]()
                
                if let error = error {
                    
                    let errorM:FbError = FbError()
                    errorM.errorCode = 101
                    errorM.errorMessage = "Error getting incomes: \(error)"
                    error_message(errorM)
                } else {
                    
                    for document in incomesDocs!.documents {
                        
                        incomesList.append(Income(dataMap: document.data()))
                        
                    }
                    
                    complete(incomesList)
                }
                
            })
        
    }
    
    /** public func getByAccountGid() **/
    public func getByAccountGid(_ account_gid: String, complete: @escaping ([Income])->Void, error_message: @escaping (FbError)->Void) {
        
        
        self.dbReference.collection(INCOMES)
            .whereField("account_gid", isEqualTo: account_gid)
            .getDocuments(completion: { (incomesDocs, error)  in
                
                var incomesList = [Income]()
                
                if let error = error {
                    
                    let errorM:FbError = FbError()
                    errorM.errorCode = 101
                    errorM.errorMessage = "Error getting incomes: \(error)"
                    error_message(errorM)
                } else {
                    
                    for document in incomesDocs!.documents {
                        
                        incomesList.append(Income(dataMap: document.data()))
                        
                    }
                    
                    complete(incomesList)
                }
                
            })
        
    }
    
    public func getByBudgetGidSync(_ budget_gid: String,
                        complete: @escaping (Income)->Void,
                        error_message: @escaping (FbError)->Void) -> ListenerRegistration {
        
        return self.dbReference.collection(INCOMES)
            .whereField("budget_gid", isEqualTo: budget_gid)
            .order(by: "title")
            .addSnapshotListener({querySnapshot, error in
                
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
                        
                        let income = Income(dataMap: diff.document.data())
                        income.status = 1
                        complete(income)
                        
                    }
                    if (diff.type == .modified) {
                        
                        let income = Income(dataMap: diff.document.data())
                        income.status = 2
                        complete(income)
                    }
                    if (diff.type == .removed) {
                        
                        let income = Income(dataMap: diff.document.data())
                        income.status = -1
                        complete(income)
                    }
                }
                
                
                
            })
        
        
    }
        
    
    public func getByPayerGid(_ payer_gid: String,  complete: @escaping ([Income])->Void, error_message: @escaping (FbError)->Void) {
        
        
        self.dbReference.collection(INCOMES)
            .whereField("payer_gid", isEqualTo: payer_gid)
            .order(by: "insert_date", descending: true)
            .getDocuments(completion: { (incomesDocs, error)  in
                
                var incomesList = [Income]()
                
                if let error = error {
                    
                    let errorM:FbError = FbError()
                    errorM.errorCode = 101
                    errorM.errorMessage = "Error getting incomes: \(error)"
                    error_message(errorM)
                } else {
                    
                    for document in incomesDocs!.documents {
                        
                        incomesList.append(Income(dataMap: document.data()))
                        
                    }
                    
                    complete(incomesList)
                }
                
            })
    }
    
    
}
