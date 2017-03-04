//
//  CustomMileStoneDetailViewTableViewCell.swift
//  SwiftStudio
//
//  Created by 홍대호 on 2017. 1. 23..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit

class CustomMileStoneDetailViewTableViewCell: UITableViewCell {
    
   
    @IBOutlet weak var detailLabel1: UILabel!
    
    @IBOutlet weak var usernamelabel: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    
    @IBOutlet weak var attendlabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
