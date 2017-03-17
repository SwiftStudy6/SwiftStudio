//
//  CustomMileStoneViewControllerTableViewCell.swift
//  SwiftStudio
//
//  Created by 홍대호 on 2017. 1. 23..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit

class CustomMileStoneViewControllerTableViewCell: UITableViewCell {

  
    @IBOutlet weak var mainlabel: UILabel!
    @IBOutlet weak var detaillabel: UILabel!
    @IBOutlet weak var MileImage: UIImageView!
    @IBOutlet weak var userlabel: UILabel!

    @IBOutlet weak var textlabel: UILabel!
    @IBOutlet weak var accceptbutton: UIButton!
    @IBOutlet weak var rejectbutton: UIButton!
    @IBOutlet weak var detailmorebutton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
        

   // override init(frame: CGRect){
    @IBOutlet weak var morebt: UIButton!
    //    super.init(frame:frame)

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
