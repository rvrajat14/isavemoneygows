//
//  DSConst.swift
//  ISMLDataService
//
//  Created by Armel Koudoum on 7/14/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import Foundation
import ISMLBase

public enum RowType {
    
    case stat
    case totalIncome
    case income
    case totalCategory
    case category
    case title
    case emptyBudget
}


public enum DrawerNav {
    case type_USER_ACCOUNT
    case type_LOGOUT
    case type_MAIN
    case type_MONTH
    case type_OTHER_MONTH
    case type_NEW_BUDGET
    case type_DUPLICATE_BUDGET
    case type_FORECAST
    case type_ACTIVITIES
    case type_ACCOUNTS
    case type_PAYEES
    case type_PAYERS
    case type_RECURRING
    case type_SETTINGS
    case type_ARCHIVE
    case type_HELP
    case type_SEPARATOR
    case type_UPGRADE
    case type_LABELS
    case type_USER_GROUPS
    case type_MY_TRANSACTIONS
    case type_ANALYTICS
}

class Const {
    //static let ENVIRONEMENT:String = ""
    #if ENV_DEV
    public static let ENVIRONEMENT:String = ""
    #elseif ENV_MM
    public static let ENVIRONEMENT:String = ""
    #elseif ENV_PROD
    public static let ENVIRONEMENT:String = ""
    #else
    public static let ENVIRONEMENT:String = ""
    #endif
}

public class Utils{
    public init(){}
    public static func validString(val:String?) -> Bool {
        
        return (val != nil && val != "")
    }
    
    public static func Log(tag:String, message:String) {
    
        print("\(tag):: \(message)")
    }
    
    
    public static func CleanText(text:String) -> String {
    
        var title = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        title = String(title.filter { !" \n\t\r\\/".contains($0) })
        
        return title.lowercased()
    }
    
    public static func trimText(text:String) -> String {
        
        return text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
    }
    
    public static func formatTimeStamp(_ dateVal: Int) -> String {
        
        let pref = MyPreferences()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = pref.getDateFormat()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        
        let myDate = Date(timeIntervalSince1970: TimeInterval(dateVal))
        
        return dateFormatter.string(from: myDate)
        
    }
    
    public static func timeFormat(_ dateVal: Int) -> String {
        
        let pref = MyPreferences()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = pref.getTimeFormat()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        
        let myDate = Date(timeIntervalSince1970: TimeInterval(dateVal))
        
        return dateFormatter.string(from: myDate)
        
    }
}


public class Scheduler{
    public static let TRANSACTION_TYPE_INCOME:Int = 0
    public static let TRANSACTION_TYPE_EXPENSE:Int = 1
    public static let TRANSACTION_TYPE_NOTE:Int = 2
    public static let TRANSACTION_TYPE_REMIND:Int = 3
    public static let TRANSACTION_TYPE_TRANSFER:Int = 4
}
public class ScheduleTypeString {
    public static let DAILY:String = NSLocalizedString("TypeDay", comment: "Day")
    public static let WEEKLY:String = NSLocalizedString("TypeWeek", comment: "Week")
    public static let MONTHLY:String = NSLocalizedString("TypeMonth", comment: "Month")
    public static let YEARLY:String = NSLocalizedString("TypeYear", comment: "Year")
}

public class ScheduleType {
    public static let DAILY:Int = 0
    public static let WEEKLY:Int = 1
    public static let MONTHLY:Int = 2
    public static let YEARLY:Int = 3
}
public class ScheduleCount {
    public static let FOR_EVER:Int = 0
    public static let UNTIL:Int = 1
    public static let NUMBER_EVENT:Int = 2
}
