//
//  IdeaExpensesHelper.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 12/12/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import Foundation
import CoreData

public class IdeaExpensesHelper{
    
    public static func insertExpense(viewContext: NSManagedObjectContext, forCategory: String, andName: String) {
        
        let expenseList:[CaheExpenses] = getExpense(viewContext: viewContext, forName: andName, andCategory: forCategory)
        
        if expenseList.count > 0 {
            for item in expenseList {
                print("Remove \(item.categoryName!)  \(item.expenseName!)")
                viewContext.delete(item)
            }
        }
        let recent = CaheExpenses(context: viewContext)
        recent.expenseName = andName
        recent.categoryName = forCategory
        recent.insertDate = Int64(Date().timeIntervalSince1970)
        print("Insert Expense Cache \(recent.categoryName!)  \(recent.expenseName!)")
        do{
            try viewContext.save()
        }catch{
            
        }
    }
    
    public static func getLastTen(viewContext: NSManagedObjectContext, forCategory: String) -> [CaheExpenses]{
        
        print("Get Last Ten \(forCategory)")
        var expenseList:[CaheExpenses] = [CaheExpenses]()
        do{
            let request = CaheExpenses.fetchRequest() as NSFetchRequest<CaheExpenses>
            request.predicate = NSPredicate(format: "categoryName = %@", forCategory)
            request.sortDescriptors = [NSSortDescriptor(keyPath: \CaheExpenses.insertDate, ascending: false)]
            request.fetchLimit = 10
            expenseList = try viewContext.fetch(request)
   

        }catch{
            
        }
        print("Get Last Ten \(expenseList.count)")
        return expenseList
    }
    
    public static func getExpense(viewContext: NSManagedObjectContext, forName: String, andCategory: String) -> [CaheExpenses] {
        var expenseList:[CaheExpenses] = [CaheExpenses]()
        do{
            let request = CaheExpenses.fetchRequest() as NSFetchRequest<CaheExpenses>
            request.predicate = NSPredicate(format: "expenseName = %@ AND categoryName = %@", forName, andCategory)
            expenseList = try viewContext.fetch(request)
        }catch{
            
        }
        
        return expenseList
    }
    
    
    public static func deleteAll(viewContext: NSManagedObjectContext) {
        var expenseList:[CaheExpenses] = [CaheExpenses]()
        do{
            let request = CaheExpenses.fetchRequest() as NSFetchRequest<CaheExpenses>
            expenseList = try viewContext.fetch(request)
            
            if expenseList.count > 0 {
                for item in expenseList {
                    viewContext.delete(item)
                }
            }
        }catch{
            
        }
        
    }
}
