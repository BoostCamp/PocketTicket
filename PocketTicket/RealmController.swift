//
//  RealmController.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 9..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import Foundation
import RealmSwift


//Realm Model Controller
class RealmController {
    
    //MARK: - Realm Model Singleton 만들기
    struct StaticInstance {
        static var instance: RealmController?
    }
    
    class func sharedInstance() -> RealmController {
        if !(StaticInstance.instance != nil) {
            StaticInstance.instance = RealmController()
        }
        return StaticInstance.instance!
    }
    
    
    // MARK: - getter, setter from Realm
    // MARK: get data list
    let realm = try! Realm()
    
    //date 정렬
    var getTicketList : Results<Ticket>{
        get{
            return realm.objects(Ticket.self).sorted(byKeyPath: "date", ascending: true)
        }
    }
    //역순 정렬
    var getTicketListReverse : Results<Ticket>{
        get{
            return realm.objects(Ticket.self).sorted(byKeyPath: "date", ascending: false)
        }
    }
    
    var getGenreList : Results<Genre>{
        get{
            return realm.objects(Genre.self)
        }
    }
    
    var getTheaterList : Results<Theater>{
        get{
            return realm.objects(Theater.self)
        }
    }
    
    var getAlarmist : Results<Alarm>{
        get{
            return realm.objects(Alarm.self)
        }
    }
    
    // MARK: get certain data
    func getCertainTheater(_ id: Int) -> Theater{
        let selectTheater = realm.objects(Theater.self).filter("id == \(id)").first
        return selectTheater!
    }
    
    func getCertainAlarm(_ id: Int) -> Alarm{
        let selectAlarm = realm.objects(Alarm.self).filter("id == \(id)").first
        return selectAlarm!
    }
    
    
    // MARK: add function
    func addTicketDataInRealm(_ ticket : Ticket){
        //primary key 하나씩 증가시키기
        var myValue = realm.objects(Ticket.self).map{$0.id}.max() ?? 0
        myValue = myValue + 1
        ticket.id = myValue
        try! realm.write{
            realm.add(ticket)
        }
    }
    
    func addTheaterDataInRealm(_ theater: Theater){
        var myValue = realm.objects(Theater.self).map{$0.id}.max() ?? 0
        myValue = myValue + 1
        theater.id = myValue
        try! realm.write{
            realm.add(theater)
        }
    }
    
    func addAlarmDataInRealm(_ alarm: Alarm){
        var myValue = realm.objects(Alarm.self).map{$0.id}.max() ?? 0
        myValue = myValue + 1
        alarm.id = myValue
        try! realm.write{
            realm.add(alarm)
        }
    }
    
//    func addTheaterData(name: String, latitude: Double, longtitude: Double, mapImage:UIImage){
//        let theater = Theater()
//        let newRealm = try! Realm()
//        var myValue = newRealm.objects(Theater.self).map{$0.id}.max() ?? 0
//        myValue = myValue + 1
//        theater.id = myValue
//        theater.theaterName = name
//        theater.latitude = latitude
//        theater.longtitude = longtitude
//        let mapImageToNSData = UIImagePNGRepresentation(mapImage)
//        theater.mapImage = mapImageToNSData as NSData?
//        
//        try! newRealm.write{
//            newRealm.add(theater)
//        }
//    }
    
    
    
    //MARK: delete function
    //연쇄적 삭제
    func deleteTicketById(_ id: Int){
        let newRealm = try! Realm()
//        let aa = realm.object(ofType: Ticket.self, forPrimaryKey: id)
        let selectTicket = newRealm.objects(Ticket.self).filter("id == \(id)").first
        try! newRealm.write{
            newRealm.delete((selectTicket?.theater)!)
            newRealm.delete(selectTicket!)
        }
    }
        
    //MARK: update function
    func addReviewById(_ review: String, _ oneSentence: String, _ id: Int){
        try! realm.write{
            realm.create(Ticket.self, value: ["id": id, "review": review, "oneSentence": oneSentence], update: true)
        }
    }
    
    func addPhotosById(_ photos: [String], _ id: Int){
        print(id)
        print(photos.count)
        for image in photos{
            print(image)
        }
        let selectTicket = Ticket(value: getObjectById(id))
        print(selectTicket.id)
        for eachPhoto in photos {
            let photoObject = photo()
            photoObject.photoPath = eachPhoto
            selectTicket.photos.append(photoObject)
        }
        try! realm.write{
            realm.create(Ticket.self, value: ["id": id, "photos": selectTicket.photos], update: true)
        }
    }
    
    func getObjectById(_ id: Int) -> Object{
        return realm.object(ofType: Ticket.self, forPrimaryKey: id)!
    }
    
    //get function
    func loadGenreNameList() -> [String]{
        var genreNameList = [String]()
        for genre in getGenreList{
            genreNameList.append(genre.genreName)
        }
        return genreNameList
    }
    
    
    //delete functions
    func deleteData(){
        let target = realm.objects(Genre.self)
        try! realm.write{
            realm.delete(target)
        }
    }
    
    func deleteAll(){
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    //MARK: - load all data
    
    func printDatas(){
        print("genreList")
        print(getGenreList)
        print("theaterList")
        print(getTheaterList)
        print("ticketList")
        print(getTicketList)
    }
    
    
    // MARK: - add default datas
    func addGenreDataInRealm(){
        print(getGenreList.count)

        if getGenreList.count == 0{
            let genres = [Genre(value: ["id" : 0, "genreName": "뮤지컬"]),
                          Genre(value: ["id" : 1, "genreName": "연극"]),
                          Genre(value: ["id" : 2, "genreName": "콘서트"]),
                          Genre(value: ["id" : 3, "genreName": "클래식"]),
                          Genre(value: ["id" : 4, "genreName": "발레"]),
                          Genre(value: ["id" : 5, "genreName": "영화"]),
                          Genre(value: ["id" : 6, "genreName": "기타"])]


            for genre in genres{
                try! realm.write{
                    realm.add(genre)
                }
            }
        }
    }
    
        
}

