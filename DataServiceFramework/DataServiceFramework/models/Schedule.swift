//
//  Schedule.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 12/30/16.
//  Copyright © 2016 UlmatCorpit. All rights reserved.
//






///-------------createSchedule----------------------

import Firebase
import FirebaseDatabase

public class Schedule{
    public var gid:String!
    public var schedule_gid:String!
    public var user_gid:String!
    public var transaction_gid:String!
    public var transaction_type:Int!
    public var transaction_title:String!
    public var schedule_payload:NSDictionary!
    public var type:Int!
    public var step:Int!
    public var weeklyDay:Int!
    public var monthlyOption:Int!
    public var typeMaxOccur:Int!
    public var numberEvent:Int!
    public var dateLimitOccur:Int!
    public var active:Int!
    public var insert_date:Int!
    public var last_update:Int!
    public var lastOccurred:Int!
    public var nextOccurred:Int!
    public var transaction_str:NSDictionary!
    
    public init() {
        self.gid = ""
        self.schedule_gid = ""
        self.user_gid = ""
        self.transaction_gid = ""
        self.transaction_type = 0
        self.transaction_title = ""
        self.schedule_payload = [:]
        self.transaction_str = [:]
        self.type = 0
        self.step = 0
        self.weeklyDay = 0
        self.monthlyOption = 0
        self.typeMaxOccur = 0
        self.numberEvent = 0
        self.dateLimitOccur = 0
        self.active = 0
        self.insert_date = 0
        self.last_update = 0
        self.lastOccurred = 0
        self.nextOccurred = 0
    }
    public init(gid:String,
         schedule_gid:String,
         user_gid:String,
         transaction_gid:String,
         transaction_type:Int,
         transaction_title:String,
         type:Int,
         step:Int,
         weeklyDay:Int,
         monthlyOption:Int,
         typeMaxOccur:Int,
         numberEvent:Int,
         dateLimitOccur:Int,
         active:Int,
         insert_date:Int,
         last_update:Int,
         lastOccurred:Int,
         nextOccurred:Int
         ) {
        self.gid = gid
        self.schedule_gid = schedule_gid
        self.user_gid = user_gid
        self.transaction_gid = transaction_gid
        self.transaction_type = transaction_type
        self.transaction_title = transaction_title
        self.type = type
        self.step = step
        self.weeklyDay = weeklyDay
        self.monthlyOption = monthlyOption
        self.typeMaxOccur = typeMaxOccur
        self.numberEvent = numberEvent
        self.dateLimitOccur = dateLimitOccur
        self.active = active
        self.insert_date = insert_date
        self.last_update = last_update
        self.lastOccurred = lastOccurred
        self.nextOccurred = nextOccurred
    }
    public init(snapshot: DataSnapshot!) {
        let value = snapshot.value as? NSDictionary
        self.gid = snapshot.key
        self.gid = value?["gid"] as? String ?? ""
        self.schedule_gid = value?["schedule_gid"] as? String ?? ""
        self.user_gid = value?["user_gid"] as? String ?? ""
        self.transaction_gid = value?["transaction_gid"] as? String ?? ""
        self.transaction_type = value?["transaction_type"] as? Int ?? 0
        self.transaction_title = value?["transaction_title"] as? String ?? ""
        self.type = value?["type"] as? Int ?? 0
        self.step = value?["step"] as? Int ?? 0
        self.weeklyDay = value?["weeklyDay"] as? Int ?? 0
        self.monthlyOption = value?["monthlyOption"] as? Int ?? 0
        self.typeMaxOccur = value?["typeMaxOccur"] as? Int ?? 0
        self.numberEvent = value?["numberEvent"] as? Int ?? 0
        self.dateLimitOccur = value?["dateLimitOccur"] as? Int ?? 0
        self.active = value?["active"] as? Int ?? 0
        self.insert_date = value?["insert_date"] as? Int ?? 0
        self.last_update = value?["last_update"] as? Int ?? 0
        self.lastOccurred = value?["lastOccurred"] as? Int ?? 0
        self.nextOccurred = value?["nextOccurred"] as? Int ?? 0
        self.schedule_payload = value?["schedule_payload"] as? NSDictionary ?? nil
        self.transaction_str = value?["transaction_str"] as? NSDictionary ?? nil
    }
    
    public init(dataMap: [String:Any]) {
        
        self.gid = dataMap["gid"] as? String ?? ""
        self.schedule_gid = dataMap["schedule_gid"] as? String ?? ""
        self.user_gid = dataMap["user_gid"] as? String ?? ""
        self.transaction_gid = dataMap["transaction_gid"] as? String ?? ""
        self.transaction_type = dataMap["transaction_type"] as? Int ?? 0
        self.transaction_title = dataMap["transaction_title"] as? String ?? ""
        self.type = dataMap["type"] as? Int ?? 0
        self.step = dataMap["step"] as? Int ?? 0
        self.weeklyDay = dataMap["weeklyDay"] as? Int ?? 0
        self.monthlyOption = dataMap["monthlyOption"] as? Int ?? 0
        self.typeMaxOccur = dataMap["typeMaxOccur"] as? Int ?? 0
        self.numberEvent = dataMap["numberEvent"] as? Int ?? 0
        self.dateLimitOccur = dataMap["dateLimitOccur"] as? Int ?? 0
        self.active = dataMap["active"] as? Int ?? 0
        self.insert_date = dataMap["insert_date"] as? Int ?? 0
        self.last_update = dataMap["last_update"] as? Int ?? 0
        self.lastOccurred = dataMap["lastOccurred"] as? Int ?? 0
        self.nextOccurred = dataMap["nextOccurred"] as? Int ?? 0
        self.schedule_payload = dataMap["schedule_payload"] as? NSDictionary ?? nil
        self.transaction_str = dataMap["transaction_str"] as? NSDictionary ?? nil
    }
    public func setGid (_ gid: String) {
        self.gid = gid
    }
    public func setScheduleGid (_ schedule_gid: String) {
        self.schedule_gid = schedule_gid
    }
    public func setUserGid (_ user_gid: String) {
        self.user_gid = user_gid
    }
    public func setTransactionGid (_ transaction_gid: String) {
        self.transaction_gid = transaction_gid
    }
    public func setTransactionType (_ transaction_type: Int) {
        self.transaction_type = transaction_type
    }
    public func setTransactionTitle (_ transaction_title: String) {
        self.transaction_title = transaction_title
    }
    public func setType (_ type: Int) {
        self.type = type
    }
    public func setStep (_ step: Int) {
        self.step = step
    }
    public func setWeeklyDay (_ weeklyDay: Int) {
        self.weeklyDay = weeklyDay
    }
    public func setMonthlyOption (_ monthlyOption: Int) {
        self.monthlyOption = monthlyOption
    }
    public func setTypeMaxOccur (_ typeMaxOccur: Int) {
        self.typeMaxOccur = typeMaxOccur
    }
    public func setNumberEvent (_ numberEvent: Int) {
        self.numberEvent = numberEvent
    }
    public func setDateLimitOccur (_ dateLimitOccur: Int) {
        self.dateLimitOccur = dateLimitOccur
    }
    public func setActive (_ active: Int) {
        self.active = active
    }
    public func setInsertDate (_ insert_date: Int) {
        self.insert_date = insert_date
    }
    public func setLastUpdate (_ last_update: Int) {
        self.last_update = last_update
    }
    public func setLastOccurred (_ lastOccurred: Int) {
        self.lastOccurred = lastOccurred
    }
    public func toAnyObject() -> NSDictionary {
        return [
            "gid": self.gid as String,
            "schedule_gid": self.schedule_gid as String,
            "user_gid": self.user_gid as String,
            "transaction_gid": self.transaction_gid as String,
            "transaction_type": self.transaction_type as Int,
            "transaction_title": self.transaction_title as String,
            //"schedule_payload": self.schedule_payload as NSDictionary,
            "transaction_str": self.transaction_str as NSDictionary,
            "type": self.type as Int,
            "step": self.step as Int,
            "weeklyDay": self.weeklyDay as Int,
            "monthlyOption": self.monthlyOption as Int,
            "typeMaxOccur": self.typeMaxOccur as Int,
            "numberEvent": self.numberEvent as Int,
            "dateLimitOccur": self.dateLimitOccur as Int,
            "active": self.active as Int,
            "insert_date": self.insert_date as Int,
            "last_update": self.last_update as Int,
            "lastOccurred": self.lastOccurred as Int,
            "nextOccurred": self.nextOccurred as Int
        ]
    }
    
    public func getNextAlarm() -> Date {
        
        let calendar = Date(timeIntervalSince1970: Double(lastOccurred))
        var futureDate = Date(timeIntervalSince1970: Double(lastOccurred))
        
        switch type {
        case ScheduleType.DAILY:
            var dateComponent = DateComponents()
            dateComponent.year = step
            futureDate = Calendar.current.date(byAdding: dateComponent, to: calendar)!
            //calendar = calendar + (1000)
            break
        case ScheduleType.WEEKLY:
            var dateComponent = DateComponents()
            dateComponent.weekOfYear = step
            futureDate = Calendar.current.date(byAdding: dateComponent, to: calendar)!
            break
        case ScheduleType.MONTHLY:
            var dateComponent = DateComponents()
            dateComponent.month = step
            futureDate = Calendar.current.date(byAdding: dateComponent, to: calendar)!
            break
        case ScheduleType.YEARLY:
            var dateComponent = DateComponents()
            dateComponent.year = step
            futureDate = Calendar.current.date(byAdding: dateComponent, to: calendar)!
            break
        default:
            var dateComponent = DateComponents()
            dateComponent.year = step
            futureDate = Calendar.current.date(byAdding: dateComponent, to: calendar)!
            break
        }
        
        return futureDate
    }
    
    
    public func setLastOccurence(firstGoOff:Int) {
        
        self.nextOccurred = firstGoOff
        let calendar = Date(timeIntervalSince1970: Double(firstGoOff))
        var futureDate = Date(timeIntervalSince1970: Double(firstGoOff))
        
        switch type {
        case ScheduleType.DAILY:
            var dateComponent = DateComponents()
            dateComponent.year = step * (-1)
            futureDate = Calendar.current.date(byAdding: dateComponent, to: calendar)!
            //calendar = calendar + (1000)
            break
        case ScheduleType.WEEKLY:
            var dateComponent = DateComponents()
            dateComponent.weekOfYear = step * (-1)
            futureDate = Calendar.current.date(byAdding: dateComponent, to: calendar)!
            break
        case ScheduleType.MONTHLY:
            var dateComponent = DateComponents()
            dateComponent.month = step * (-1)
            futureDate = Calendar.current.date(byAdding: dateComponent, to: calendar)!
            break
        case ScheduleType.YEARLY:
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
    /*public func setNextOccur() {
        
        
        let calendar = Date()
        var futureDate = Date()
        
        switch type {
        case ScheduleType.DAILY:
            var dateComponent = DateComponents()
            dateComponent.year = step * (1)
            futureDate = Calendar.current.date(byAdding: dateComponent, to: calendar)!
            
            break
        case ScheduleType.WEEKLY:
            var dateComponent = DateComponents()
            dateComponent.weekOfYear = step * (1)
            futureDate = Calendar.current.date(byAdding: dateComponent, to: calendar)!
            break
        case ScheduleType.MONTHLY:
            var dateComponent = DateComponents()
            dateComponent.month = step * (1)
            futureDate = Calendar.current.date(byAdding: dateComponent, to: calendar)!
            break
        case ScheduleType.YEARLY:
            var dateComponent = DateComponents()
            dateComponent.year = step * (1)
            futureDate = Calendar.current.date(byAdding: dateComponent, to: calendar)!
            break
        default:
            var dateComponent = DateComponents()
            dateComponent.year = step * (1)
            futureDate = Calendar.current.date(byAdding: dateComponent, to: calendar)!
            break
        }
        
        nextOccurred = Int(futureDate.timeIntervalSince1970)
    }*/
    
    public func verboseSchedule() -> String {
        
        var verbose:String = ""
        
        switch type {
        case ScheduleType.DAILY:
            verbose = NSLocalizedString("verboseSchedule", comment: "sch verbose")
                .replacingOccurrences(of: "[number]", with: String(step))
                .replacingOccurrences(of: "[type]", with: ScheduleTypeString.DAILY)
            break
            
        case ScheduleType.WEEKLY:
            verbose = NSLocalizedString("verboseSchedule", comment: "sch verbose")
                .replacingOccurrences(of: "[number]", with: String(step))
                .replacingOccurrences(of: "[type]", with: ScheduleTypeString.WEEKLY)
            break
        case ScheduleType.MONTHLY:
            verbose = NSLocalizedString("verboseSchedule", comment: "sch verbose")
                .replacingOccurrences(of: "[number]", with: String(step))
                .replacingOccurrences(of: "[type]", with: ScheduleTypeString.MONTHLY)
            break
        case ScheduleType.YEARLY:
            verbose = NSLocalizedString("verboseSchedule", comment: "sch verbose")
                .replacingOccurrences(of: "[number]", with: String(step))
                .replacingOccurrences(of: "[type]", with: ScheduleTypeString.YEARLY)
            break
        default:
            verbose = NSLocalizedString("verboseSchedule", comment: "sch verbose")
                .replacingOccurrences(of: "[number]", with: String(step))
                .replacingOccurrences(of: "[type]", with: ScheduleTypeString.DAILY)
            break
        }
        
        if(typeMaxOccur == ScheduleCount.NUMBER_EVENT) {
            verbose = verbose + NSLocalizedString("verboseScheduleLimit", comment: "").replacingOccurrences(of: "[number]", with: String(numberEvent))
        }else {
            verbose = verbose + NSLocalizedString("verboseScheduleEver", comment: "")
        }
        
        return verbose
    }
}
