//
//  ContentsViewController.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 20..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit

class ContentsViewController: UIViewController {


    //MARK: - Properties
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var theaterLabel: UILabel!
    
    @IBOutlet weak var seatLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!
    
    var currentTicket : Ticket?
    
    //MARK: - App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.currentTicket != nil{
            self.setData()
        }
    }
    
    //MARK: - Set data
    func setData(){
        //Genre
        self.genreLabel.text = self.currentTicket?.genre
        
        //Date
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy.MM.dd EE ah:mm"
        let selectedDate = self.currentTicket?.date
        let dateString = dateFormat.string(from: selectedDate as! Date)
        self.dateLabel.text = dateString
        
        //theater 
        self.theaterLabel.text = self.currentTicket?.theater?.theaterName
        
        //Seat
        self.seatLabel.text = self.currentTicket?.seat
        
        //actor
        self.actorLabel.text = self.currentTicket?.actor
        

    }

  
}
