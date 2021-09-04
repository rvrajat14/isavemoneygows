//
// FbUser.swift
// iSaveMoney
//
// Created by Armel Koudoum on 1/15/17.
// Copyright © 2017 UlmatCorpit. All rights reserved.
//


///-------------createExpense----------------------

import Firebase
import FirebaseFirestore
import ISMLBase

public class  FbExpense {
    let dbReference: Firestore
    let EXPENSES = Const.ENVIRONEMENT + "expenses"
    
    
    
    /** public init(reference: DatabaseReference) **/
    
    public init(reference: Firestore) {
        self.dbReference = reference
    }
    
    
    /** public func write() **/
    public func write(_ expense: Expense, completion: @escaping (Expense)->Void, error_message: @escaping (String)->Void) {
        
        let expenseRef = self.dbReference.collection(EXPENSES).document()
        expense.setGid(expenseRef.documentID)
        self.dbReference.collection(EXPENSES)
            .document(expense.gid)
            .setData(expense.toAnyObject() as! [String : Any], completion: {(error) in
                if let error = error {
                    error_message("Unable to add the expense. \(error)")
                } else {
                    completion(expense)
                }
            })
    }
    
    
    
    /** public func update(:Expense) **/
    public func update(_ expense: Expense, completion: @escaping (Expense)->Void, error_message: @escaping (String)->Void) {
        
        self.dbReference.collection(EXPENSES)
            .document(expense.gid)
            .setData(expense.toAnyObject() as! [String : Any], completion: {(error) in
                if let error = error {
                    error_message("Unable to add the expense. \(error)")
                }else{
                    completion(expense)
                }
            })
    }
    public func update(_ expense: Expense) {
        
        self.dbReference.collection(EXPENSES)
            .document(expense.gid)
            .setData(expense.toAnyObject() as! [String : Any])
    }
    
    public func ticker(gid: String, state: Int){
        self.dbReference.collection(EXPENSES).document(gid).updateData(["checked": state])
    }
    
    
    public func get(_ expense_gid: String, listener: @escaping (Expense) -> Void, error_message: @escaping (String)->Void) {
        
        self.dbReference.collection(EXPENSES).document(expense_gid).getDocument(completion: { (userDoc, error) in
            
            
            if let expense = userDoc.flatMap({
                $0.data().flatMap({ (data) in
                    return Expense(dataMap: data)
                })
            }) {
                print("Expense: \(expense)")
                listener(expense)
            } else {
                print("Unable to load the income")
                error_message("Unable to load the income. \(expense_gid)")
            }
            
        })
    }
    
    
    /** public func delete(:expense_gid: String) **/
    public func delete(_ expense: Expense) {
        
    
        self.dbReference.collection(EXPENSES).document(expense.gid).delete()
    }
    
    public func deleteWithGid(_ expenseId: String) {
        
    
        self.dbReference.collection(EXPENSES).document(expenseId).delete()
    }
    
    public func getExpensesForDates(userGid: String, startDate sdate: Int, endDate edate: Int, complete: @escaping ([Expense])->Void, error_message: @escaping (FbError)->Void) {
        
        let query = self.dbReference.collection(EXPENSES)
            .whereField("user_gid", isEqualTo: userGid)
            .whereField("transaction_date", isGreaterThanOrEqualTo: sdate)
            .whereField("transaction_date", isLessThanOrEqualTo: edate)
            
        expenseReader(query: query, complete: complete, error_message: error_message)
        
    }
    
    public func getExpensesForBudget(budgetGids: [String], startDate sdate: Int, endDate edate: Int, complete: @escaping ([Expense])->Void, error_message: @escaping (FbError)->Void) {
        
        let query = self.dbReference.collection(EXPENSES)
            .whereField("budget_gid", in: budgetGids)
            .whereField("transaction_date", isGreaterThanOrEqualTo: sdate)
            .whereField("transaction_date", isLessThanOrEqualTo: edate)
            
        expenseReader(query: query, complete: complete, error_message: error_message)
        
    }
    
    public func getByCategoryGid(_ category_gid: String, complete: @escaping ([Expense])->Void, error_message: @escaping (FbError)->Void) {
        
        let query = self.dbReference.collection(EXPENSES)
            .whereField("category_gid", isEqualTo: category_gid)
            .order(by: "insert_date", descending: true)
            
        expenseReader(query: query, complete: complete, error_message: error_message)
    }
    
    public func getByCategoryGidSync(_ category_gid: String,
                              complete: @escaping (Expense)->Void,
                              error_message: @escaping (FbError)->Void) -> ListenerRegistration {
        
        let query = self.dbReference.collection(EXPENSES)
            .whereField("category_gid", isEqualTo: category_gid)
            .order(by: "insert_date", descending: true)
        return expenseListener(query: query, complete:complete, error_message: error_message)
        
        
    }
    
    public func getByBudgetGid(_ budget_gid: String, complete: @escaping ([Expense])->Void, error_message: @escaping (FbError)->Void) {
        
        let query = self.dbReference.collection(EXPENSES)
            .whereField("budget_gid", isEqualTo: budget_gid)
            .order(by: "insert_date", descending: true)
            
        expenseReader(query: query, complete: complete, error_message: error_message)
        
    }
    
    
    public func getByAccountGid(_ account_gid: String, complete: @escaping ([Expense])->Void, error_message: @escaping (FbError)->Void) {
        
        let query = self.dbReference.collection(EXPENSES)
            .whereField("account_gid", isEqualTo: account_gid)
            //.order(by: "insert_date", descending: true)
        expenseReader(query: query, complete: complete, error_message: error_message)
    }
    
    public func listenByAccountGid(_ account_gid: String, complete: @escaping (Expense)->Void, error_message: @escaping (FbError)->Void) -> ListenerRegistration{
        
        let query = self.dbReference.collection(EXPENSES)
            .whereField("account_gid", isEqualTo: account_gid)
            //.order(by: "insert_date", descending: true)
        return expenseListener(query: query, complete:complete, error_message: error_message)
    }
    
    public func getByPayeeGid(_ payee_gid: String, complete: @escaping ([Expense])->Void, error_message: @escaping (FbError)->Void){
        
        let query = self.dbReference.collection(EXPENSES)
            .whereField("payee_gid", isEqualTo: payee_gid)
            .order(by: "insert_date", descending: true)
        expenseReader(query: query, complete: complete, error_message: error_message)
    }
    
    public func listenByPayeeGid(_ payee_gid: String, complete: @escaping (Expense)->Void, error_message: @escaping (FbError)->Void)  -> ListenerRegistration{
        let query = self.dbReference.collection(EXPENSES)
            .whereField("payee_gid", isEqualTo: payee_gid)
            
            //.order(by: "insert_date", descending: true)
        return expenseListener(query: query, complete:complete, error_message: error_message)
    }
    
    private func expenseListener(query: Query,
                                 complete: @escaping (Expense)->Void,
                                 error_message: @escaping (FbError)->Void) -> ListenerRegistration {
        return query.addSnapshotListener({querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
            
                let errorM:FbError = FbError()
                errorM.errorCode = 101
                errorM.errorMessage = "Error fetching snapshots: \(error!)"
                error_message(errorM)
                return
            }
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    print("New expense: \(diff.document.data())")
                    let expense = Expense(dataMap: diff.document.data())
                    expense.status = 1
                    complete(expense)
                    
                }
                if (diff.type == .modified) {
                    print("Modified expense: \(diff.document.data())")
                    let expense = Expense(dataMap: diff.document.data())
                    expense.status = 2
                    complete(expense)
                }
                if (diff.type == .removed) {
                    print("Removed expense: \(diff.document.data())")
                    let expense = Expense(dataMap: diff.document.data())
                    expense.status = -1
                    complete(expense)
                }
            }
            
        })
    }
    
    private func expenseReader (query: Query, complete: @escaping ([Expense])->Void, error_message: @escaping (FbError)->Void) {
        query.getDocuments(completion: { (categoriesDocs, error)  in
            
            var expensesList = [Expense]()
            
            if let error = error {
                
                let errorM:FbError = FbError()
                errorM.errorCode = 101
                errorM.errorMessage = "Error getting incomes: \(error)"
                error_message(errorM)
            } else {
                
                for document in categoriesDocs!.documents {
                    
                    expensesList.append(Expense(dataMap: document.data()))
                    
                }
                expensesList.sort(by: {$0.transaction_date > $1.transaction_date})
                complete(expensesList)
            }
            
        })
    }
}
