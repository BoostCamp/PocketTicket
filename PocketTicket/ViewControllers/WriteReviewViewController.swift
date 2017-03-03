//
//  WriteReviewViewController.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 13..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit

class WriteReviewViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
 
    //MARK: - Properties
    //Data singleton
    let dataInstance = DataController.sharedInstance()
    var currentTicket : Ticket? = nil
    
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var oneSentenceTextView: UITextField!
    
    
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
    
   override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Show keyboard by default
        oneSentenceTextView.becomeFirstResponder()
    }
    
    
    //MARK: - Actions
    //Cancel
    @IBAction func dismissView(_ sender: Any) {
        //keyboard resign
        oneSentenceTextView.resignFirstResponder()
        reviewTextView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }

    //Save
    @IBAction func saveReview(_ sender: Any) {
        let currentTicketId = currentTicket?.id
        //save in realm
        self.dataInstance.addReview(review: reviewTextView.text, oneSentece: oneSentenceTextView.text!, id: currentTicketId!)
        //keyboard resign
        self.reviewTextView.resignFirstResponder()
        self.oneSentenceTextView.resignFirstResponder()
        //alert
        self.alertSaveReview()

    }
    
    //MARK: - Alert
    func alertSaveReview(){
        let alertController = UIAlertController(title: "알림", message: "리뷰가 저장되었습니다.", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Set data
    func setData(){
        //one sentence
        if let oneSentence = self.currentTicket?.oneSentence{
            self.oneSentenceTextView.text = oneSentence
        }
        
        //review
        if let reviewTemp = self.currentTicket?.review, reviewTemp != ""{
            self.reviewTextView.text = reviewTemp
            self.reviewTextView.textColor = UIColor.black
        } else{
            self.reviewTextView.text = "리뷰를 입력하세요"
            self.reviewTextView.textColor = UIColor.lightGray
        }
    }
    //MAARK: - Text Field Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.isEqual(self.oneSentenceTextView)){ //titleField에서 리턴키를 눌렀다면
            self.reviewTextView.becomeFirstResponder()//review text view로 keyboard 포커스 이동
        }
        return false
    }
    
    //MARK: - TextView Delegate
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if reviewTextView.text == "리뷰를 입력하세요"{
            textView.text = ""
        }
        textView.textColor = UIColor.black
        return true
    }

    

}

