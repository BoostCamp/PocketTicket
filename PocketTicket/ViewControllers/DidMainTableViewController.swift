//
//  DidMainTableViewController.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 15..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit

class DidMainTableViewController: UITableViewController {

    //MARK: - Properties
    //Data Controller Singelton
    let dataInstance = DataController.sharedInstance()
    var ticketList : [Ticket]? = nil
    
    //for divide table section
    var lastTicket = [Ticket]()
    var todayTicket = [Ticket]()
    var upcomingTicket = [Ticket]()
    let sectionNameArray = ["Last", "Today", "Upcoming"]
    var sectionTicketArray = [[Ticket]]()
    
    //temp
    @IBOutlet var ticketTableView: UITableView!
    let dateFormat = DateFormatter()
    let today = Date()
    var calTabBarFlag = false
    
    
    //MARK: - App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        self.dateFormat.dateFormat = "yyyy.MM.dd EE ah:mm"

        self.ticketList = self.dataInstance.getTicketList()

        //From calendar tab bar -> divide ticket, scroll to today
        if self.calTabBarFlag {
            self.divideTicket(ticketList!)
            let indexPath = IndexPath(row: 0, section: 1)
            self.ticketTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            self.calTabBarFlag = false
        }
        
     
    }
    
    
    //MARK: - Scroll to today's tickets
    @IBAction func scrollToToday(_ sender: Any) {
        let indexPath = IndexPath(row: 0, section: 1)
        self.ticketTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
    
    //MARK: - Divide ticket by date
    func divideTicket(_ ticketList : [Ticket]){
        self.sectionTicketArray.removeAll()
        self.lastTicket.removeAll()
        self.todayTicket.removeAll()
        self.upcomingTicket.removeAll()

        self.dateFormat.dateFormat = "yyyy.MM.dd"
        let todayString = dateFormat.string(from: today)
        for ticket in ticketList{
            let ticketDateString = self.dateFormat.string(from: ticket.date as Date)
            //last ticekt
            if ticketDateString < todayString{
                self.lastTicket.append(ticket)
            } else if ticketDateString == todayString{ //today ticket
                self.todayTicket.append(ticket)
            } else{ //upcoming ticket
                self.upcomingTicket.append(ticket)
            }
        }
        self.sectionTicketArray.append(lastTicket)
        self.sectionTicketArray.append(todayTicket)
        self.sectionTicketArray.append(upcomingTicket)
        
        self.tableView.reloadData()
        print("reDivide")

    }
    

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionNameArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTickets = self.sectionTicketArray[section]
        
        if sectionTickets.count > 0{
            return sectionTickets.count
        } else{
            return 1
        }

    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionName = self.sectionNameArray[section]
        return sectionName
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DidMainTableViewCell", for: indexPath) as! DidMainTableViewCell
        let currentTicketList = self.sectionTicketArray[indexPath.section]
        
        //ticket list가 있는 경우
        if currentTicketList.count > 0{
            cell.containView.isHidden = false
            cell.notLabel.isHidden = true
            
            let currentTicket = currentTicketList[indexPath.row]
        
            let currentTicketDate = currentTicket.date as Date
            //compare date -> after / before
            if currentTicketDate < today {
                cell.checkImage.image = UIImage(named: "after")
            } else{
                cell.checkImage.image = UIImage(named: "before")
            }
    
            let currentTicketDateString = self.dateFormat.string(from: currentTicket.date as Date)
            cell.dateLabel.text = currentTicketDateString
            
            cell.titleLable.text = currentTicket.name
            
            if let oneSentece = currentTicket.oneSentence{
                cell.oneSentenceLabel.text = oneSentece
                cell.oneSentenceLabel.textColor = UIColor.black
            } else{
                cell.oneSentenceLabel.text = "한줄평을 입력해주세요"
                cell.oneSentenceLabel.textColor = UIColor.lightGray
            }
            
        } else{
            cell.containView.isHidden = true
            cell.notLabel.isHidden = false


            switch(indexPath.section){
            case 0:
                cell.notLabel.text = "지난 공연이 없습니다"
            case 1:
                cell.notLabel.text = "오늘 예정된 공연이 없습니다"
            case 2:
                cell.notLabel.text = "새로운 공연을 등록해 주세요"
            default: break
            }
        }

        return cell
    }

    //MARK: - Table View Delegate
    //Move to ticket detail 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "TicketDetailViewController") as! TicketDetailViewController
        
        let currentTicketList = self.sectionTicketArray[indexPath.section]
        let currentTicket = currentTicketList[indexPath.row]
        
        detailController.showTicket = currentTicket
        
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }


}


