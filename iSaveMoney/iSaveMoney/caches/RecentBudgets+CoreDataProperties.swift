//
//  RecentBudgets+CoreDataProperties.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 12/11/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//
//

import Foundation
import CoreData


extension RecentBudgets {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentBudgets> {
        return NSFetchRequest<RecentBudgets>(entityName: "RecentBudgets")
    }

    @NSManaged public var budgetId: String?
    @NSManaged public var budgetName: String?
    @NSManaged public var insertTime: Int64

}

extension RecentBudgets : Identifiable {

}
