//
//  TicketMainViewController.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 7..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit

class TicketMainViewController: UICollectionViewController{

    let modelInstance = ModelController.sharedInstance()
    var dummyData : [[String:Any]]!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tickets"
//        self.collectionView?.allowsSelection = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.dummyData = modelInstance.dummyData

    }
    
    func imageTapped(_ sender: UITapGestureRecognizer)
    {
            print("tapped")
        
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
        
        return cell
    }
    
    //MARK: - Collection view delegate
    //Move to Detail Meme
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
  
        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TicketCollectionViewCell", for: indexPath) as! TicketCollectionViewCell
//       
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
//        
//        cell.photoImageView.isUserInteractionEnabled = true
//        cell.photoImageView.addGestureRecognizer(tapGestureRecognizer)
        
        
        let selectedData = dummyData[indexPath.row]
        let selectPhotoArray : [String] = selectedData["photos"] as! [String]

        

        let photoViewController = self.storyboard?.instantiateViewController(withIdentifier: "PhotosViewController") as! PhotosViewController
    
        photoViewController.photoArray = selectPhotoArray
     
         self.navigationController!.pushViewController(photoViewController, animated: true)

        
    }
    //offset을 이용해서 해당하는 카드의 위치를 잡아서 넘김
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("Scroll")
        print(scrollView.contentOffset.x)
    }
    
    //flip animation을 이용. cell에 해당하는 view를 따로 만들어서 뒤집히도록 


}
