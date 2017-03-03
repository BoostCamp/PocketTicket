//
//  CalMainTableViewCell.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 15..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit

class CalMainTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Set layrer border color 
        self.cellView.layer.borderWidth = 1
        self.cellView.layer.borderColor = UIColor.black.cgColor
        
        self.dateLabel.textColor = UIColor(red:0.57, green:0.58, blue:0.61, alpha:1.00)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
