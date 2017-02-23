//
//  DidMainTableViewController.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 15..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit

class DidMainTableViewController: UITableViewController {

    //Data Controller Singelton
    let dataInstance = DataController.sharedInstance()
    var ticketList : [Ticket]? = nil
    
    //temp
    let notficationManager = NotificationManager()
    let dateFormatForPrint = DateFormatter()

    @IBOutlet var ticketTableView: UITableView!
    
    let today = Date()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        notficationManager.showList()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ticketList = dataInstance.getTicketListReverse()
        
        self.tabBarController?.tabBar.isHidden = false
        tableView.reloadData()
        
        let scrollIdx = findTodayIndex(today)
        if scrollIdx != 0{
            let indexPath = IndexPath(row: scrollIdx, section: 0)
            ticketTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            print(scrollIdx)
        }

        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if ticketList?.count == 0 {
            print("no ticket")
            return 0
        }
        return ticketList!.count
    }
    
    func findTodayIndex(_ today: Date) -> Int{
//        dateFormatForPrint.dateFormat = "yyyy.MM.dd"
//        let todayString = dateFormatForPrint.string(from: today)
        var count = 0
        if let ticketList = ticketList{
            for ticket in ticketList{
//              let dateString = dateFormatForPrint.string(from: ticket.date as Date)
                let ticketDate = ticket.date as Date
                //            print("today : \(today)")
                //            print("ticketDate : \(ticketDate)")
                //            print(today>ticketDate)
                //아직 안본 공연 카운트
                if today < ticketDate{
                    count += 1
                } else{
                    break
                }
            }
            if count < ticketList.count{
                return count
            }
        }
        return 0
    }


    @IBAction func scrollToToday(_ sender: Any) {
        let scrollIdx = findTodayIndex(today)
        if scrollIdx != 0{
            let indexPath = IndexPath(row: scrollIdx, section: 0)
            ticketTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            print(scrollIdx)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DidMainTableViewCell", for: indexPath) as! DidMainTableViewCell
        
        let currentTicket = ticketList?[indexPath.row]
        
        dateFormatForPrint.dateFormat = "yyyy.MM.dd EE ah:mm"
        let currentTicketDate = currentTicket?.date as! Date
        let currentTicketDateString =   dateFormatForPrint.string(from: currentTicket?.date as! Date)
        
        //compare date -> after / before
        let currentTime = Date()
        
        if currentTicketDate < currentTime {
            cell.checkImage.image = UIImage(named: "after")
        } else{
            cell.checkImage.image = UIImage(named: "before")
        }
    
        cell.dateLabel.text = currentTicketDateString
        cell.titleLable.text = currentTicket?.name
        if let oneSentece = currentTicket?.oneSentence{
            cell.oneSentenceLabel.text = oneSentece
            cell.oneSentenceLabel.textColor = UIColor.black
        } else{
            cell.oneSentenceLabel.text = "한줄평을 입력해주세요"
            cell.oneSentenceLabel.textColor = UIColor.lightGray
        }

        return cell
    }

    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "TicketDetailViewController") as! TicketDetailViewController

        let currentTicket = ticketList?[indexPath.row]
        
        detailController.showTicket = currentTicket
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }


}
