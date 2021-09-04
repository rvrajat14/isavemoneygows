//
//  DrawerItem.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 6/10/16.
//  Copyright © 2016 UlmatCorpit. All rights reserved.
//

import UIKit

public class DrawerItem {
    
    public var id: Int
    public var gid: String
    public var type: DrawerNav
    public var title: String
    public var itemIcon: UIImage!
    public var hasSeparator:Bool = true
    
    
    
    public init?(id: Int, type: DrawerNav, title: String, itemIcon: UIImage?, sep:Bool = true) {
        
        self.id = id
        self.type = type
        self.title = title
        self.itemIcon = itemIcon
        self.gid = ""
        self.hasSeparator = sep
        
        if title.isEmpty {
            
            return nil
        }
        
    }
    
}
