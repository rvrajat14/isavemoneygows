//
// FbUser.swift
// iSaveMoney
//
// Created by Armel Koudoum on 1/15/17.
// Copyright © 2017 UlmatCorpit. All rights reserved.
//


///-------------createCategory----------------------

import Firebase
import FirebaseFirestore

public class FbCategory{
    let dbReference: Firestore
    let CATEGORIES = Const.ENVIRONEMENT + "categories"
    

    
    /** public init(reference: DatabaseReference) **/
    
    public init(reference: Firestore) {
        self.dbReference = reference
    }
    
    /** public func write() **/
    public func write(_ category: BudgetCategory, completion: @escaping (BudgetCategory)->Void, error_message: @escaping (String)->Void){
        
        
        let categoryRef = self.dbReference.collection(CATEGORIES).document()
        category.gid = categoryRef.documentID
        self.dbReference
            .collection(CATEGORIES)
            .document(category.gid)
            .setData(category.toAnyObject() as! [String : Any], completion: {(error) in
                if let error = error {
                    error_message("Unable category. \(error)")
                }else{
                    completion(category)
                }
                
            })
    }
    

    
    /** public func update(:BudgetCategory) **/
    public func update(_ category: BudgetCategory, completion: @escaping (BudgetCategory)->Void, error_message: @escaping (String)->Void) {
        
        
        self.dbReference
            .collection(CATEGORIES)
            .document(category.gid)
            .setData(category.toAnyObject() as! [String : Any], completion: {(error) in
                if let error = error {
                    error_message("Unable category. \(error)")
                }else{
                    completion(category)
                }
                
            })
    }
    
    
    
    /** public func get(:category_gid: String) **/
    public func get(_ category_gid: String, listener: @escaping (BudgetCategory) -> Void, error_message: @escaping (String)->Void) {
        
        self.dbReference.collection(CATEGORIES).document(category_gid).getDocument( completion: { (categoryDoc, error) in
            
            
            if let category = categoryDoc.flatMap({
                $0.data().flatMap({ (data) in
                    return BudgetCategory(dataMap: data)
                })
            }) {
              
                listener(category)
            } else {
                print("Unable to load the category")
                error_message("Unable to load the category. \(category_gid)")
            }
            
        })
    }
    
    
    public func getSync(_ category_gid: String,
             listener: @escaping (BudgetCategory) -> Void,
             error_message: @escaping (String)->Void) -> ListenerRegistration {
        
        return self.dbReference
            .collection(CATEGORIES)
            .whereField("gid", isEqualTo: category_gid)
            .addSnapshotListener({querySnapshot, error in
                
                guard let snapshot = querySnapshot else {
                
                    error_message("Error fetching snapshots: \(error!)")
                    return
                }
                
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                     
                        let category = BudgetCategory(dataMap: diff.document.data())
                        category.status = 1
                        listener(category)
                        
                    }
                    if (diff.type == .modified) {
                    
                        let category = BudgetCategory(dataMap: diff.document.data())
                        category.status = 2
                        listener(category)
                    }
                    if (diff.type == .removed) {
                      
                        let category = BudgetCategory(dataMap: diff.document.data())
                        category.status = -1
                        listener(category)
                    }
                }
                
            })
            
            /*.getDocument( completion: { (categoryDoc, error) in
            
            
            if let category = categoryDoc.flatMap({
                $0.data().flatMap({ (data) in
                    return Category(dataMap: data)
                })
            }) {
                print("Category: \(BudgetCategory)")
                listener(category)
            } else {
                print("Unable to load the category")
                error_message("Unable to load the category. \(category_gid)")
            }
            
        })*/
    }
    
    
    
    /** public func delete(:category_gid: String) **/
    public func delete(_ category: BudgetCategory) {
        
        self.dbReference.collection(CATEGORIES).document(category.gid).delete()
    }
    
    
    public func getByBudgetGid(_ budget_gid: String, complete: @escaping ([BudgetCategory])->Void, error_message: @escaping (FbError)->Void) {
        
        self.dbReference.collection(CATEGORIES)
            .whereField("budget_gid", isEqualTo: budget_gid)
            .order(by: "title")
            .getDocuments(completion: { (categoriesDocs, error)  in
                
                var categoriesList = [BudgetCategory]()
                
                if let error = error {
                    
                    let errorM:FbError = FbError()
                    errorM.errorCode = 101
                    errorM.errorMessage = "Error getting categories: \(error)"
                    error_message(errorM)
                } else {
                    
                    for document in categoriesDocs!.documents {
                        
                        categoriesList.append(BudgetCategory(dataMap: document.data()))
                        
                    }
                    
                    complete(categoriesList)
                }
                
            })
        
    }
    
    public func getByBudgetGidSync(_ budget_gid: String,
                            complete: @escaping (BudgetCategory)->Void,
                            error_message: @escaping (FbError)->Void) -> ListenerRegistration {
        
        return self.dbReference.collection(CATEGORIES)
            .whereField("budget_gid", isEqualTo: budget_gid)
            .order(by: "title")
            .addSnapshotListener({querySnapshot, error in
                
                guard let snapshot = querySnapshot else {
                    
                    let errorM:FbError = FbError()
                    errorM.errorCode = 101
                    errorM.errorMessage = "Error fetching snapshots: \(error!)"
                    error_message(errorM)
                    return
                }
                
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        
                        let category = BudgetCategory(dataMap: diff.document.data())
                        category.status = 1
                        complete(category)
                        
                    }
                    if (diff.type == .modified) {
             
                        let category = BudgetCategory(dataMap: diff.document.data())
                        category.status = 2
                        complete(category)
                    }
                    if (diff.type == .removed) {
    
                        let category = BudgetCategory(dataMap: diff.document.data())
                        category.status = -1
                        complete(category)
                    }
                }
                
                
                
            })
            
        
    }
    
}
