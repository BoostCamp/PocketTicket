//
//  TicketDetailViewController.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 18..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit

class TicketDetailViewController: UIViewController {
    
    //MARK: - Properties
    //Data control
    let dataInstance = DataController.sharedInstance()
    var showTicket: Ticket? = nil

    //IBOutlet
    @IBOutlet var containView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var seatLabel: UILabel!
    @IBOutlet weak var oneSentenceLabel: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!
    
    //For segmented control
    @IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    //MARK: - App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //contianer view custom
        self.cardView.layer.shadowOffset = CGSize(width: 3  , height: 3)
        self.cardView.layer.shadowOpacity = 0.7
        self.cardView.layer.shadowRadius = 3
        self.cardView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.title = showTicket?.name
        
        //image action by gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageViewTapped(_:)))
        self.mainImageView.isUserInteractionEnabled = true
        self.mainImageView.addGestureRecognizer(tapGestureRecognizer)
        self.mainImageView.image = #imageLiteral(resourceName: "addMainPhoto")
        
        self.getFirstImage()


    }
    
    //MARK: - Move to Photos view
    func imageViewTapped(_ sender: UITapGestureRecognizer)
    {        
        let selectedTicket = showTicket
        
        let photoViewController = self.storyboard?.instantiateViewController(withIdentifier: "PhotosViewController") as! PhotosViewController
        
        photoViewController.showTicket = selectedTicket
        
        self.navigationController!.pushViewController(photoViewController, animated: true)
        
    }
    
    //MARK: - Get first image from document directory
    func getFirstImage(){
        if (showTicket?.photos.count)! > 0{
            let firstImageName = showTicket?.photos[0].photoPath
            let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("Images")
            let getImagePath = paths.appending("/\(firstImageName!)")
            print(getImagePath)
            mainImageView.image = UIImage(contentsOfFile: getImagePath)
            
        } else{
            mainImageView.image = #imageLiteral(resourceName: "addPhoto")
        }
    }
    
    //MARK: - prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Move to write review view
        if segue.identifier == "ToWriteReviewSegue"{
            let navController = segue.destination as? UINavigationController
            let controller = navController?.viewControllers.first as! WriteReviewViewController
            controller.currentTicket = showTicket
        }
        //Move to content segmented control view
        if segue.identifier == "toContentsSegue"{
            let controller = segue.destination as! ContentsViewController
            controller.currentTicket = showTicket
        }
        //Move to content segmented review view
        if segue.identifier == "toReviewSegue"{
            let controller = segue.destination as! ReviewViewController
            controller.currentTicket = showTicket
        }
    }

    @IBAction func changeSubView(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            reviewView.isHidden = false
            contentsView.isHidden = true
        case 1:
            reviewView.isHidden = true
            contentsView.isHidden = false
        default:
            break
        }
    }


}










