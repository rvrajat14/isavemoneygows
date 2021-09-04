//
//  PieData.swift
//  ISMLDataService
//
//  Created by ARMEL KOUDOUM on 9/10/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import Foundation

class PieData {
    public var value:Double
    public var dateText:String
    public var tag: Int
    
    public init(val:Double, date:String, tag:Int) {
        self.value = val
        self.dateText = date
        self.tag = tag
    }
}
