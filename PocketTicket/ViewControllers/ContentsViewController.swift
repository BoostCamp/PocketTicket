//
//  ContentsViewController.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 20..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit

class ContentsViewController: UIViewController {

    var currentTicket : Ticket?

    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var theaterLabel: UILabel!
    
    @IBOutlet weak var seatLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentTicket != nil{
            setData()
        } else {
        }
    }
    
    func setData(){
        //Genre
        self.genreLabel.text = currentTicket?.genre
        
        //Date
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy.MM.dd EE ah:mm"
        let selectedDate = currentTicket?.date
        let dateString = dateFormat.string(from: selectedDate as! Date)
        self.dateLabel.text = dateString
        
        //theater 
        self.theaterLabel.text = currentTicket?.theater?.theaterName
        
        //Seat
        self.seatLabel.text = currentTicket?.seat
        
        //actor
        self.actorLabel.text = currentTicket?.actor
        

    }

  
}
