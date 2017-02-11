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

    var photoArray : [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        
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

    // MARK: UICollectionViewDelegate
    

}
