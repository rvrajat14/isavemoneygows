//
//  MyCircle+CoreDataProperties.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 12/11/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//
//

import Foundation
import CoreData


extension MyCircle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyCircle> {
        return NSFetchRequest<MyCircle>(entityName: "MyCircle")
    }

    @NSManaged public var userId: String?
    @NSManaged public var userName: String?
    @NSManaged public var userPhoto: String?

}

extension MyCircle : Identifiable {

}
