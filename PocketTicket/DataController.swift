//
//  DataController.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 16..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import Foundation
import RealmSwift

class DataController{
    
    //MARK: - Data Controller Singleton 만들기
    struct StaticInstance {
        static var instance: DataController?
    }
    
    class func sharedInstance() -> DataController {
        if !(StaticInstance.instance != nil) {
            StaticInstance.instance = DataController()
        }
        return StaticInstance.instance!
    }
    
    //MARK: - Connect Realm Controller singleton
    let realmInstacne = RealmController.sharedInstance()
    
    //MARK: - Get All Data
    func getTicketList() -> [Ticket]{
        let ticketList = realmInstacne.getTicketList
        var AllTickets = [Ticket]()
        for ticket in ticketList{
            AllTickets.append(ticket)
        }
        return AllTickets
    }
    
    //reverse
    func getTicketListReverse() -> [Ticket]{
        let ticketList = realmInstacne.getTicketListReverse
        var AllTickets = [Ticket]()
        for ticket in ticketList{
            AllTickets.append(ticket)
        }
        return AllTickets
    }
    
    func getTheaterList() -> [Theater]{
        let theaterList = realmInstacne.getTheaterList
        var AllTheaters = [Theater]()
        for theater in theaterList{
            AllTheaters.append(theater)
        }
        return AllTheaters
    }
    
    func getGenreList() -> [Genre]{
        let genreList = realmInstacne.getGenreList
        var AllGenres = [Genre]()
        for genre in genreList{
            AllGenres.append(genre)
        }
        return AllGenres
    }
    
    
    //MARK: - Get certain data
    func getTheaterById(_ id:Int) -> Theater{
        let selectedTheater = realmInstacne.getCertainTheater(id)
        return selectedTheater
    }
    
    func getAlarmById(_ id:Int) -> Alarm{
        let selectedAlarm = realmInstacne.getCertainAlarm(id)
        return selectedAlarm
    }
    
    //MARK: - return count
    func TicketCount() -> Int{
        return realmInstacne.getTicketList.count
    }
    
    //MARK: - Add Data
    //Add new data
    //Todo : alarm 추가
    func addBasicContents(name: String, seat: String?, date: NSDate, genre: String, theater: Theater?, actor: String?, alarmLabel: String?) -> Int{
        let newTicket = Ticket()
        
        newTicket.name = name
        newTicket.seat = seat
        newTicket.date = date
        newTicket.genre = genre
        newTicket.actor = actor
        newTicket.theater = theater
        newTicket.alarmLabel = alarmLabel
        realmInstacne.addTicketDataInRealm(newTicket)
        
        return newTicket.id
    }
    
    //Add Review
    func addReview(review:String, oneSentece: String, id: Int){
        realmInstacne.addReviewById(review, oneSentece, id)
    }
    
    //Add Photos
    func addPhotos(photos: [String], id: Int){
        realmInstacne.addPhotosById(photos, id)
    }
    
    
    //Add Theater
    func addTheaterData(name: String, latitude: Double, longtitude: Double, mapImage:UIImage, locationDetail: String) -> Int{
        let newTheater = Theater()
        
        newTheater.theaterName = name
        newTheater.latitude = latitude
        newTheater.longtitude = longtitude
        let mapImageToNSData = UIImagePNGRepresentation(mapImage)
        newTheater.mapImage = mapImageToNSData as NSData?
        newTheater.locationDetail = locationDetail
        
        realmInstacne.addTheaterDataInRealm(newTheater)
        
        return newTheater.id
    }
    
    //Add alarms
    func addAlarmObjectInTicket(alarms: [Alarm], id: Int){
        realmInstacne.addAlarmInTicketById(alarms, id)
    }
    
    func addAlarmData(setTime: NSDate, contentTitle: String, contentBody: String) -> Alarm{
        let newAlarm = Alarm()
        
        newAlarm.triggerTime = setTime
        newAlarm.contentTitle = contentTitle
        newAlarm.contentBody = contentBody
        
        realmInstacne.addAlarmDataInRealm(newAlarm)
        
        return newAlarm
    }
    
    //Add Genre Default Datas
    func addDefaultGenreData(){
        realmInstacne.addGenreDataInRealm()
    }
    
    //Todo : update
    //Todo : delete
    func deletePhoto(id: Int, photoName: String){
        realmInstacne.deletePhotoById(id, photoName)
        print("done")
    }
    
    //ETC
    func deleteAll(){
        realmInstacne.deleteAll()
    }

    func printData(){
        realmInstacne.printDatas()
    }
    

}















