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
    
    //MARK: - return count
    func TicketCount() -> Int{
        return realmInstacne.getTicketList.count
    }
    
    //MARK: - Add Data
    //Add new data
    //Todo : alarm 추가
    func addBasicContents(name: String, seat: String, date: NSDate, genre: String, theater: Theater){
        let newTicket = Ticket()
        
        newTicket.name = name
        newTicket.seat = seat
        newTicket.date = date
        newTicket.genre = genre
        newTicket.theater = theater
        realmInstacne.addTicketDataInRealm(newTicket)
    }
    
    //Add Review
    func addReview(review:String, oneSentece: String, id: Int){
//        let newTicket = Ticket()
//    
//        newTicket.review = review
//        newTicket.oneSenetence = oneSentece
        
        realmInstacne.updateTicketById(review, oneSentece, id)
    }
    
    //Add Photos
    
    
    //Add Theater
    func addTheaterData(name: String, latitude: Double, longtitude: Double, mapImage:UIImage) -> Int{
        let newTheater = Theater()
        
        newTheater.theaterName = name
        newTheater.latitude = latitude
        newTheater.longtitude = longtitude
        let mapImageToNSData = UIImagePNGRepresentation(mapImage)
        newTheater.mapImage = mapImageToNSData as NSData?
        
        realmInstacne.addTheaterDataInRealm(newTheater)
        
        return newTheater.id
    }
    
    //Add Genre Default Datas
    func addDefaultGenreData(){
        realmInstacne.addGenreDataInRealm()
    }
    
    //Todo : update
    //Todo : delete
    
    //ETC
    func deleteAll(){
        realmInstacne.deleteAll()
    }

    func printData(){
        realmInstacne.printDatas()
    }
    

}















