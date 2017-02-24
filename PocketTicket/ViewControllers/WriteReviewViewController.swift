//
//  WriteReviewViewController.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 13..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit

class WriteReviewViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
 
    let dateInstance = DataController.sharedInstance()
    
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var oneSentenceTextView: UITextField!
    
    var currentTicket : Ticket? = nil
    
    //MARK: - App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentTicket != nil{
            setData()
        }
    }
    
    
   override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Show keyboard by default
        oneSentenceTextView.becomeFirstResponder()
    }
    
    
    //cancel
    @IBAction func dismissView(_ sender: Any) {
        oneSentenceTextView.resignFirstResponder()
        reviewTextView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveReview(_ sender: Any) {
        let currentTicketId = currentTicket?.id
//        reviewTextView.resignFirstResponder()
        self.dateInstance.addReview(review: reviewTextView.text, oneSentece: oneSentenceTextView.text!, id: currentTicketId!)
        
        self.reviewTextView.resignFirstResponder()
        self.oneSentenceTextView.resignFirstResponder()
        self.alertSaveReview()
//        self.reviewTextView.resignFirstResponder()
//        self.oneSentenceTextView.resignFirstResponder()
//        self.dismiss(animated: true, completion: nil)

    }
    
    
    func alertSaveReview(){
        let alertController = UIAlertController(title: "알림", message: "리뷰가 저장되었습니다.", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
            print("yap")
            self.dismiss(animated: true, completion: nil)
//            self.dismiss(animated: true, completion: nil)


        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func setData(){
        if let oneSentence = currentTicket?.oneSentence{
            oneSentenceTextView.text = oneSentence
        }
        
        if let review = currentTicket?.review{
            reviewTextView.text = review
            reviewTextView.textColor = UIColor.black
        } else{
            reviewTextView.text = "리뷰를 입력하세요"
            reviewTextView.textColor = UIColor.lightGray
        }
    }
}


//MAARK: - Text Field Delegate
extension WriteReviewViewController{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.isEqual(self.oneSentenceTextView)){ //titleField에서 리턴키를 눌렀다면
            self.reviewTextView.becomeFirstResponder()//컨텐츠필드로 포커스 이동
        }
        return false
    }
}


//MARK: - TextView Delegate
extension WriteReviewViewController{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if reviewTextView.text == "리뷰를 입력하세요"{
            textView.text = ""
        }
        textView.textColor = UIColor.black
        return true
    }
}



