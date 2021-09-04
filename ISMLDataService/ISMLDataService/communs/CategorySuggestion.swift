//
//  CategorySuggestion.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 4/21/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import Foundation

public class CategorySuggestion {

    public var items:[String:SuggestionItem] = [:]
    public var title:String = ""
    public var simpleTitle:String = ""
    
    public init() {}
    
    public func addItem(name:String) {
    
        
        let itemSugg = SuggestionItem()
        
        itemSugg.simpleTitle = Utils.CleanText(text: name)
        itemSugg.title = Utils.trimText(text: name)
        
        items[itemSugg.simpleTitle] = itemSugg
    }
}
