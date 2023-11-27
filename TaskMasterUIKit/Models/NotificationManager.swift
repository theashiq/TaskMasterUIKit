//
//  NotificationManager.swift
//  TaskMasterUIKit
//
//  Created by mac 2019 on 11/23/23.
//

import Foundation
import UserNotifications

class NotificationManager{
    
    private(set) static var authorized: Bool?
    
    static func isAuthorized(callback: ((Bool)->Void)?){
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus{
            case .denied:
                authorized = false
                callback?(false)
            case .notDetermined:
                authorized = false
                callback?(false)
            default:
                authorized = true
                callback?(true)
            }
        }
    }
    
    static func requestAuthorization(callback: ((Bool)->Void)?){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard error != nil else {
                authorized = false
                callback?(false)
                return
            }
            authorized = granted
            callback?(granted)
        }
    }
    
    static func setNotification(id: String, title: String, body: String, time: Date){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        var triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: time)
        triggerDateComponents.second = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if error != nil {
                print("failed to set notification for \(id)")
            }
        }
    }
    
    static func cancelNotification(id: String){
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id])
    }
}
