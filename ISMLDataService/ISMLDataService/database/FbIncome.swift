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
import ISMLBase

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
    
    public func write(_ income: Income) {
        
        let incomeRef = self.dbReference.collection(INCOMES).document()
        income.gid = incomeRef.documentID
        self.dbReference
            .collection(INCOMES)
            .document(income.gid)
            .setData(income.toAnyObject() as! [String : Any])
        
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
    
    public func update(_ income: Income){
        self.dbReference
            .collection(INCOMES)
            .document(income.gid)
            .updateData(income.toAnyObject() as! [String : Any])
    }
    
    
    public func ticker(gid: String, state: Int){
        self.dbReference.collection(INCOMES).document(gid).updateData(["checked": state])
    }
    
    /** public func delete(:income_gid: String) **/
    public func delete(_ income: Income) {
        
       self.dbReference.collection(INCOMES).document(income.gid).delete()
        
    }
    public func deleteWithGid(_ incomeGid: String) {
        
       self.dbReference.collection(INCOMES).document(incomeGid).delete()
        
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
    
   
    
    /** public func getByBudgetGid() **/
    public func getIncomesForDates(userGid: String, startDate sdate: Int, endDate edate: Int, complete: @escaping ([Income])->Void, error_message: @escaping (FbError)->Void) {
        
        let query = self.dbReference.collection(INCOMES)
            .whereField("user_gid", isEqualTo: userGid)
            .whereField("transaction_date", isGreaterThanOrEqualTo: sdate)
            .whereField("transaction_date", isLessThanOrEqualTo: edate)
            
        incomeReader(query: query,  complete: complete, error_message: error_message)
        
    }
    
    public func getIncomesForBugdts(budgetGids: [String], startDate sdate: Int, endDate edate: Int, complete: @escaping ([Income])->Void, error_message: @escaping (FbError)->Void) {
        
        let query = self.dbReference.collection(INCOMES)
            .whereField("budget_gid", in: budgetGids)
            .whereField("transaction_date", isGreaterThanOrEqualTo: sdate)
            .whereField("transaction_date", isLessThanOrEqualTo: edate)
            
        incomeReader(query: query,  complete: complete, error_message: error_message)
        
    }
    
    public func getByBudgetGid(_ budget_gid: String, complete: @escaping ([Income])->Void, error_message: @escaping (FbError)->Void) {
        
        let query = self.dbReference.collection(INCOMES)
            .whereField("budget_gid", isEqualTo: budget_gid)
            .order(by: "title")
            
        return incomeReader(query: query,  complete: complete, error_message: error_message)
        
    }
    
    /** public func getByAccountGid() **/
    public func getByAccountGid(_ account_gid: String, complete: @escaping ([Income])->Void, error_message: @escaping (FbError)->Void) {
        
        
        let query = self.dbReference.collection(INCOMES)
            .whereField("account_gid", isEqualTo: account_gid)
            
        incomeReader(query: query, complete: complete, error_message: error_message)
    }
    
    public func listenByAccountGid(_ account_gid: String, complete: @escaping (Income)->Void, error_message: @escaping (FbError)->Void) -> ListenerRegistration {
        
        
        let query = self.dbReference.collection(INCOMES)
            .whereField("account_gid", isEqualTo: account_gid)
            
        return incomeListener(query: query, complete: complete, error_message: error_message)
    }
    
    public func getByBudgetGidSync(_ budget_gid: String,
                        complete: @escaping (Income)->Void,
                        error_message: @escaping (FbError)->Void) -> ListenerRegistration {
        
        let query =  self.dbReference.collection(INCOMES)
            .whereField("budget_gid", isEqualTo: budget_gid)
            .order(by: "title")
        
        return incomeListener(query: query, complete: complete, error_message: error_message)
            
    }
    
    public func getByPayerGid(_ user_gid:String,_ payer_gid: String,  complete: @escaping ([Income])->Void, error_message: @escaping (FbError)->Void){
        
        
        let query = self.dbReference.collection(INCOMES)
            //.whereField("user_gid", isEqualTo: user_gid)
            .whereField("payer_gid", isEqualTo: payer_gid)
            
        incomeReader(query: query, complete: complete, error_message: error_message)
    }
    public func listenByPayerGid(_ user_gid:String,_ payer_gid: String,  complete: @escaping (Income)->Void, error_message: @escaping (FbError)->Void) -> ListenerRegistration{
        
        
        let query = self.dbReference.collection(INCOMES)
            //.whereField("user_gid", isEqualTo: user_gid)
            .whereField("payer_gid", isEqualTo: payer_gid)
            
        return incomeListener(query: query, complete: complete, error_message: error_message)
    }
    
    private func incomeListener(query: Query,
                                complete: @escaping (Income)->Void,
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
        
    private func incomeReader(query: Query, complete: @escaping ([Income])->Void, error_message: @escaping (FbError)->Void) {
        query.getDocuments(completion: { (incomesDocs, error)  in
            
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
