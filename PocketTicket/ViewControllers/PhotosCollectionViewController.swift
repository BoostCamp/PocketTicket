//
//  PhotosCollectionViewController.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 10..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var photoArray : [String]!
    var totalPhotoNum : Int?
    var currentPhotoIdx : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        totalPhotoNum = photoArray.count
        let titleText = "\(currentPhotoIdx+1) / \(totalPhotoNum!)"
        self.title = titleText
        
        
        
    }


    // MARK: UICollectionViewDataSource

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(photoArray.count)
        return photoArray.count
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCollectionViewCell", for: indexPath) as! PhotosCollectionViewCell
  
        
        cell.frame.size.width = self.view.frame.width
  
        if let photoArray = photoArray{
            let photo = photoArray[indexPath.row] 
            cell.fullImageView.image = UIImage(named: photo)
            
        }
    
        return cell
    }

 
    // MARK: - Scroll event
    //offset을 이용해서 해당하는 카드의 위치를 잡아서 넘김
     func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("Scroll")
        //현재 이미지 offset
        let offsetX = scrollView.contentOffset.x
        //전체 width
        let viewWidth = self.view.frame.width
        print(offsetX)
        print(viewWidth)
     
        //title
        currentPhotoIdx = Int(offsetX/viewWidth)
        let titleText = "\(currentPhotoIdx+1) / \(totalPhotoNum!)"
        self.title = titleText
    }
    

    
    // MARK: - Share
    @IBAction func shareImage(_ sender: Any) {
        let imageString = photoArray[currentPhotoIdx]
        print(imageString)
        let image : UIImage = UIImage(named: imageString)!
        let activityController = UIActivityViewController(activityItems:[image], applicationActivities: nil)
        self.present(activityController, animated:true, completion: nil)
        
        //The completion handler to execute after the activity view controller is dismissed.
        activityController.completionWithItemsHandler = {(activityType, completed, returnedItems, error) in
            
            // Return if cancelled
            if (!completed) {
                print("fail save the image")
                return
            }
            
            //Activity complete
            print("success save the image")
        }

    }
    
    //TODO : DB에서 데이터 삭제하기, Title 바꾸기
    @IBAction func deleteImage(_ sender: Any) {
        let photoIndexPath = IndexPath(row: currentPhotoIdx-1, section: 0)
//        photoCollectionView.deleteItems(at: [photoIndexPath as IndexPath])
        photoArray.remove(at: currentPhotoIdx)
        totalPhotoNum = photoArray.count
        print(photoArray.count)
        photoCollectionView.scrollToItem(at: photoIndexPath, at: .left, animated: true)
        photoCollectionView.reloadData()


    }
  

    
    
}
