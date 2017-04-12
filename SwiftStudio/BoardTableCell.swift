//
//  BoardCell2.swift
//  testTextView
//
//  Created by David June Kang on 2017. 3. 14..
//  Copyright © 2017년 ven2s.soft. All rights reserved.
//

import UIKit

protocol BoardTableCellDelegate {
    func menuButtonEvent(sender:UIButton, cell: BoardTableCell)
    
    func likeButtonEvent(sender:UIButton, cell: BoardTableCell)
    func replyButtonEvent(sender:UIButton, cell: BoardTableCell)
    func shareButtonEvent(sender:UIButton, cell: BoardTableCell)
    
    func readMoreEvent(cell:BoardTableCell)
}

class BoardTableCell: UITableViewCell, UITextViewDelegate {
    
    //User Info
    @IBOutlet weak var userInfoView: UIView?
    @IBOutlet weak var profileImage: UIImageView?
    @IBOutlet weak var authorName: UILabel?
    @IBOutlet weak var editTime: UILabel?
    @IBOutlet weak var menuButton: UIButton!
    
    //Body Text
    var originalText : String!
    @IBOutlet weak var textRecorded: UITextView?
    
    //Bottom View
    @IBOutlet var bottomView: UIView!
    @IBOutlet var lineView: UIView!
    
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var replyButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    
    var delegate : BoardTableCellDelegate?
    var isExpend : Bool! = false
    
    var indexPath :IndexPath?
    
    var key : String!
    var authorId : String!
    
    var dataObject   : BoardObject! {
        
        set(newValue){
            self.key = newValue.boradKey
            self.authorName?.text = newValue.authorName
            self.authorId = newValue.authorId
            self.editTime?.text = newValue.editTime
        }
        
        get{
            let returnVal = BoardObject()
            
            returnVal.boradKey   = self.key
            returnVal.authorId   = self.authorId
            returnVal.authorName = self.authorName?.text
            returnVal.bodyText   = (self.originalText == nil || self.originalText.isEmpty) ? self.textRecorded?.text : self.originalText
            returnVal.editTime   = self.editTime?.text
            
            return returnVal
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 0, 10, 0))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func buttonTouchUpInside(_ sender: UIButton) {
        if sender.tag == 0 {
            self.delegate?.menuButtonEvent(sender: sender, cell: self)
        }
        
        if sender.tag == 1 {
            self.delegate?.likeButtonEvent(sender: sender, cell: self)
        }
        
        if sender.tag == 2 {
            self.delegate?.replyButtonEvent(sender: sender, cell: self)
        }
        
        if sender.tag == 3 {
            self.delegate?.shareButtonEvent(sender: sender, cell: self)
        }
    }

    // MARK : - UITextView Delegate
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if !isExpend {
            textRecorded?.text = ""
            textRecorded?.text = originalText
            isExpend = true
            
            delegate?.readMoreEvent(cell: self)
        }
        
        return true
    }
}
