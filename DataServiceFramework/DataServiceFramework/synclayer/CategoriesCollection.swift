//
//  CategoriesCollection.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 4/10/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseDatabase

public class CategoriesCollection {
    
    let firestoreRef: Firestore
    var pref: MyPreferences!
    var mCategoryRef:DatabaseQuery!
    public var categoriesDict: [String: BudgetCategory]
    
    public init(reference: Firestore) {
        
        self.firestoreRef = reference
        self.pref = MyPreferences()
        categoriesDict = [:]
    }
    
    
    public func startSync()  {
        
        
        categoriesDict = [:]
        
        if self.pref.getSelectedMonthlyBudget()=="" {
            return
        }
        
        let fbCategory:FbCategory = FbCategory(reference: self.firestoreRef)
        
        fbCategory.getByBudgetGid(self.pref.getSelectedMonthlyBudget(), complete: {(categories) in
            
            for category in categories {
                self.categoriesDict[category.gid] = category
            }
            
        }, error_message: {(error) in
            print(error.errorMessage)
        })
        
        
        
    }
    
    
    
    
    public func getCategory() -> [BudgetCategory] {
        
        var mCategory:[BudgetCategory] = []
        
        for (_, category) in categoriesDict {
            
            mCategory.append(category)
        }
        
        
        return mCategory
    }
    
}
