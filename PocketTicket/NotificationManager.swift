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

    func setNotification(identifier: String, title: String, body: String, setTime:NSDate){
        //Contents : UNNOtificationContent
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default()

        /*
        Trigger : UNNotificationTrigger
        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
         Swift
        var dateComponents = DateComponents()
        dateComponents.hour = 18
        dateComponents.minute = 5
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let date = Date(timeIntervalSinceNow: 10)
         */
        
        //time trriger
        var triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: setTime as Date)
        triggerDate.second = 0
        let timeTrigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,
                                                    repeats: false)
        
        //add request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: timeTrigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                // Do something with error
                print("alarm request fail : \(error)")
            } else {
                print("alarm request success : \(identifier)")
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
