//
//  Theater.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 9..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import RealmSwift

class Theater : Object{
    dynamic var id = 0
    dynamic var theaterName = ""
    dynamic var longtitude = 0.0
    dynamic var latitude = 0.0
    dynamic var mapImage : NSData? = nil
    dynamic var locationDetail : String?  = nil
    
    override class func primaryKey() -> String?{
        return "id"
    }

    
}
