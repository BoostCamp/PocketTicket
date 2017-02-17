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
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containView.layer.borderWidth = 1
        containView.layer.borderColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  
}
