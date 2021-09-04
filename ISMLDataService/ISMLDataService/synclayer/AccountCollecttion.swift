//
//  AccountCollecttion.swift
//  ISMLDataService
//
//  Created by ARMEL KOUDOUM on 9/29/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseDatabase
import ISMLBase

public class AccountCollecttion {
    var pref: MyPreferences? = nil
    var firestoreRef:Firestore!
    
    var mAccount: Account!
    var expensesDict: [String: Expense]
    var incomesDict: [String: Income]
    var transferInDict: [String: Transfer]
    var transferOutDict: [String: Transfer]
    var expenses:Double = 0.0
    var incomes:Double = 0.0
    var transfers_in:Double = 0.0
    var transfers_out:Double = 0.0
    
    var incomeListernerReg: ListenerRegistration!
    var expemseListernerReg: ListenerRegistration!
    var transferInListernerReg: ListenerRegistration!
    var transferOutListernerReg: ListenerRegistration!
    
    var mRenderAccount: (([IsmTransaction], Account) -> Void)!
    
    public init (fireRef:Firestore) {
        
        expensesDict = [:]
        incomesDict = [:]
        transferInDict = [:]
        transferOutDict = [:]
        self.pref = MyPreferences()
        self.firestoreRef = fireRef
    }
    
    
    public func loadData(account_gid:String, dataSetChanged:@escaping ([IsmTransaction], Account) -> Void) {
        
        
        self.mRenderAccount = dataSetChanged
        let fbAccount = FbAccount(reference: self.firestoreRef)
        fbAccount.get(account_gid: account_gid, listener: {(account) in
            self.mAccount = account
            let transactions = self.getTransactions()
            self.mRenderAccount(transactions, account)
            
            self.syncIncome(accountGid: account.gid)
            self.syncExpense(accountGid: account.gid)
            self.syncTransferIn(accountGid: account.gid)
            self.syncTransferOut(accountGid: account.gid)
        }, error_message: {(error) in
            
            print(error)
        })
    }
    public func getTransactions() -> [IsmTransaction] {
        
        var mTransactions:[IsmTransaction] = []
        
        self.transfers_in = 0
        for (_, transfer) in transferInDict {
            
            let transaction = IsmTransaction()
            transaction.gid = transfer.gid
            transaction.name = "Transfer from \(transfer.from_str!)"
            transaction.date = transfer.transaction_date
            transaction.amount = transfer.amount
            transaction.type = .INCOMING
            transaction.typeEntry = .TRANSFER_IN
            transaction.checked = transfer.checked
            
            mTransactions.append(transaction)
            
            self.transfers_in = self.transfers_in + transfer.amount
            
        }
        
        self.transfers_out = 0
        for (_, transfer) in transferOutDict {
            
            let transaction = IsmTransaction()
            transaction.gid = transfer.gid
            transaction.name = "Transfer to \(transfer.to_str!)"
            transaction.date = transfer.transaction_date
            transaction.amount = transfer.amount
            transaction.type = .OUTGOING
            transaction.typeEntry = .TRANSFER_OUT
            transaction.checked = transfer.checked
            
            mTransactions.append(transaction)
            
            self.transfers_out = self.transfers_out + transfer.amount
        }
        
        
        self.expenses = 0
        for (_, expense) in expensesDict {
            
            let transaction = IsmTransaction()
            transaction.gid = expense.gid
            transaction.name = expense.title
            transaction.date = expense.transaction_date
            transaction.amount = expense.amount
            transaction.type = .OUTGOING
            transaction.typeEntry = .EXPENSE
            transaction.checked = expense.checked
            
            mTransactions.append(transaction)
            
            self.expenses = self.expenses + expense.amount
        }
        
        self.incomes = 0
        for (_, income) in incomesDict {
            
            let transaction = IsmTransaction()
            transaction.gid = income.gid
            transaction.name = income.title
            transaction.date = income.transaction_date
            transaction.amount = income.amount
            transaction.type = .INCOMING
            transaction.typeEntry = .INCOME
            transaction.checked = income.checked
            
            mTransactions.append(transaction)
            
            self.incomes = self.incomes + income.amount
        }
        self.mAccount.incomes = self.incomes
        self.mAccount.expenses = self.expenses
        self.mAccount.transfers_in = self.transfers_in
        self.mAccount.transfers_out = self.transfers_out
        //mTransactions.sort(by: { $0.date > $1.date })
        return mTransactions
    }
    
    public func syncExpense (accountGid: String) {
        
        let fbExpense = FbExpense(reference: self.firestoreRef)
        
        expemseListernerReg = fbExpense.listenByAccountGid(accountGid, complete: {(expense) in
            
            if expense.status == -1 {
                self.expensesDict[expense.gid] = nil
            } else{
                self.expensesDict[expense.gid] = expense
            }
            self.mRenderAccount(self.getTransactions(), self.mAccount)
            
        }, error_message: {(errorMessage) in
            
            print(errorMessage.errorMessage ?? "")
            self.mRenderAccount(self.getTransactions(), self.mAccount)
            
        })
        
        
        
    }
    
    
    public func syncIncome (accountGid: String) {
        
        let fbIncome = FbIncome(reference: self.firestoreRef)
        incomeListernerReg = fbIncome.listenByAccountGid(accountGid, complete: {(income) in
            
            if income.status == -1 {
                self.incomesDict[income.gid] = nil
            } else{
                self.incomesDict[income.gid] = income
            }
            
            self.mRenderAccount(self.getTransactions(), self.mAccount)
        }, error_message: {(error) in
            
            print(error.errorMessage)
            self.mRenderAccount(self.getTransactions(), self.mAccount)
        })
        
        
    }
    
    //
    public func syncTransferIn (accountGid: String) {
        
        let fbTransfer = FbTransfer(reference: self.firestoreRef)
        transferInListernerReg =  fbTransfer.listenAccountTransferTo(accountGid, complete: {(transfer) in
            
            if transfer.status == -1 {
                self.transferInDict[transfer.gid] = nil
            } else{
                self.transferInDict[transfer.gid] = transfer
            }
            
            self.mRenderAccount(self.getTransactions(), self.mAccount)
            
        }, error_message: {(error) in
            
            print(error.errorMessage)
            self.mRenderAccount(self.getTransactions(), self.mAccount)
        })
        
        
    }
    
    
    public func syncTransferOut (accountGid: String) {
        
        let fbTransfer = FbTransfer(reference: self.firestoreRef)
        transferOutListernerReg = fbTransfer.listenAccountTransferFrom(accountGid, complete: {(transfer) in
            
            if transfer.status == -1 {
                self.transferOutDict[transfer.gid] = nil
            } else{
                self.transferOutDict[transfer.gid] = transfer
            }
            
            self.mRenderAccount(self.getTransactions(), self.mAccount)
            
        }, error_message: {(error) in
            
            print(error.errorMessage)
            self.mRenderAccount(self.getTransactions(), self.mAccount)
        })
        
        
    }
    
    
    public func stopListner(){
        if incomeListernerReg != nil {
            incomeListernerReg.remove()
        }
        if expemseListernerReg != nil {
            expemseListernerReg.remove()
        }
        if transferInListernerReg != nil {
            transferInListernerReg.remove()
        }
        if transferOutListernerReg != nil {
            transferOutListernerReg.remove()
        }
    }
}
