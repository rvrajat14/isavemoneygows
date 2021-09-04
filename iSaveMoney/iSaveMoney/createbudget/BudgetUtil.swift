//
//  BudgetUtil.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 9/10/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import Foundation
import ISMLBase
import ISMLDataService

class BudgetUtil{
    static func readTemplateFile(filename:String) -> [BudgetSection] {
        
        print("template name: \(filename)")
        var budgetSection:[BudgetSection] = []
        let url = Bundle.main.url(forResource: filename, withExtension: "json")
        let data = NSData(contentsOf: url!)
        
        do {
            let object = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments)
            if let dictionary = object as? [String: AnyObject] {
                //print(dictionary["data"])
                let all_sections = dictionary["data"] as! [AnyObject]
                
                for section in all_sections as [AnyObject] {
                
                    let typeRow:Int = section["type"] as! Int
                    
                    let row = BudgetSection(id: 0, title: (section["name"] as! String), value: (section["amount"] as! Double), budget: 0, spent: 0, date: "", type: RowType.income)
                    
                    if typeRow == 1 {
                        
                        row?.type = RowType.income
                    } else {
                    
                        row?.type = RowType.category
                        
                        row?.items = section["items"] as! [String]
                        
                    }
                    
                    budgetSection.append(row!)
                    
                }
            }
        } catch {
            // Handle Error
        }
        
        return budgetSection
    }
}
