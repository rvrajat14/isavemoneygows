
/**
 public func addBudget(budget_gid:String,  user_gid:String){
 
 self.dbReference.child("\(USERS_BUDGETS)/\(user_gid)/\(budget_gid)").setValue(true);
 
 
 }
 */
//
// FbUser.swift
// iSaveMoney
//
// Created by Armel Koudoum on 1/15/17.
// Copyright © 2017 UlmatCorpit. All rights reserved.
//


///-------------createUser----------------------

import Firebase
import FirebaseFirestore
import ISMLBase

public class FbUser{
    let dbReference: Firestore
    let USERS = Const.ENVIRONEMENT+"users"
    let USERS_BUDGETS = Const.ENVIRONEMENT+"users_budgets"
    
    public init(reference: Firestore) {
        self.dbReference = reference
    }
    
    
    public func write(_ user: PUser, completion: @escaping (PUser)->Void, error_message: @escaping (String)->Void) {
        
        //let newUserRef = self.dbReference.collection(USERS).document()
       print("saving income now")
        let userDitionary = user.toAnyObject()
        self.dbReference.collection(USERS).document(user.gid).setData(userDitionary as! [String : Any], completion: {(error) in
            
            if let error = error {
                print("error saving income now")
                error_message("Unable to create the user profile. \(error)")
            }else{
                print("saving income now completed")
                completion(user)
            }
            
        })
        
    
    }
    
    
    public func update(_ user: PUser!, completion: @escaping (PUser)->Void, error_message: @escaping (String)->Void) {
        
        if user.gid! != "" {
            user.setLastUpdate(user.last_update)
            let userDitionary = user.toAnyObject()
            self.dbReference.collection(USERS).document(user.gid).updateData(userDitionary as! [AnyHashable : Any], completion: {(error) in
                
                if let error = error {
                    error_message("Unable to create the user profile. \(error)")
                }else{
                    completion(user)
                }
                
            })
        }else{
            
            error_message("Can't update the user profile. please try again later.")
        }
       
       
    }
    
    public func get(userGid:String, listner: @escaping (PUser)->Void, error_message: @escaping (String)->Void) {
        
        self.dbReference.collection(USERS).document(userGid).getDocument(completion: { (userDoc, error) in
            
            
            if let user = userDoc.flatMap({
                $0.data().flatMap({ (data) in
                    return PUser(dataMap: data)
                })
            }) {
                print("User: \(user)")
                listner(user)
            } else {
                print("Unable to load the user account")
                error_message("Unable to load the user account associated with the email.")
            }
  
        })
            
        
            //listner(oUser)
        
    }
    
    public func budgetGidAndTimestamp(userGid: String, listner: @escaping ([BudgetEntry])->Void, errorReturn: @escaping (FbError)->Void) {
    
        
        self.dbReference.collection(USERS_BUDGETS).whereField("user_gid", isEqualTo: userGid).getDocuments(completion: { (querySnapshot, err) in
            var listEntries = [BudgetEntry]()
            
            if let err = err {
                
                let error:FbError = FbError()
                error.errorCode = 101
                error.errorMessage = "Error getting documents: \(err)"
            } else {
                
                for document in querySnapshot!.documents {
                    
                    print("\(document.documentID) => \(document.data())")
                    let data = document.data()
                    let budgetEntry = BudgetEntry()
                    budgetEntry.gid = document.documentID
                    budgetEntry.lastRead = data["timestamp"] as! Int
                    listEntries.append(budgetEntry)
                    
                    
                }
                
                listner(listEntries)
            }
            
            
            
        })
      
    }
    
    public func getByEmail(_ email: String, listner: @escaping (PUser, Bool)->Void, errorReturn: @escaping (FbError)->Void) {
        
        self.dbReference.collection(USERS)
            .whereField("email",isEqualTo: email)
            .getDocuments(completion: { (querySnapshot, error) in
                
                if let err = error {
                    
                    let error:FbError = FbError()
                    error.errorCode = 101
                    error.errorMessage = "Error getting documents: \(err)"
                } else {
                    
                    var found  = false
                    print("Find with email \(querySnapshot)")
                    for document in querySnapshot!.documents {
                        
                        
                        print("Find with email  \(document.documentID) => \(document.data())")
                        
                        let data = document.data()
                        let user = PUser(dataMap: data)
                        found = true
                        listner(user, found)
                        
                        break
                        
                    }
                    
                    if !found {
                        
                        listner(PUser(), found)
                        
                    }
                    
                    
                }
            })
            
        
    }
    
    public func removeUser(_ user_gid: String) {
        
        self.dbReference.collection(USERS).document(user_gid).delete()
        
    }
    
    
    public func removeUser(_ user_gid: String, budget_gid: String) {
        
        self.dbReference.collection(USERS_BUDGETS).document(user_gid).delete()
        
    }
}
