//
//  CaheExpenses+CoreDataProperties.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 12/12/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//
//

import Foundation
import CoreData


extension CaheExpenses {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CaheExpenses> {
        return NSFetchRequest<CaheExpenses>(entityName: "CaheExpenses")
    }

    @NSManaged public var categoryName: String?
    @NSManaged public var expenseName: String?
    @NSManaged public var insertDate: Int64

}

extension CaheExpenses : Identifiable {

}
