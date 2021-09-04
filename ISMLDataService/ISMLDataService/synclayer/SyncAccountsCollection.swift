//
//  SyncAccountsCollection.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 4/15/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import Foundation
import FirebaseFirestore
import ISMLBase

public class SyncAccountsCollection {
    
   
    let firestoreRef:Firestore
    var pref: MyPreferences!
   
    var accountsDict: [String: AccountObject]
    
    
    
    var accountsListner: (([Account]) -> Void)!
    
    public init(reference: Firestore) {
        
        self.firestoreRef = reference
        self.pref = MyPreferences()
        accountsDict = [:]
        
    }
    
    
    public func startSync(accountsListner: @escaping (([Account]) -> Void), error:@escaping (FbError)->Void)  {
        
        self.accountsListner = accountsListner
      
        let fbAccount = FbAccount(reference: self.firestoreRef)
        
        fbAccount.getUserAccounts(self.pref.getUserIdentifier(), complete: {(accounts) in
            
            for account in accounts {
                
                self.accountsDict[account.gid] = AccountObject(dataMap: account.toAnyObject() as! [String : Any], fireRef: self.firestoreRef)
                self.syncIncome(accountGid: account.gid)
                self.syncExpense(accountGid: account.gid)
                self.syncTransferIn(accountGid: account.gid)
                self.syncTransferOut(accountGid: account.gid)
            }
            
            
        }, error_message: {(error_message) in
            
            error(error_message)
        })
        
        
    }
    
    public func stopSync() {
        
        
    }
    
    public func getAccounts() -> [Account] {
        
        var mAccount:[Account] = []
        
        for (_, accountObject) in accountsDict {
            
            mAccount.append(accountObject.getAccount())
        }
        
        
        return mAccount
    }
    
    
    
    //Sync entities
    
    public func syncExpense (accountGid: String) {
        
        let fbExpense = FbExpense(reference: self.firestoreRef)
        
        fbExpense.getByAccountGid(accountGid, complete: {(expenses) in
            
            for expense in expenses {
                
                let accountObject = self.accountsDict[accountGid]
                accountObject?.addExpense(expense: expense)
                
            }
            self.accountsListner(self.getAccounts())
            
        }, error_message: {(errorMessage) in
            
            print(errorMessage.errorMessage)
            self.accountsListner(self.getAccounts())
            
        })
        
        
        
    }
    
    
    public func syncIncome (accountGid: String) {
        
        let fbIncome = FbIncome(reference: self.firestoreRef)
        
        fbIncome.getByAccountGid(accountGid, complete: {(incomes) in
            
            for income in incomes {
                
                let accountObject = self.accountsDict[accountGid]
                accountObject?.addIncome(income: income)
            }
           
            
            self.accountsListner(self.getAccounts())
        }, error_message: {(error) in
            
            print(error.errorMessage)
            self.accountsListner(self.getAccounts())
        })
        
        
    }
    
    //
    public func syncTransferIn (accountGid: String) {
        
        let fbTransfer = FbTransfer(reference: self.firestoreRef)
        fbTransfer.getAccountTransferTo(accountGid, complete: {(transfers) in
            
            for transfer in transfers {
                let accountObject = self.accountsDict[accountGid]
                accountObject?.addTransferIn(transfer: transfer)
            }
            
            self.accountsListner(self.getAccounts())
            
        }, error_message: {(error) in
            
            print(error.errorMessage)
            self.accountsListner(self.getAccounts())
        })
        
        
    }
    
    
    public func syncTransferOut (accountGid: String) {
        
        let fbTransfer = FbTransfer(reference: self.firestoreRef)
        fbTransfer.getAccountTransferFrom(accountGid, complete: {(transfers) in
            
            for transfer in transfers {
                let accountObject = self.accountsDict[accountGid]
                accountObject?.addTransferOut(transfer: transfer)
            }
            
            self.accountsListner(self.getAccounts())
            
        }, error_message: {(error) in
            
            print(error.errorMessage)
            self.accountsListner(self.getAccounts())
        })
        
        
    }
    
}
