//
//  Ticket.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 9..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import RealmSwift

class Ticket : Object{
    
    dynamic var id = 0
    dynamic var name = ""
    dynamic var genre = ""
    dynamic var date = NSDate()
    dynamic var alarmLabel : String? = nil
    dynamic var seat: String? = nil
    dynamic var actor: String? = nil 
    dynamic var theater : Theater?
    dynamic var review : String? = nil
    dynamic var oneSentence : String? = nil
    dynamic var mainImage : String? = nil
    let photos = List<photo>()
    let alarms = List<Alarm>()
    
    
    override class func primaryKey() -> String?{
        return "id"
    }
}


class photo : Object{
    dynamic var photoPath : String? = nil
}
