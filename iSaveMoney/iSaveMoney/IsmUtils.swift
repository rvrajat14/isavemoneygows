//
//  IsmUtils.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 7/13/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit
import ISMLBase
import ISMLDataService
import CheckoutModule


class IsmUtils {
    static func formatTimeStamp(_ dateVal: Int) -> String {
        
        let pref = MyPreferences()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = pref.getDateFormat()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        
        let myDate = Date(timeIntervalSince1970: TimeInterval(dateVal))
        
        return dateFormatter.string(from: myDate)
        
    }
    func dateFormat(_ dateVal: Date) -> String {
           
           let pref = MyPreferences()
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = pref.getDateFormat()
           dateFormatter.timeZone = TimeZone.autoupdatingCurrent
           return dateFormatter.string(from: dateVal)
           //dateFormatter.dateFromString(formatter.stringFromDate(dateVal))
       }
    
    static func timeFormat(_ dateVal: Int) -> String {
        
        let pref = MyPreferences()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = pref.getTimeFormat()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        
        let myDate = Date(timeIntervalSince1970: TimeInterval(dateVal))
        
        return dateFormatter.string(from: myDate)
        
    }
    
    static func makeTitleFor(budget: Budget) -> String {
    
        //var start_date:Int = budget.start_date
        //var end_date:Int = budget.end_date
        
        if budget.comment != nil && budget.comment != "" {
            return budget.comment
        }
        
        var titleFromStartEnd:String = ""
        let start_date = Date(timeIntervalSince1970: TimeInterval(budget.start_date))
        let end_date = Date(timeIntervalSince1970: TimeInterval(budget.end_date))
        
        let calendar_start = Calendar.current
        let components_start = calendar_start.dateComponents([.day , .month , .year], from: start_date)
        
        let calendar_end = Calendar.current
        let components_end = calendar_end.dateComponents([.day , .month , .year], from: end_date)
        
        let year_start =  components_start.year!
        let month_start = components_start.month! - 1
        let day_start = components_start.day!
        //
        let year_end =  components_end.year!
        let month_end = components_end.month! - 1
        let day_end = components_end.day!
        
        
        if(year_start==year_end) {
            
            
            
            if(month_start==month_end) {
                
                //titleFromStartEnd = MONTHS_SHORT[month_start] + " " + titleFromStartEnd
                
                
                if(day_start==day_end){
                
                    titleFromStartEnd = "\(UtilsIsm.MONTHS_SHORT[month_start]) \(day_start), \(year_start)"
                }else{
                    titleFromStartEnd = "\(UtilsIsm.MONTHS_SHORT[month_start]) \(day_start) - \(day_end), \(year_start)"
                }
                
                
            }else{
                
                titleFromStartEnd = "\(UtilsIsm.MONTHS_SHORT[month_start]) \(day_start) - \(UtilsIsm.MONTHS_SHORT[month_end]) \(day_end), \(UtilsIsm.lastTowDigitsOfYear(year_start))"
            }
            
            
        } else {
            
        
            titleFromStartEnd = "\(UtilsIsm.MONTHS_SHORT[month_start]) \(day_start), \(UtilsIsm.lastTowDigitsOfYear(year_start)) - \(UtilsIsm.MONTHS_SHORT[month_end]) \(day_end), \(UtilsIsm.lastTowDigitsOfYear(year_end))"
            
        }
        
        return titleFromStartEnd
        
    }
    
    static func makeTitleFor(user_own: UserOwnBudget) -> String {
        
        if user_own.budgetTitle != nil && user_own.budgetTitle != "" {
            return user_own.budgetTitle
        }
        
        var titleFromStartEnd:String = ""
        let start_date = Date(timeIntervalSince1970: TimeInterval(user_own.start_date))
        let end_date = Date(timeIntervalSince1970: TimeInterval(user_own.end_date))
        
        let calendar_start = Calendar.current
        let components_start = calendar_start.dateComponents([.day , .month , .year], from: start_date)
        
        let calendar_end = Calendar.current
        let components_end = calendar_end.dateComponents([.day , .month , .year], from: end_date)
        
        let year_start =  components_start.year!
        let month_start = components_start.month! - 1
        let day_start = components_start.day!
        //
        let year_end =  components_end.year!
        let month_end = components_end.month! - 1
        let day_end = components_end.day!
        
        
        if(year_start==year_end) {
            
            
            
            if(month_start==month_end) {
                
                //titleFromStartEnd = MONTHS_SHORT[month_start] + " " + titleFromStartEnd
                
                
                if(day_start==day_end){
                    
                    titleFromStartEnd = "\(UtilsIsm.MONTHS_SHORT[month_start]) \(day_start), \(year_start)"
                }else{
                    titleFromStartEnd = "\(UtilsIsm.MONTHS_SHORT[month_start]) \(day_start) - \(day_end), \(year_start)"
                }
                
                
            }else{
                
                titleFromStartEnd = "\(UtilsIsm.MONTHS_SHORT[month_start]) \(day_start) - \(UtilsIsm.MONTHS_SHORT[month_end]) \(day_end), \(UtilsIsm.lastTowDigitsOfYear(year_start))"
            }
            
            
        } else {
            
            
            titleFromStartEnd = "\(UtilsIsm.MONTHS_SHORT[month_start]) \(day_start), \(UtilsIsm.lastTowDigitsOfYear(year_start)) - \(UtilsIsm.MONTHS_SHORT[month_end]) \(day_end), \(UtilsIsm.lastTowDigitsOfYear(year_end))"
            
        }
        
        return titleFromStartEnd
        
    }
    
    
    
    
    
    static func readCurrenciesFile() -> [MCurrency] {
        
        var currencies:[MCurrency] = []
        let url = Bundle.main.url(forResource: "currency_list", withExtension: "json")
        let data = NSData(contentsOf: url!)
        
        do {
            let object = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments)
            if let dictionary = object as? [String: AnyObject] {
                
                let all_sections = dictionary["data"] as! [AnyObject]
                
                for section in all_sections as [AnyObject] {
                    
                    let currency = MCurrency()
                    
                    currency.name = section["name"] as! String
                    
                    let locals:[String] = (section["codes"] as! String).components(separatedBy: ",")
                    
                    if locals.count > 0 {
                        
                        currency.local = locals[0]
                        currencies.append(currency)
                    }
                    
                    
                }
            }
        } catch {
            // Handle Error
        }
        
        return currencies
    }
    
    static func promtForPro(navContoller: UIViewController, featureName: String) {
        
        let vc = GoProViewController(nibName: "GoProViewController", bundle: Bundle(identifier: CoConst.BUNDLE_ID))
        vc.proTextDisplay = featureName
        let nav = UINavigationController(rootViewController: vc)
        navContoller.present(nav, animated: true)
    }
    
    static func promtForPurchase(navContoller: UIViewController) {
        
        let vc = PurchaseViewController(nibName: "PurchaseViewController", bundle: Bundle(identifier: CoConst.BUNDLE_ID))
        let nav = UINavigationController(rootViewController: vc)
        navContoller.present(nav, animated: true)
    }
    
    static func promtForSub(navContoller: UIViewController) {
        
        let vc = SubscriptionViewController(nibName: "SubscriptionViewController", bundle: Bundle(identifier: CoConst.BUNDLE_ID))
        //let nav = UINavigationController(rootViewController: vc)
        navContoller.present(vc, animated: true)
    }
    
    static func confirmDelete(appDelegate: AppDelegate,
                              name: String,
                              confirmed: @escaping ()->Void) -> UIAlertController {
        let alertController = UIAlertController(
            title: NSLocalizedString("conformDeleteTitle", comment: "Confirm delete"),
            message: NSLocalizedString("conformDeleteDesc", comment: "Do you want to delete [title]. This action will be permanent")
                .replacingOccurrences(of: "[title]", with: name),
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("text_cancel", comment: "Cancel"), style: .cancel) { action in
        })
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("text_continue", comment: "Continue"), style: .destructive) { action in
            // perhaps use action.title here
            confirmed()
        })
        
        return alertController
    }
    
    static func confirmAction(appDelegate: AppDelegate,
                              description: String,
                              confirmed: @escaping ()->Void) -> UIAlertController {
        let alertController = UIAlertController(
            title: NSLocalizedString("dgConfirm", comment: "Confirm"),
            message: description,
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("text_cancel", comment: "Cancel"), style: .cancel) { action in
        })
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("text_continue", comment: "Continue"), style: .default) { action in
            // perhaps use action.title here
            confirmed()
        })
        
        return alertController
    }
}
///Users/akoudoum/iOSWorkspace/isavemoneygows/Pods/FirebaseCrashlytics/upload-symbols -gsp /Users/akoudoum/iOSWorkspace/isavemoneygows/iSaveMoney/iSaveMoney/GoogleService-Info.plist -p ios /Users/akoudoum/Downloads/appDsyms
// Where to get the appDSyms-2
