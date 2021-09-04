//
//  InviteNotify.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 1/8/21.
//  Copyright © 2021 Armel Koudoum. All rights reserved.
//

import Foundation
import UserNotifications

class InviteNotify {
    public static func teamInviteAccepted(teamName: String) {
        
        let notifCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "iSaveMoneyGo: Added to group"
        content.body = "You are now path of the team \(teamName)!"
        
        let date = Date().addingTimeInterval(15)
        let dateComponent = Calendar.current.dateComponents([.month, .year, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        notifCenter.add(request, withCompletionHandler: { error in
            
        })
    }
}
