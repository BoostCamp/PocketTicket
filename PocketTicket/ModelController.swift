//
//  ModelController.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 9..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import Foundation
import RealmSwift

class ModelController {
    struct StaticInstance {
        static var instance: ModelController?
    }
    
    class func sharedInstance() -> ModelController {
        if !(StaticInstance.instance != nil) {
            StaticInstance.instance = ModelController()
        }
        return StaticInstance.instance!
    }
    
    
    // MARK: - data model
    let realm = try! Realm()
    
    var ticketList : Results<Ticket>{
        get{
            return realm.objects(Ticket.self)
        }
    }
    
    var genreList : Results<Genre>{
        get{
            return realm.objects(Genre.self)
        }
    }
    
    var theaterList : Results<Theater>{
        get{
            return realm.objects(Theater.self)
        }
    }
    
   

    
    var dummyData = [["id" : 0, "name" : "Story of My Life", "genre" : "뮤지컬", "date":"2017.02.03", "time" : "08:00", "seat" : "1층 B블록 3열 4번", "theater": "백암아트홀","revie" : "오늘 스토리오브마이라이프를 보았다.", "star" : 4, "photos" : ["story1", "story2", "story3"]],["id" : 1, "name" : "엘리자벳", "genre" : "뮤지컬", "date":"2017.02.10", "time" : "08:00", "seat" : "2층 3열 4번", "theater": "예술의전당", "revie" : "오늘 예술의전당에서 엘리자벳을 보았다.", "star" : 3, "photos" : ["story2", "story3", "story4"]]]
    
    // MARK: - add default datas
    func addGenreData(){
        if genreList.count == 0{
            let genres = [Genre(value: ["id" : 0, "genreName": "뮤지컬"]),
                          Genre(value: ["id" : 1, "genreName": "연극"]),
                          Genre(value: ["id" : 2, "genreName": "콘서트"]),
                          Genre(value: ["id" : 3, "genreName": "클래식"]),
                          Genre(value: ["id" : 4, "genreName": "발레"]),
                          Genre(value: ["id" : 5, "genreName": "기타"])]

            for genre in genres{
                try! realm.write{
                    realm.add(genre)
                }
            }
        }
    }
    
    
    func addTheaterData(){
        if theaterList.count == 0{
            let theaters = [Theater(value: ["id" : 0, "theaterName": "예술의전당"]),
                            Theater(value: ["id" : 1, "theaterName": "세종문화회관"]),
                            Theater(value: ["id" : 2, "theaterName": "샤롯데씨어터"]),
                            Theater(value: ["id" : 3, "theaterName": "블루스퀘어"]),
                            Theater(value: ["id" : 4, "theaterName": "올림픽경기장"]),
                            Theater(value: ["id" : 5, "theaterName": "기타"])]
            for theater in theaters{
                try! realm.write{
                    realm.add(theater)
                }
            }
        }
        
    }
    
    func deleteData(){
        let target = realm.objects(Theater.self)
        try! realm.write{
            realm.delete(target)
        }
    }
    
    //MARK: - load all data
    func loadGenreNameList() -> [String]{
        var genreNameList = [String]()
        for genre in genreList{
            genreNameList.append(genre.genreName)
        }
        return genreNameList
    }
    
    func printDatas(){
        print("genreList")
        print(genreList)
        print("theaterList")
        print(theaterList)
    }

    
}
