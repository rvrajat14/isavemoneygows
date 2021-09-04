//
//  Utils.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 7/4/16.
//  Copyright © 2016 UlmatCorpit. All rights reserved.
//

import UIKit

public class UtilsIsm {
    
    public static let MONTHS = [NSLocalizedString("January", comment: "January"),
                         NSLocalizedString( "February", comment:  "February"),
                         NSLocalizedString( "March", comment:  "March"),
                         NSLocalizedString( "April", comment:  "April"),
                         NSLocalizedString( "May", comment:  "May"),
                         NSLocalizedString( "June", comment:  "June"),
                         NSLocalizedString( "July", comment:  "July"),
                         NSLocalizedString( "August", comment:  "August"),
                         NSLocalizedString( "September", comment:  "September"),
                         NSLocalizedString( "October", comment:  "October"),
                         NSLocalizedString( "November", comment:  "November"),
                         NSLocalizedString( "December", comment:  "December")]
    
    public static let MONTHS_SHORT = [NSLocalizedString("txt_Jan", comment: "January"),
                               NSLocalizedString( "txt_Feb", comment:  "February"),
                               NSLocalizedString( "txt_Mar", comment:  "March"),
                               NSLocalizedString( "txt_Apr", comment:  "April"),
                               NSLocalizedString( "txt_May", comment:  "May"),
                               NSLocalizedString( "txt_Jun", comment:  "June"),
                               NSLocalizedString( "txt_Jul", comment:  "July"),
                               NSLocalizedString( "txt_Aug", comment:  "August"),
                               NSLocalizedString( "txt_Sep", comment:  "September"),
                               NSLocalizedString( "txt_Oct", comment:  "October"),
                               NSLocalizedString( "txt_Nov", comment:  "November"),
                               NSLocalizedString( "txt_Dec", comment:  "December")]
    

    
    public init(){
    
    }
    
   
    
    public static func dateFormatOrTimeFor(_ dateVal: Date, format:String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
    
        return dateFormatter.string(from: dateVal)
        //dateFormatter.dateFromString(formatter.stringFromDate(dateVal))
    }
    
    
    
    
    
    public static func lastTowDigitsOfYear(_ year:Int) -> String {
        let year_var = "\(year)"
        let index = year_var.index(year_var.startIndex, offsetBy: 2)
        return year_var.substring(from: index)
    }
    
    
    
    
    
    
    
    
    public static func DateTimeFormat(date: Date) -> String {
        
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = NSLocalizedString("format_date_time", comment: "MMM dd, yyyy hh a")
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: date)
        
        return selectedDate
    }
    
    public static func FormatMonthYear(date: Date) -> String {
        
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "MMMM yyyy"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: date)
        
        return selectedDate
    }
    
    public static func ChartDateFormat(date: Date) -> String {
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = NSLocalizedString("format_chart_date", comment: "MMMM dd, yyyy")
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: date)
        
        return selectedDate
    }

    public static func MonthYearFormat(date: Date) -> String {
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "MMMM yyyy"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: date)
        
        return selectedDate
    }
    
    public static func validString(val:String?) -> Bool {
        
        return (val != nil && val != "")
    }
    
    
    
    
    
    public static func formartCurrency(value: Double, local: String) -> String {
        
        let formatter: NumberFormatter = NumberFormatter()
        
        formatter.numberStyle = .currency
        
        if local != "" {
            //print("Local-Found \(local)")
            formatter.locale = Locale(identifier: local)
        } else {
            //print("Local-Found-none")
            formatter.locale = Locale.current
        }
        
        return formatter.string(from: value as NSNumber)!
        //return formatter.string(from: 95.50)!
    
    }
    
    public static func lastHourOfTheDay(varDate: Date) -> Date {
    
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        
        dateComponents = calendar.dateComponents([.year, .month, .day], from: varDate as Date)
        
        dateComponents.hour = 23
        dateComponents.minute = 59
        dateComponents.second = 59
        dateComponents.nanosecond = 999*1000000
        
        
        //return dateComponents.date!
        return calendar.date(from: dateComponents)!
    }
    
    
    public static func firstHourOfTheDay(varDate: Date) -> Date {
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        
        dateComponents = calendar.dateComponents([.year, .month, .day], from: varDate as Date)
        
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        dateComponents.nanosecond = 0
        
        return calendar.date(from: dateComponents)!
        //return dateComponents.date!
    }
    
    public static func getPastDay(date:Date, number: Int) -> Date {
        
        
        let newDate = NSCalendar.current.date(byAdding: .day, value: number, to: date)
        
        return newDate!
            //.dateByAddingUnit(.Day, value: -1, toDate: NSDate(), options: [])!
    
        
    }
    
    public static func Log(tag:String, message:String) {
    
        print("\(tag):: \(message)")
    }
    
    
    public static func CleanText(text:String) -> String {
    
        var title = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        title = String(title.filter { !" \n\t\r\\/".contains($0) })
        
        return title.lowercased()
    }
    
    public static func trimTextIsm(text:String) -> String {
        
        return text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
    }
    
    public static func getUrlParams(urlLink:String) -> [String:String] {
    
        var urlParts:[String:String] = [:]
        let yourTargetUrl = URL(string:urlLink)!
            
        //var dict = [String:String]()
        let components = URLComponents(url: yourTargetUrl, resolvingAgainstBaseURL: false)!
        
        let urlQuery = components.query
        
        if urlQuery != nil && urlQuery != "" {
            
            let params:[String] = urlQuery!.components(separatedBy: "&")
            
            for param in params {
            
                if param != "" {
                    
                    let parts:[String] = param.components(separatedBy: "=")
                    
                    if parts.count > 1 {
                        urlParts[parts[0]] = parts[1]
                    }
                }
        
            }
        }
        
        return urlParts
    }
    
    
    
    public static func getTimeStamp() -> Int {
        return Int(Date().timeIntervalSince1970)
    }
    
    public static func getBackgroundColor(vc:UIView) -> UIColor {
        if #available(iOS 12.0, *) {
          if vc.traitCollection.userInterfaceStyle == .dark {
               return .black
           } else {
               return .white
           }
        } else {
           return .white
        }
    }
    
    public static func getShadowColor(vc:UIView) -> UIColor {
        if #available(iOS 12.0, *) {
          if vc.traitCollection.userInterfaceStyle == .dark {
               return .white
           } else {
               return .black
           }
        } else {
           return .black
        }
    }
    
    public static func DateFormat(date: Date, format: String) -> String {
        
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = format
        print("Format date: \(dateFormatter.dateFormat)")
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: date)
        
        return selectedDate
    }
}
