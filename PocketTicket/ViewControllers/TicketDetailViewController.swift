//
//  TicketDetailViewController.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 18..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit

class TicketDetailViewController: UIViewController {
    
    //data control
    let dataInstance = DataController.sharedInstance()
    var showTicket: Ticket? = nil

    @IBOutlet var containView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var seatLabel: UILabel!
    @IBOutlet weak var oneSentenceLabel: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!
    
    @IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //contianer view custom
//        cardView.layer.cornerRadius = 10
        cardView.layer.shadowOffset = CGSize(width: 3  , height: 3)
        cardView.layer.shadowOpacity = 0.7
        cardView.layer.shadowRadius = 3
        cardView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
        
//        mainImageView.layer.cornerRadius = 10
        
//        segmentedControl.setBackgroundImage(#imageLiteral(resourceName: "btnBack"), for: .normal, barMetrics: .compact)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.title = showTicket?.name
//        self.reviewTextView.isEditable = false
        
//        if let showTicket = showTicket{
//            setData(showTicket)
//        }
//        
        //image action by gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageViewTapped(_:)))
        mainImageView.isUserInteractionEnabled = true
        mainImageView.addGestureRecognizer(tapGestureRecognizer)
        mainImageView.image = #imageLiteral(resourceName: "addMainPhoto")
        
//        contentsView.isHidden = false
//        reviewView.isHidden = true
//        
        getImage()


    }
    
    func getImage(){
        if (showTicket?.photos.count)! > 0{
            let firstImageName = showTicket?.photos[0].photoPath
            let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("Images")
            let getImagePath = paths.appending("/\(firstImageName!)")
            print(getImagePath)
            mainImageView.image = UIImage(contentsOfFile: getImagePath)
            
        } else{
            mainImageView.image = #imageLiteral(resourceName: "addMainPhoto")
        }
    }
    
    //MARK: - prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //리뷰 작성하는 부분으로 move
        if segue.identifier == "ToWriteReviewSegue"{
            let navController = segue.destination as? UINavigationController
            let controller = navController?.viewControllers.first as! WriteReviewViewController
            controller.currentTicket = showTicket
        }
        if segue.identifier == "toContentsSegue"{
            let controller = segue.destination as! ContentsViewController
            controller.currentTicket = showTicket
        }
        if segue.identifier == "toReviewSegue"{
            let controller = segue.destination as! ReviewViewController
            controller.currentTicket = showTicket
        }
    }
    
    //이미지 클릭했을 때 전체 다 보여주는 이미지로 넘어가기
    
    func imageViewTapped(_ sender: UITapGestureRecognizer)
    {
        print("image tapped")
        
        let selectedTicket = showTicket
        
        let photoViewController = self.storyboard?.instantiateViewController(withIdentifier: "PhotosViewController") as! PhotosViewController
        
        photoViewController.showTicket = selectedTicket
        
        self.navigationController!.pushViewController(photoViewController, animated: true)
        
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










