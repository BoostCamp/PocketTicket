//
//  NotificationManager.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 21..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationManager : NSObject{
   
    var title = ""
    var body = "" 
    func setNotification(){
        //Contents : UNNOtificationContent
        let content = UNMutableNotificationContent()
        content.title = self.title
        content.body = self.body
        content.sound = UNNotificationSound.default()
        
        //Trigger : UNNotificationTrigger
        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        // Swift
//        var dateComponents = DateComponents()
//        dateComponents.hour = 18
//        dateComponents.minute = 5
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
//        let date = Date(timeIntervalSinceNow: 10)
//        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
//        let timeTrigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,
//                                                    repeats: false)
        
        //add request
        let request = UNNotificationRequest(identifier: "LocalNotification", content: content, trigger: timeTrigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                // Do something with error
                print("alarm request fail : \(error)")
            } else {
                print("alarm request success")
                // Request was added successfully
            }
        }
    }
    
    func showList(){
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(request)
            }
        })
    }

    
}
