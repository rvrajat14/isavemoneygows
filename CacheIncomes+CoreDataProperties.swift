//
//  CacheIncomes+CoreDataProperties.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 12/12/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//
//

import Foundation
import CoreData


extension CacheIncomes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CacheIncomes> {
        return NSFetchRequest<CacheIncomes>(entityName: "CacheIncomes")
    }

    @NSManaged public var incomeName: String?
    @NSManaged public var categoryName: String?
    @NSManaged public var insertDate: Int64

}

extension CacheIncomes : Identifiable {

}
