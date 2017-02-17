//
//  EachTicketsCollectionViewController.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 15..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit


class EachTicketsCollectionViewController: UICollectionViewController, showphotoDelegate {

    var showTicket : Ticket? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = showTicket?.name
        
        
        //Collection view select 막음
        self.collectionView?.allowsSelection = false
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        collectionView?.reloadData()
    }

   
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EachTicketsCollectionViewCell", for: indexPath) as! EachTicketsCollectionViewCell
        
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy.MM.dd  EEEE  a h:mm"
            let selectedDate = dateFormat.string(from: showTicket?.date as! Date)
            print(selectedDate)
        
        //////Todo optional 수정
            let theaterName = showTicket?.theater?.theaterName
            let seat = showTicket?.seat
            let theaterNameAndSeat = "\(theaterName!) \(seat!)"
            cell.seatLabel.text = theaterNameAndSeat
        
            cell.dateLabel.text = selectedDate
            cell.oneSentenceLabel.text = showTicket?.oneSenetence
        
        if indexPath.row == 0 {
            cell.photoImageView.isHidden = false
            cell.photoImageView.image = UIImage(named: "story2")
            cell.reviewTextView.isHidden = true

        }
        if indexPath.row == 1{
            if let review = showTicket?.review{
                cell.reviewTextView.text = review
            } else{
                cell.reviewTextView.text = "리뷰를 입력해주세요"
            }
            
            cell.reviewTextView.isHidden = false
            cell.photoImageView.isHidden = true
        }
        
        //set delegate
        cell.configureCell()
        cell.delegate = self
        cell.tag = indexPath.row
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    //MARK: - prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToWriteReviewSegue"{
            let navController = segue.destination as? UINavigationController
            let controller = navController?.viewControllers.first as! WriteReviewViewController
            controller.currentTicket = showTicket
        }
    }


}


//MARK: - Show photo View delegate
extension EachTicketsCollectionViewController{
    func imageViewTapped(cell: EachTicketsCollectionViewCell){
//        let selectedData = dummyData[cell.tag]
//        let selectPhotoArray : [String] = selectedData["photos"] as! [String]
//        
//        let photoViewController = self.storyboard?.instantiateViewController(withIdentifier: "PhotosViewController") as! PhotosViewController
//        
//        photoViewController.photoArray = selectPhotoArray
//        
//        self.navigationController!.pushViewController(photoViewController, animated: true)
    }
    
}



