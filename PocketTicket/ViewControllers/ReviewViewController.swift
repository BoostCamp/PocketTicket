//
//  ReviewViewController.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 20..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var oneSentence: UILabel!
    
    var currentTicket : Ticket?
    
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
        //One Sentence
        if let oneSentenceTemp = currentTicket?.oneSentence, oneSentenceTemp != ""{
            self.oneSentence.text = oneSentenceTemp
            self.oneSentence.textColor = UIColor.black
        } else{
            self.oneSentence.text = "한줄평을 작성해주세요"
            self.oneSentence.textColor = UIColor.lightGray
        }
        
        //Review
        if let reviewTemp = currentTicket?.review, reviewTemp != "", reviewTemp != "리뷰를 입력하세요"{
            self.reviewTextView.text = reviewTemp
            self.reviewTextView.textColor = UIColor.black
        } else{
            self.reviewTextView.text = "리뷰를 작성해주세요"
            self.reviewTextView.textColor = UIColor.lightGray
        }
        

    }

}
