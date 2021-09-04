//
//  ScheduleType.swift
//  ISMLBase
//
//  Created by ARMEL KOUDOUM on 8/7/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import Foundation

public class SchedulTyp {
    public static let DAILY:Int = 0
    public static let WEEKLY:Int = 1
    public static let MONTHLY:Int = 2
    public static let YEARLY:Int = 3
}

public class ScheduleTypeStr {
    public static let DAILY:String = NSLocalizedString("TypeDay", comment: "Day")
    public static let WEEKLY:String = NSLocalizedString("TypeWeek", comment: "Week")
    public static let MONTHLY:String = NSLocalizedString("TypeMonth", comment: "Month")
    public static let YEARLY:String = NSLocalizedString("TypeYear", comment: "Year")
}

public class SchedulCnt {
    public static let FOR_EVER:Int = 0
    public static let UNTIL:Int = 1
    public static let NUMBER_EVENT:Int = 2
}
