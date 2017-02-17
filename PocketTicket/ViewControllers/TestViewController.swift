//
//  TestViewController.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 14..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func loadImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)

        
    }
   
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            //Share button enable
        }
        if let imageURL = info[UIImagePickerControllerReferenceURL] as? NSURL{
            let imagePath =  imageURL.path!
            print("imageURL : \(imageURL)")
            print("imagePath : \(imagePath)")
        }
        //        dismiss(animated: true, completion: nil)
    }

}
