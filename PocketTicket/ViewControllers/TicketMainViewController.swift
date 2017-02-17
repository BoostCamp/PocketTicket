//
//  TicketMainViewController.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 7..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit

class TicketMainViewController: UICollectionViewController{

    let modelInstance = DataController.sharedInstance()
    var dummyData : [[String:Any]]!
  
    
    //MARK: - App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tickets"
        //Collection view select 막음
        self.collectionView?.allowsSelection = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
//        self.dummyData = modelInstance.dummyData
    }
    

    //MARK: - Collection view data source
    override  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TicketCollectionViewCell", for: indexPath) as! TicketCollectionViewCell
        
        let selectedData = dummyData[indexPath.row]
        
        // Set the text and image
        cell.titleLabel.text = selectedData["name"] as! String?
        cell.dateLabel.text = selectedData["date"] as! String?
        cell.seatLabel.text = selectedData["seat"] as! String?
        let photoArray : Array = selectedData["photos"] as! [String]
        let firstImage : String = (photoArray[0] as String?)!
        cell.photoImageView.image = UIImage(named: firstImage)
        
        let starNum = selectedData["star"] as! Int
        var starString = ""
        for i in 0..<starNum{
            starString += "★"
        }
        cell.starLabel.text = starString
        
        //set delegate
//        cell.configureCell()
//        cell.delegate = self
//        cell.tag = indexPath.row
//        
        return cell
    }
    
    //MARK: - Collection view delegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
    }
 
    
    //flip animation을 이용. cell에 해당하는 view를 따로 만들어서 뒤집히도록 


}

//MARK: - Show Image View delegate
//extension TicketMainViewController{
//    func imageViewTapped(cell: TicketCollectionViewCell){
//        let selectedData = dummyData[cell.tag]
//        let selectPhotoArray : [String] = selectedData["photos"] as! [String]
//        
//        let photoViewController = self.storyboard?.instantiateViewController(withIdentifier: "PhotosViewController") as! PhotosViewController
//        
//        photoViewController.photoArray = selectPhotoArray
//        
//        self.navigationController!.pushViewController(photoViewController, animated: true)
//    }
//
//}








