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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ticketList = dataInstance.getTicketList()
        
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if ticketList?.count == 0 {
            return 0
        }
        return ticketList!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DidMainTableViewCell", for: indexPath) as! DidMainTableViewCell
        
        let currentTicket = ticketList?[indexPath.row]
        
        let dateFormatForPrint = DateFormatter()
        dateFormatForPrint.dateFormat = "yyyy.MM.dd  EEEE  a h:mm"
        let currentTicketDate = dateFormatForPrint.string(from: currentTicket?.date as! Date)
    
        cell.dateLabel.text = currentTicketDate
        cell.titleLable.text = currentTicket?.name
        if let oneSentece = currentTicket?.oneSenetence{
            cell.oneSentenceLabel.text = oneSentece
            cell.oneSentenceLabel.textColor = UIColor.black
        } else{
            cell.oneSentenceLabel.text = "Please add 'one sentece' later"
            cell.oneSentenceLabel.textColor = UIColor.lightGray
        }

        return cell
    }

    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "EachTicketsCollectionViewController") as! EachTicketsCollectionViewController

        let currentTicket = ticketList?[indexPath.row]
        
        detailController.showTicket = currentTicket
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }


}
