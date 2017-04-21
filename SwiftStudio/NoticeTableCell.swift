//
//  NoticeTableCell.swift
//  testTextView
//
//  Created by David June Kang on 2017. 3. 16..
//  Copyright © 2017년 ven2s.soft. All rights reserved.
//

import UIKit

class NoticeTableCell: UITableViewCell {

    @IBOutlet var innerView: UIView!
    @IBOutlet var lable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
