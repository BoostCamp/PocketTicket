//
//  Genre.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 7..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import RealmSwift

class Genre : Object{
    dynamic var id = 0
    dynamic var genreName = ""
    let tickets = List<Ticket>()
    
    override class func primaryKey() -> String?{
        return "id"
    }
}
