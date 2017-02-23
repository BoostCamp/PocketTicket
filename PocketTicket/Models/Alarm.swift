//
//  Alarm.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 23..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import RealmSwift

class Alarm : Object{
    dynamic var id = 0
    dynamic var identifer : String? = nil
    dynamic var triggerTime = NSDate()
    dynamic var contentTitle = ""
    dynamic var contentBody = ""
    
    override class func primaryKey() -> String?{
        return "id"
    }

}
