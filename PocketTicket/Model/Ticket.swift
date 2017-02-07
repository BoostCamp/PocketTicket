//
//  Ticket.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 7..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import RealmSwift

class Ticket : Object{
    
    dynamic var id = 0
    dynamic var name = ""
    dynamic var genre : Genre?
    dynamic var date = NSDate()
    let alarms = List<alarmDate>()
    dynamic var seat: String? = nil
    dynamic var theater : Theater?
    dynamic var review : String? = nil
    let value = RealmOptional<Int>()
    let photos = List<photo>()
    
    override class func primaryKey() -> String?{
        return "id"
    }
}

class alarmDate : Object{
    dynamic var date: NSDate? = nil
}

class photo : Object{
    dynamic var photoPath : String? = nil
}
