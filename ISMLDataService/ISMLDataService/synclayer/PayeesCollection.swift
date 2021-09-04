//
//  PayeesCollection.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 4/9/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseDatabase
import ISMLBase

public class PayeesCollection {
    
    let firestoreRef: Firestore
    var pref: MyPreferences!
    var mPayeeRef:DatabaseQuery!
    var payeeDict: [String: Payee]
    var expenseDict: [String: Expense]
    var mNotifier: (([Payee]) -> Void)!
    var regListner:ListenerRegistration!
    
    public init() {
        self.firestoreRef = Firestore.firestore()
        self.pref = MyPreferences()
        payeeDict = [:]
        expenseDict = [:]
    }
    public init(reference: Firestore) {
        
        self.firestoreRef = reference
        self.pref = MyPreferences()
        payeeDict = [:]
        expenseDict = [:]
    }

    public func startSync(notifier: @escaping ([Payee]) -> Void) {
    
        self.mNotifier = notifier
        self.startSync()
    }
    
    public func startSync()  {
        
        
        print("Payee startSync()")
        
        let fbPayee:FbPayee = FbPayee(reference: self.firestoreRef)
        
        fbPayee.getUserPayee(self.pref.getUserIdentifier(), complete: {(payees) in
            
            for payee in payees {
                self.payeeDict[payee.gid] = payee
                self.getExpenses(payeeGid: payee.gid)
            }
            
            if self.mNotifier != nil {
                self.mNotifier(self.getPayee())
            }
            
        }, error_message: {(error) in
            
            print(error.errorMessage)
        })
        
    
    }
    
    
    private func getExpenses(payeeGid: String) {
        let fbPayee:FbPayee = FbPayee(reference: self.firestoreRef)
        
        fbPayee.getPayeeExpenses(self.pref.getUserIdentifier(), payeeGid, complete: {(expenses) in
            let payeeObject = self.payeeDict[payeeGid]
            payeeObject?.total_expenses = self.totalExpense(expenses: expenses)
            self.payeeDict[payeeGid] = payeeObject
            if self.mNotifier != nil {
                self.mNotifier(self.getPayee())
            }
            
        }, error_message: {(error) in
            
            print(error)
        })
    }
    
    private func totalExpense(expenses: [Expense]) -> Double{
        var total = 0.0;
        for expense in expenses {
            total = total + expense.amount
        }
        
        return total
    }
    
    public func getPayeeExpenses(_ payee_gid:String,onComplete: @escaping ([Expense])->Void,onError: @escaping (FbError)->Void){
        //let fbPayee:FbPayee = FbPayee(reference: self.firestoreRef)
        let fbExpense:FbExpense = FbExpense(reference: self.firestoreRef)
        
        self.regListner = fbExpense.listenByPayeeGid(payee_gid, complete: {(expense) in
            //let payeeObj = self.payeeDict
            if expense.status == -1 {
                self.expenseDict[expense.gid] = nil
            } else{
                self.expenseDict[expense.gid] = expense
            }
            
            onComplete(self.getExpenses())
            
        }, error_message: {(error) in
            
            onError(error)
        })
    }
    
    private func getExpenses() -> [Expense] {
        var expenses:[Expense] = []
        for (key, expense) in self.expenseDict {
            expenses.append(expense)
        }
        expenses.sort(by: { $0.transaction_date > $1.transaction_date })
        return expenses
    }
    
    public func getPayee() -> [Payee] {
        
        var mPayee:[Payee] = []
        
        for (_, payee) in payeeDict {
        
            mPayee.append(payee)
        }
        
        mPayee = mPayee.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
        
        return mPayee
    }
    
    public func stopListner() {
        if self.regListner != nil {
            self.regListner.remove()
        }
    }
}
