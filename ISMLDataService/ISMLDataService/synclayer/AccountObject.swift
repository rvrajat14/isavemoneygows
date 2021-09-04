//
//  AccountObject.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 4/12/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseDatabase
import ISMLBase

public class AccountObject {
    var gid:String!
    var name:String!
    var user_gid:String!
    var type:Int!
    var balance:Double!
    var deposit:Double!
    var withdraw:Double!
    var active:Int!
    var expenses:Double = 0.0
    var incomes:Double = 0.0
    var transfers_in:Double = 0.0
    var transfers_out:Double = 0.0
    var invalid:Int!
    var insert_date:Int!
    var last_update:Int!
    public var telephone:String!
    public var address:String!
    public var other_notes:String!
    
    public var expensesDict: [String: Expense]
    var incomesDict: [String: Income]
    var transferInDict: [String: Transfer]
    var transferOutDict: [String: Transfer]
    
    //FIR ref
    
    var pref: MyPreferences? = nil
   
    
    var mRenderAccount: (([IsmTransaction], Account) -> Void)!

    var firestoreRef:Firestore!
    
    public init (fireRef:Firestore) {
        
        expensesDict = [:]
        incomesDict = [:]
        transferInDict = [:]
        transferOutDict = [:]
        self.pref = MyPreferences()
        self.firestoreRef = fireRef
    }
    
    
    
    public init(snapshot: DataSnapshot!,fireRef:Firestore) {
        
        expensesDict = [:]
        incomesDict = [:]
        transferInDict = [:]
        transferOutDict = [:]
        self.pref = MyPreferences()
        self.firestoreRef = fireRef
        
        let value = snapshot.value as? NSDictionary
        
        self.gid = snapshot.key
        self.gid = value?["gid"] as? String ?? ""
        self.name = value?["name"] as? String ?? ""
        self.user_gid = value?["user_gid"] as? String ?? ""
        self.type = value?["type"] as? Int ?? 0
        self.balance = value?["balance"] as? Double ?? 0.0
        self.deposit = 0.0
        self.withdraw = 0.0
        self.active = value?["active"] as? Int ?? 0
        
        self.expenses =  0.0
        self.incomes = 0.0
        self.transfers_in = 0.0
        self.transfers_out = 0.0
        self.invalid = value?["invalid"] as? Int ?? 0
        self.insert_date = value?["insert_date"] as? Int ?? 0
        self.last_update = value?["last_update"] as? Int ?? 0
        
        self.other_notes = value?["other_notes"] as? String ?? ""
        self.telephone = value?["telephone"] as? String ?? ""
        self.address = value?["address"] as? String ?? ""
    }
    
    
    
    public func updateAccount(snapshot: DataSnapshot!, fireRef:Firestore) {
        
        expensesDict = [:]
        incomesDict = [:]
        transferInDict = [:]
        transferOutDict = [:]
        self.pref = MyPreferences()
        self.firestoreRef = fireRef
        
        let value = snapshot.value as? NSDictionary
        
        self.gid = snapshot.key
        self.gid = value?["gid"] as? String ?? ""
        self.name = value?["name"] as? String ?? ""
        self.user_gid = value?["user_gid"] as? String ?? ""
        self.type = value?["type"] as? Int ?? 0
        self.balance = value?["balance"] as? Double ?? 0.0
        self.deposit = 0.0
        self.withdraw = 0.0
        self.active = value?["active"] as? Int ?? 0

        self.invalid = value?["invalid"] as? Int ?? 0
        self.insert_date = value?["insert_date"] as? Int ?? 0
        self.last_update = value?["last_update"] as? Int ?? 0
        
        self.other_notes = value?["other_notes"] as? String ?? ""
        self.telephone = value?["telephone"] as? String ?? ""
        self.address = value?["address"] as? String ?? ""
    }
    
    public init(dataMap: [String:Any], fireRef:Firestore) {
        
        expensesDict = [:]
        incomesDict = [:]
        transferInDict = [:]
        transferOutDict = [:]
        self.pref = MyPreferences()
        self.firestoreRef = fireRef
        
        self.gid = dataMap["gid"] as? String ?? ""
        self.name = dataMap["name"] as? String ?? ""
        self.user_gid = dataMap["user_gid"] as? String ?? ""
        self.type = dataMap["type"] as? Int ?? 0
        self.balance = dataMap["balance"] as? Double ?? 0.0
        self.deposit = 0.0
        self.withdraw = 0.0
        self.active = dataMap["active"] as? Int ?? 0
        
        self.invalid = dataMap["invalid"] as? Int ?? 0
        self.insert_date = dataMap["insert_date"] as? Int ?? 0
        self.last_update = dataMap["last_update"] as? Int ?? 0
        
        self.telephone = dataMap["telephone"] as? String ?? ""
        self.address = dataMap["address"] as? String ?? ""
        self.other_notes = dataMap["other_notes"] as? String ?? ""
    }
    
    
    
    public func getAccount() -> Account {
        
        let account:Account = Account()
        
        account.gid = self.gid
        account.name = self.name
        account.user_gid = self.user_gid
        account.type = self.type
        account.balance = self.balance
        account.deposit = self.deposit
        account.withdraw = self.withdraw
        account.active = self.active
        account.telephone = self.telephone
        account.address = self.address
        account.other_notes = self.other_notes
        
        //recompute transactions
        _ = getTransactions()
        account.expenses =  self.expenses
        account.incomes = self.incomes
        account.transfers_in = self.transfers_in
        account.transfers_out = self.transfers_out
        account.invalid = self.invalid
        account.insert_date = self.insert_date
        account.last_update = self.last_update
        
        return account
        
    }
    public func loadData(account_gid:String, dataSetChanged:@escaping ([IsmTransaction], Account) -> Void) {
        
        self.mRenderAccount = dataSetChanged
        let fbAccount = FbAccount(reference: self.firestoreRef)
        fbAccount.get(account_gid: account_gid, listener: {(account) in
            
            self.gid = account.gid
            self.name = account.name
            self.user_gid = account.user_gid
            self.type = account.type
            self.balance = account.balance
            self.deposit = 0.0
            self.withdraw = 0.0
            self.active = account.active
            
            self.telephone = account.telephone
            self.address = account.address
            self.other_notes = account.other_notes
            
            self.invalid = account.invalid
            self.insert_date = account.insert_date
            self.last_update = account.last_update
            
            self.syncIncome(accountGid: account.gid)
            self.syncExpense(accountGid: account.gid)
            self.syncTransferIn(accountGid: account.gid)
            self.syncTransferOut(accountGid: account.gid)
            
            self.mRenderAccount(self.getTransactions(), self.getAccount())
        }, error_message: {(error) in
            
            print(error)
        })
    }
    
    public func listenOnChanges(account_gid:String, dataSetChanged:@escaping ([IsmTransaction], Account) -> Void) {
        
        self.mRenderAccount = dataSetChanged
        let fbAccount = FbAccount(reference: self.firestoreRef)
        fbAccount.get(account_gid: account_gid, listener: {(account) in
            
            self.gid = account.gid
            self.name = account.name
            self.user_gid = account.user_gid
            self.type = account.type
            self.balance = account.balance
            self.deposit = 0.0
            self.withdraw = 0.0
            self.active = account.active
            
            self.telephone = account.telephone
            self.address = account.address
            self.other_notes = account.other_notes
            
            self.invalid = account.invalid
            self.insert_date = account.insert_date
            self.last_update = account.last_update
            
            self.syncIncome(accountGid: account.gid)
            self.syncExpense(accountGid: account.gid)
            self.syncTransferIn(accountGid: account.gid)
            self.syncTransferOut(accountGid: account.gid)
            
            self.mRenderAccount(self.getTransactions(), self.getAccount())
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
        
        return mTransactions;
    }
    
    
    //Expenses traiement
    
    public func addExpense(expense:Expense) {
        
        if expense.gid! != "" {
            self.expensesDict[expense.gid] = expense
            self.expenses = 0.0
            for (_, expense) in self.expensesDict {
                
                self.expenses = self.incomes + expense.amount
            }
        }

    }
    
    public func removeExpense(expense:Expense) {
        
        if expense.gid! != "" {
            self.expensesDict[expense.gid] = nil
            
            self.expenses = 0.0
            for (_, expense) in self.expensesDict {
                
                self.expenses = self.incomes + expense.amount
            }
        }
    }
    
    
    
    
    /******************/
    //income traiement
    
    public func addIncome(income:Income) {
    
        if income.gid! != "" {
            self.incomesDict[income.gid] = income
            self.incomes = 0.0
            for (_, income) in self.incomesDict {
                
                self.incomes = self.incomes + income.amount
            }
            
        }
    }
    
    public func removeIncome(income:Income) {
    
        if income.gid! != "" {
            self.incomesDict[income.gid] = nil
            
            self.incomes = 0.0
            for (_, income) in self.incomesDict {
                
                self.incomes = self.incomes + income.amount
            }
            
        }

    }
    
   
    
    //transfer in traitement
    
    public func addTransferIn(transfer: Transfer) {
    
        if transfer.gid! != "" {
            self.transferInDict[transfer.gid] = transfer
            
            self.transfers_in = 0.0
            for (_, transfer) in self.transferInDict {
                
                self.transfers_in = self.transfers_in + transfer.amount
            }
            
        }
    }
    
    public func removeTransferIn(transfer:Transfer) {
        
        if transfer.gid! != "" {
            self.transferInDict[transfer.gid] = nil
            
            self.transfers_in = 0.0
            for (_, transfer) in self.transferInDict {
                
                self.transfers_in = self.transfers_in + transfer.amount
            }
            
        }
    }
    //
   
    /****************************/
    //transfer out traitement
    
    public func addTransferOut(transfer: Transfer) {
        
        if transfer.gid! != "" {
            self.transferOutDict[transfer.gid] = transfer
            
            self.transfers_out = 0.0
            for (_, transfer) in self.transferOutDict {
                
                self.transfers_out = self.transfers_out + transfer.amount
            }
            
        }
    }
    
    public func removeTransferOut(transfer:Transfer) {
        
        if transfer.gid! != "" {
            self.transferOutDict[transfer.gid] = nil
            
            self.transfers_out = 0.0
            for (_, transfer) in self.transferOutDict {
                
                self.transfers_out = self.transfers_out + transfer.amount
            }
            
        }
    }
    
    
    
    public func syncExpense (accountGid: String) {
        
        let fbExpense = FbExpense(reference: self.firestoreRef)
        
        fbExpense.getByAccountGid(accountGid, complete: {(expenses) in
            
            self.expensesDict = [:]
            for expense in expenses {
                
                
                self.expensesDict[expense.gid] = expense
                
            }
            self.mRenderAccount(self.getTransactions(), self.getAccount())
            
        }, error_message: {(errorMessage) in
            
            print(errorMessage.errorMessage)
            self.mRenderAccount(self.getTransactions(), self.getAccount())
            
        })
        
        
        
    }
    
    
    public func syncIncome (accountGid: String) {
        
        let fbIncome = FbIncome(reference: self.firestoreRef)
        
        fbIncome.getByAccountGid(accountGid, complete: {(incomes) in
            
            self.incomesDict = [:]
            for income in incomes {
                
            
                self.incomesDict[income.gid] = income
            }
            
            
            self.mRenderAccount(self.getTransactions(), self.getAccount())
        }, error_message: {(error) in
            
            print(error.errorMessage)
            self.mRenderAccount(self.getTransactions(), self.getAccount())
        })
        
        
    }
    
    //
    public func syncTransferIn (accountGid: String) {
        
        let fbTransfer = FbTransfer(reference: self.firestoreRef)
        fbTransfer.getAccountTransferTo(accountGid, complete: {(transfers) in
            
            self.transferInDict = [:]
            for transfer in transfers {
                
                self.transferInDict[transfer.gid] = transfer
            }
            
            self.mRenderAccount(self.getTransactions(), self.getAccount())
            
        }, error_message: {(error) in
            
            print(error.errorMessage)
            self.mRenderAccount(self.getTransactions(), self.getAccount())
        })
        
        
    }
    
    
    public func syncTransferOut (accountGid: String) {
        
        let fbTransfer = FbTransfer(reference: self.firestoreRef)
        fbTransfer.getAccountTransferFrom(accountGid, complete: {(transfers) in
            
            self.transferOutDict = [:]
            for transfer in transfers {
                
                self.transferOutDict[transfer.gid] = transfer
            }
            
            self.mRenderAccount(self.getTransactions(), self.getAccount())
            
        }, error_message: {(error) in
            
            print(error.errorMessage)
            self.mRenderAccount(self.getTransactions(), self.getAccount())
        })
        
        
    }
}
