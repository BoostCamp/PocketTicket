//
//  CalMainViewController.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 9..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit
import FSCalendar
import RealmSwift

class CalMainViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    //MARK: - Properties
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var ticketTableView: UITableView!
    
    //Data Controller Singleton
    let dataInstacne = DataController.sharedInstance()
    var ticketList : [Ticket]? = nil

    //Properties for date
    var currentMonthTicket = [Ticket]()
    var selectedDate = Date()
    let dateFormatForMonth = DateFormatter()
    let dateFormatForDate = DateFormatter()
    let dateFormatForPrint = DateFormatter()

    
    //MARK: - App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //FSCalendar
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        
        //Data Control
        self.dataInstacne.addDefaultGenreData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //remove calendar line
        self.calendarView.clipsToBounds = true
        //header date format
        self.calendarView.appearance.headerDateFormat = "yyyy.MM"
        
        //set dateformat
        self.dateFormatForMonth.dateFormat = "yyyy.MM"
        self.dateFormatForDate.dateFormat = "yyyy.MM.dd"
        self.dateFormatForPrint.dateFormat = "yyyy.MM.dd ah:mm"
        
        
        //Reload whole ticket list
        self.ticketList?.removeAll()
        self.ticketList = dataInstacne.getTicketList()
        
        //Reload month ticket list
        self.currentMonthTicket.removeAll()
        self.getCurrentMonthTicket(calendarView)
        self.ticketTableView.reloadData()
        self.calendarView.reloadData()
        
        
        self.tabBarController?.tabBar.isHidden = false
        
        //Scroll to today's event
        //today's date
        let today = Date()
        let scrollIndex = self.compareDate(today)
        if scrollIndex != 0{
            let indexPath = IndexPath(row: scrollIndex, section: 0)
            self.ticketTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
        
        //Change Ticket tab bar flag
        let ticketTabBarNavController = self.tabBarController?.viewControllers?[1] as! UINavigationController
        let ticketTabBar = ticketTabBarNavController.viewControllers.first as! DidMainTableViewController
        ticketTabBar.calTabBarFlag = true
    
    }
    
    //MARK: - Calendar Control
    
    //move to next month
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {}
    
    //Reload table view for selected month
    public func calendarCurrentPageDidChange(_ calendar: FSCalendar){
        self.currentMonthTicket.removeAll()
        self.getCurrentMonthTicket(calendar)
        self.ticketTableView.reloadData()
        self.calendarView.reloadData()
    }
    
    //Get current month ticket list from whole ticket list
    func getCurrentMonthTicket(_ calendar: FSCalendar){

        //Current page month
        let currentMonth = calendar.currentPage
        let currentMonthString = self.dateFormatForMonth.string(from: currentMonth)
        //Compare whole ticket month to current page month
        for ticket in self.ticketList!{
            let ticketDate = ticket["date"] as! Date
            let ticketMonthString = self.dateFormatForMonth.string(from: ticketDate)
            if currentMonthString == ticketMonthString{
                self.currentMonthTicket.append(ticket)
            }
        }
    }
    
    //Mark to event day
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let currentDate = self.dateFormatForDate.string(from: date)
        for ticket in self.currentMonthTicket {
            let ticketDate = self.dateFormatForDate.string(from: ticket.date as Date)
            if currentDate == ticketDate{
                return 1
            }
        }
        return 0
    }
    
    //Event for selected date -> move scorll
    func calendar(_ calendar: FSCalendar, didSelect date: Date){
        if self.currentMonthTicket.count > 0{
            //find scroll index
            let indexRow = self.compareDate(date)
            //move scroll
            let indexPath = IndexPath(row: indexRow, section: 0)
            self.ticketTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
        self.selectedDate = date
        self.ticketTableView.reloadData()
    }
    
    //Find scroll index
    func compareDate(_ selectedDate: Date) -> Int{
        let selectedDateString = self.dateFormatForDate.string(from: selectedDate)
        var count = 0
        for ticket in self.currentMonthTicket{
            let dateString = self.dateFormatForDate.string(from: ticket.date as Date)
            if selectedDateString == dateString{
                return count
            } else{
                count += 1
            }
        }
        return 0
    }
    
    //MARK: - Move to add View
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToCalAddSegue"{
            let navController = segue.destination as? UINavigationController
            let controller = navController?.viewControllers.first as! CalAddViewController
            controller.currentDate = self.selectedDate
        }
    }
    
}


//MARK: - Table View Control
extension CalMainViewController : UITableViewDelegate, UITableViewDataSource{
   
    //MARK: Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentMonthTicket.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalMainTableViewCell", for: indexPath) as! CalMainTableViewCell
        let currentTicket = self.currentMonthTicket[indexPath.row]
        
        let currentTicketDate = self.dateFormatForPrint.string(from: currentTicket.date as Date)
        
        cell.titleLabel.text = currentTicket.name
        cell.dateLabel.text = currentTicketDate
        
        //Change layer border color if same date
        let selectedDateString = self.dateFormatForDate.string(from: selectedDate)
        let currentDateString = self.dateFormatForDate.string(from: currentTicket.date as Date)
        if selectedDateString == currentDateString {
            cell.cellView.layer.borderColor = UIColor(red: 235/255, green: 72/255, blue: 79/255, alpha: 1.0).cgColor
        }
        else {
            cell.cellView.layer.borderColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.00).cgColor
        }
       
        return cell
    }
    
    //MARK: Table View Delegate
    //show ticket detail in cal add view 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "CalAddViewController") as! CalAddViewController
        
        let currentTicket = self.currentMonthTicket[indexPath.row]
        
        detailController.showTicket = currentTicket
        detailController.showFlag = true
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }

    
    
}
