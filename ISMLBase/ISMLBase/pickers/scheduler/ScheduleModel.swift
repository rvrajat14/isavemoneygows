//
//  Schedule.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 12/30/16.
//  Copyright © 2016 UlmatCorpit. All rights reserved.
//






///-------------createSchedule----------------------
import Foundation

public class ScheduleModel{

    public var type:Int!
    public var step:Int!
    public var weeklyDay:Int!
    public var monthlyOption:Int!
    public var typeMaxOccur:Int!
    public var numberEvent:Int!
    public var dateLimitOccur:Int!
    public var lastOccurred:Int!
    public var nextOccurred:Int!

    
    public init() {
        self.type = 0
        self.step = 0
        self.weeklyDay = 0
        self.monthlyOption = 0
        self.typeMaxOccur = 0
        self.numberEvent = 0
        self.dateLimitOccur = 0
        self.lastOccurred = 0
        self.nextOccurred = 0
    }
    public init(
         type:Int,
         step:Int,
         weeklyDay:Int,
         monthlyOption:Int,
         typeMaxOccur:Int,
         numberEvent:Int,
         dateLimitOccur:Int,
         lastOccurred:Int,
         nextOccurred:Int
         ) {
    
        self.type = type
        self.step = step
        self.weeklyDay = weeklyDay
        self.monthlyOption = monthlyOption
        self.typeMaxOccur = typeMaxOccur
        self.numberEvent = numberEvent
        self.dateLimitOccur = dateLimitOccur
        self.lastOccurred = lastOccurred
        self.nextOccurred = nextOccurred
    }
    
    public func toAnyObject() -> NSDictionary {
        return [
            "type": self.type as Int,
            "step": self.step as Int,
            "weeklyDay": self.weeklyDay as Int,
            "monthlyOption": self.monthlyOption as Int,
            "typeMaxOccur": self.typeMaxOccur as Int,
            "numberEvent": self.numberEvent as Int,
            "dateLimitOccur": self.dateLimitOccur as Int,
            "lastOccurred": self.lastOccurred as Int,
            "nextOccurred": self.nextOccurred as Int
        ]
    }
    
    public func copyFromDictionary(value: NSDictionary) {
        self.type = value["type"] as? Int ?? 0
        self.step = value["step"] as? Int ?? 0
        self.weeklyDay = value["weeklyDay"] as? Int ?? 0
        self.monthlyOption = value["monthlyOption"] as? Int ?? 0
        self.typeMaxOccur = value["typeMaxOccur"] as? Int ?? 0
        self.numberEvent = value["numberEvent"] as? Int ?? 0
        self.dateLimitOccur = value["dateLimitOccur"] as? Int ?? 0
        self.lastOccurred = value["lastOccurred"] as? Int ?? 0
        self.nextOccurred = value["nextOccurred"] as? Int ?? 0
    }
    
    public func setLastOccurence(firstGoOff:Int) {
        
        self.nextOccurred = firstGoOff
        let calendar = Date(timeIntervalSince1970: Double(firstGoOff))
        var futureDate = Date(timeIntervalSince1970: Double(firstGoOff))
        
        switch type {
        case SchedulTyp.DAILY:
            var dateComponent = DateComponents()
            dateComponent.year = step * (-1)
            futureDate = Calendar.current.date(byAdding: dateComponent, to: calendar)!
            //calendar = calendar + (1000)
            break
        case SchedulTyp.WEEKLY:
            var dateComponent = DateComponents()
            dateComponent.weekOfYear = step * (-1)
            futureDate = Calendar.current.date(byAdding: dateComponent, to: calendar)!
            break
        case SchedulTyp.MONTHLY:
            var dateComponent = DateComponents()
            dateComponent.month = step * (-1)
            futureDate = Calendar.current.date(byAdding: dateComponent, to: calendar)!
            break
        case SchedulTyp.YEARLY:
            var dateComponent = DateComponents()
            dateComponent.year = step * (-1)
            futureDate = Calendar.current.date(byAdding: dateComponent, to: calendar)!
            break
        default:
            var dateComponent = DateComponents()
            dateComponent.year = step * (-1)
            futureDate = Calendar.current.date(byAdding: dateComponent, to: calendar)!
            break
        }
        
        lastOccurred = Int(futureDate.timeIntervalSince1970)
    }
    
    public func setNextOccur(firstGoesOff:Int) {
        nextOccurred = firstGoesOff
    }
    public func setLastOccurred (_ lastOccurred: Int) {
        self.lastOccurred = lastOccurred
    }
    
    public func verboseSchedule() -> String {
        
        var verbose:String = ""
        
        switch type {
        case SchedulTyp.DAILY:
            verbose = NSLocalizedString("verboseSchedule", comment: "sch verbose")
                .replacingOccurrences(of: "[number]", with: String(step))
                .replacingOccurrences(of: "[type]", with: ScheduleTypeStr.DAILY)
            break
            
        case SchedulTyp.WEEKLY:
            verbose = NSLocalizedString("verboseSchedule", comment: "sch verbose")
                .replacingOccurrences(of: "[number]", with: String(step))
                .replacingOccurrences(of: "[type]", with: ScheduleTypeStr.WEEKLY)
            break
        case SchedulTyp.MONTHLY:
            verbose = NSLocalizedString("verboseSchedule", comment: "sch verbose")
                .replacingOccurrences(of: "[number]", with: String(step))
                .replacingOccurrences(of: "[type]", with: ScheduleTypeStr.MONTHLY)
            break
        case SchedulTyp.YEARLY:
            verbose = NSLocalizedString("verboseSchedule", comment: "sch verbose")
                .replacingOccurrences(of: "[number]", with: String(step))
                .replacingOccurrences(of: "[type]", with: ScheduleTypeStr.YEARLY)
            break
        default:
            verbose = NSLocalizedString("verboseSchedule", comment: "sch verbose")
                .replacingOccurrences(of: "[number]", with: String(step))
                .replacingOccurrences(of: "[type]", with: ScheduleTypeStr.DAILY)
            break
        }
        
        if(typeMaxOccur == SchedulCnt.NUMBER_EVENT) {
            verbose = verbose + NSLocalizedString("verboseScheduleLimit", comment: "").replacingOccurrences(of: "[number]", with: String(numberEvent))
        }else {
            verbose = verbose + NSLocalizedString("verboseScheduleEver", comment: "")
        }
        
        return verbose
    }
    
}
