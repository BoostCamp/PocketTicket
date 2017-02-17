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
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var ticketTableView: UITableView!
    
    //Data Controller Singleton
    let dataInstacne = DataController.sharedInstance()
    var ticketList : [Ticket]? = nil
    
    var currentMonthTicket = [Ticket]()
    
    //MARK: - App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.delegate = self
        calendarView.dataSource = self
        
        //Data Control
        dataInstacne.addDefaultGenreData()
        print("Print All Data")
        dataInstacne.printData()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //달력 구분 선 제거
        calendarView.clipsToBounds = true
        //header date format
        calendarView.appearance.headerDateFormat = "yyyy.MM"
        
        
        //티켓이 추가될 경우 배열에서 삭제하고 다시 불러오기
        ticketList?.removeAll()
        ticketList = dataInstacne.getTicketList()
        
        currentMonthTicket.removeAll()
        getCurrentMonthTicket(calendarView)
        ticketTableView.reloadData()
        calendarView.reloadData()
        
        self.tabBarController?.tabBar.isHidden = false

    }
    
    //MARK: - Calendar Control
    //다음 달로 넘어가기
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
      
    }
    
    //달 이동할 때 해당하는 달에 대한 table view
    public func calendarCurrentPageDidChange(_ calendar: FSCalendar){
        currentMonthTicket.removeAll()
        getCurrentMonthTicket(calendar)
        ticketTableView.reloadData()
        calendarView.reloadData()
    }
    
    //해당하는 달의 이벤트 뽑아내는 함수
    func getCurrentMonthTicket(_ calendar: FSCalendar){
        //date format
        let dateFormatForCompare = DateFormatter()
        dateFormatForCompare.dateFormat = "yyyy.MM"
        //현재 달력의 날짜
        let currentMonth = dateFormatForCompare.string(from: calendar.currentPage)
        //ticket에 있는 날짜와 현재 날짜 비교
        for ticket in ticketList!{
            let ticketDate = ticket["date"] as! Date
            let ticketMonth = dateFormatForCompare.string(from: ticketDate)
            print("ticketMonth: \(ticketMonth)")
            print("currentMonth: \(currentMonth)")
            if currentMonth == ticketMonth{
                currentMonthTicket.append(ticket)
            }
        }

    }
    
    // 각 날짜에 특정 문자열을 표시할 수 있습니다. 이미지를 표시하는 메소드도 있으니 API를 참조하세요.
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateFormatForCompare = DateFormatter()
        dateFormatForCompare.dateFormat = "yyyy.MM.dd"
        let currentDate = dateFormatForCompare.string(from: date)
        for ticket in currentMonthTicket {
            let ticketDate = dateFormatForCompare.string(from: ticket.date as Date)
            if currentDate == ticketDate{
                print("ticketDate : \(ticketDate)")
                print("currentDate : \(currentDate)")
                return 1
            }
        }
        return 0
    }
    
    // 특정 날짜를 선택했을 때, 발생하는 이벤트는 이 곳에서 처리할 수 있겠네요.
    func calendar(_ calendar: FSCalendar, didSelect date: Date){
        let selectedDate = date
        
        let CalAddController = self.storyboard?.instantiateViewController(withIdentifier: "CalAddViewController") as! CalAddViewController
        
        CalAddController.currentDate = selectedDate
        
        //Connect memeVC with navigation view controller as rootView so that navigation bar can be seen
        let navController = UINavigationController(rootViewController: CalAddController)
        self.present(navController, animated: true, completion: nil)
        
    }
    
    //move to add View
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToCalAddSegue"{
            let navController = segue.destination as? UINavigationController
            let controller = navController?.viewControllers.first as! CalAddViewController
            controller.currentDate = calendarView.currentPage
        }
    }
    

    
}


//MARK: - Table View Control
extension CalMainViewController : UITableViewDelegate, UITableViewDataSource{
   
    //MARK: Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentMonthTicket.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalMainTableViewCell", for: indexPath) as! CalMainTableViewCell
        let currentTicket = currentMonthTicket[indexPath.row]
        
        let dateFormatForPrint = DateFormatter()
        dateFormatForPrint.dateFormat = "yyyy.MM.dd  EEEE  a h:mm"
        let currentTicketDate = dateFormatForPrint.string(from: currentTicket.date as Date)

        
        cell.titleLabel.text = currentTicket.name
        cell.dateLabel.text = currentTicketDate
        
       
        return cell
    }
    
    //MARK: Table View Delegate
    //show ticket detail in cal add view 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "CalAddViewController") as! CalAddViewController
        
        let currentTicket = currentMonthTicket[indexPath.row]
        
        detailController.showTicket = currentTicket
        detailController.showFlag = true
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }

    
    
}
