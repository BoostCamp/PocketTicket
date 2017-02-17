//
//  EachTicketsCollectionViewCell.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 15..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit

protocol showphotoDelegate{
    func imageViewTapped(cell: EachTicketsCollectionViewCell)
}


class EachTicketsCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var seatLabel: UILabel!
    @IBOutlet weak var oneSentenceLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var reviewTextView: UITextView!
    
    
    
    var delegate : showphotoDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.black.cgColor
    }
    
    func configureCell(){
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageViewTapped(_:)))
        photoImageView.isUserInteractionEnabled = true
        photoImageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    
    //이미지 클릭했을 때 전체 다 보여주는 이미지로 넘어가기
    
    func imageViewTapped(_ sender: UITapGestureRecognizer)
    {
        delegate?.imageViewTapped(cell: self)
        print("image tapped")
        
        
    }
    
}
