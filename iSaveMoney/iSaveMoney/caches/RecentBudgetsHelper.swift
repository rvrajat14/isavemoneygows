//
//  RecentBudgetsHelper.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 12/11/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import Foundation
import CoreData

public class RecentBudgetsHelper{
    
    public static func insertBudget(viewContext: NSManagedObjectContext, forId: String, andName: String) {
        
        let budgetList:[RecentBudgets] = getBudget(viewContext: viewContext, forId: forId)
        
        if budgetList.count > 0 {
            for item in budgetList {
                print("Remove \(item.budgetName!)  \(item.budgetId!)")
                viewContext.delete(item)
            }
        }
        let recent = RecentBudgets(context: viewContext)
        recent.budgetId = forId
        recent.budgetName = andName
        recent.insertTime = Int64(Date().timeIntervalSince1970)
        print("Remove insert \(recent.budgetName!)  \(recent.insertTime)")
        do{
            try viewContext.save()
        }catch{
            
        }
    }
    
    public static func getLastThree(viewContext: NSManagedObjectContext) -> [RecentBudgets]{
        
        var budgetList:[RecentBudgets] = [RecentBudgets]()
        do{
            let request = RecentBudgets.fetchRequest() as NSFetchRequest<RecentBudgets>
            request.sortDescriptors = [NSSortDescriptor(keyPath: \RecentBudgets.insertTime, ascending: false)]
            //request.fetchLimit = 3
            budgetList = try viewContext.fetch(request)
   

        }catch{
            
        }
        
        budgetList = budgetList.sorted(by: { $0.insertTime > $1.insertTime})
        
        if budgetList.count > 3 {
            budgetList = Array(budgetList[0..<3])
        }
        return budgetList
    }
    
    public static func getBudget(viewContext: NSManagedObjectContext, forId: String) -> [RecentBudgets] {
        var budgetList:[RecentBudgets] = [RecentBudgets]()
        do{
            let request = RecentBudgets.fetchRequest() as NSFetchRequest<RecentBudgets>
            request.predicate = NSPredicate(format: "budgetId = %@", forId)
            budgetList = try viewContext.fetch(request)
        }catch{
            
        }
        
        return budgetList
    }
    
    
    public static func deleteAll(viewContext: NSManagedObjectContext) {
        var budgetList:[RecentBudgets] = [RecentBudgets]()
        do{
            let request = RecentBudgets.fetchRequest() as NSFetchRequest<RecentBudgets>
            budgetList = try viewContext.fetch(request)
            
            if budgetList.count > 0 {
                for item in budgetList {
                    viewContext.delete(item)
                }
            }
        }catch{
            
        }
        
    }
    
    public static func delete(viewContext: NSManagedObjectContext, thisId: String) {
        var budgetList:[RecentBudgets] = [RecentBudgets]()
        do{
            let request = RecentBudgets.fetchRequest() as NSFetchRequest<RecentBudgets>
            budgetList = try viewContext.fetch(request)
            
            if budgetList.count > 0 {
                for item in budgetList {
                    if item.budgetId == thisId {
                        viewContext.delete(item)
                    }
                    
                }
            }
        }catch{
            
        }
        
    }
}
