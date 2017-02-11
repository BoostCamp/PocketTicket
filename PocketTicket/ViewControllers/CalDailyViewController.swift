//
//  CalDailyViewController.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 7..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit

class CalDailyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var currentDate : Date?
    var stringOfDateForTitle : String?
    
    let modelInstance = ModelController.sharedInstance()
    var dummyData : [[String:Any]]!
    var currentData = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.navigationController?.isNavigationBarHidden = false
        automaticallyAdjustsScrollViewInsets = false
        
        //navigation title 만들기 
        let dateFormateForTitle = DateFormatter()
        dateFormateForTitle.dateFormat = "yyyy.MM.dd"
        if let currentDate = currentDate{
            stringOfDateForTitle = dateFormateForTitle.string(from: currentDate)
        }
        self.title = stringOfDateForTitle
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.dummyData = modelInstance.dummyData
        checkCurrentData(dummyData!)
    }
    
    //불러온 데이터에서 현재 날짜와 같을 경우 새로운 배열에 넣어줌
    func checkCurrentData(_ wholeData:[[String:Any]]){
        for data in wholeData{
            let dateInDB : String = data["date"] as! String
            if dateInDB == stringOfDateForTitle {
                currentData.append(data)
                print("same")
            }
        }
        print(currentData.count)

    }
    
    
    // MARK: - Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalDailyCell")!
        let selectedData = currentData[indexPath.row]
        cell.textLabel?.text = selectedData["time"] as! String?
        cell.detailTextLabel?.text = selectedData["name"] as! String?

        
        
        return cell
    }
    
    //MARK: - prepare segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCalAddSegue" {
            let DestViewController = segue.destination as! UINavigationController
            let targetController = DestViewController.topViewController as! CalAddViewController
            targetController.currentDate = self.currentDate
        }
    }
    

        

 
    

   
}
