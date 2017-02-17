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
    
    
   override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Show keyboard by default
        oneSentenceTextView.becomeFirstResponder()
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
        reviewTextView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveReview(_ sender: Any) {
        let currentTicketId = currentTicket?.id
        dateInstance.addReview(review: reviewTextView.text, oneSentece: oneSentenceTextView.text!, id: currentTicketId!)
        dismiss(animated: true, completion: nil)
    }
}


//MAARK: - Text Field Delegate
extension WriteReviewViewController{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
        reviewTextView.becomeFirstResponder()
        return true
    }
}


//MARK: - TextView Delegate
extension WriteReviewViewController{
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}



