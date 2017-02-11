//
//  TicketCollectionViewCell.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 10..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import Foundation
import UIKit

class TicketCollectionViewCell : UICollectionViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
       
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var seatLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        scrollView.contentSize.height = 1000
//        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
//        photoImageView.isUserInteractionEnabled = true
//        photoImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //이미지 클릭했을 때 전체 다 보여주는 이미지로 넘어가기
    
//    func imageTapped(_ sender: UITapGestureRecognizer)
//    {
//        print("image tapped")
//        
//        
//    }
    
}
