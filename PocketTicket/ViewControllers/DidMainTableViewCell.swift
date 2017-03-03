//
//  DidMainTableViewCell.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 15..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit

class DidMainTableViewCell: UITableViewCell {

    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var oneSentenceLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var fullImage: UIImageView!
    
    @IBOutlet weak var notLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containView.layer.shadowOffset = CGSize(width: 2  , height: 2)
        self.containView.layer.shadowOpacity = 0.5
        self.containView.layer.shadowRadius = 2
        self.containView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
  
}
