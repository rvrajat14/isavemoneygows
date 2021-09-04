//
//  PickerItem.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 1/22/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import Foundation

public class PickerItem {
    
    public var id:Int!
    public var gid:String!
    public var title:String!
     
    public init?(id: Int, gid: String, title: String) {
        
        self.id = id
        self.gid = gid
        self.title = title
        
        if title.isEmpty {
            
            return nil
        }
        
    }
}
