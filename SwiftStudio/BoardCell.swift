//
//  BoardCell.swift
//  SwiftStudio
//
//  Created by David June Kang on 2017. 2. 24..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit

//BoardCell Delegate Protocol
protocol BoardCellDelegate  {
    func editButtonEvent(sender:UIButton, cell : BoardCell)
    func likeButtonEvent(sender:UIButton, cell : BoardCell)
    func replyButtonEvent(sender:UIButton, cell : BoardCell)
    func shareButtonEvent(sender:UIButton, cell : BoardCell)
}

//Board Cell Definition
class BoardCell : UICollectionViewCell {
    
    
    var key          : String! = nil                //Board Key
    var authorId     : String! = nil                //Board Writer Id(User Id)
    var userImage    : UIImageView! = nil           //Profile image
    var authorName   : UILabel? = nil               //Username
    var editTime     : UILabel? = nil               //Edited time
    var textRecorded : UITextView? = nil            //Text
    var attachments  : [String]?
    
    var likeButton   : UIButton?                    //likeButton
    
    var delegate     : BoardCellDelegate? = nil     //BoardCellDelegate Object
    
    var dataObject   : BoardObject! {
        
        set(newValue){
            self.key = newValue.boradKey
            self.authorName?.text = newValue.authorName
            self.authorId = newValue.authorId
            self.textRecorded?.text = newValue.bodyText
            self.editTime?.text = newValue.editTime
            self.attachments = newValue.attachments
        }
        
        get{
            let returnVal = BoardObject()
            
            returnVal.boradKey   = self.key
            returnVal.authorId   = self.authorId
            returnVal.authorName = self.authorName?.text
            returnVal.bodyText   = self.textRecorded?.text
            returnVal.editTime   = self.editTime?.text
            returnVal.attachments = self.attachments
            
            return returnVal
        }
    }
    
    var indexPath : IndexPath!
    
    override init(frame: CGRect){
        super.init(frame:frame)
        setSetting()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //View setting
    func setSetting(){
        self.contentView.backgroundColor = .white
        
        
        let innerView = UIView(frame:CGRect.zero)
        innerView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.contentView.addSubview(innerView)
        
        innerView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 15).isActive = true
        innerView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        innerView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -30).isActive = true
        innerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        
        
        //Userinfo
        let userInfoView = UIView()
        userInfoView.backgroundColor = .white
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        innerView.addSubview(userInfoView)
        
        userInfoView.leftAnchor.constraint(equalTo: innerView.leftAnchor).isActive = true
        userInfoView.topAnchor.constraint(equalTo: innerView.topAnchor).isActive = true
        userInfoView.widthAnchor.constraint(equalTo: innerView.widthAnchor).isActive = true
        userInfoView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        //settting userImage
        self.userImage = UIImageView()
        self.userImage.translatesAutoresizingMaskIntoConstraints = false
        self.userImage.layer.masksToBounds = true;
        self.userImage.layer.cornerRadius = 18
        self.userImage.layer.borderWidth = 2
        self.userImage.layer.borderColor = UIColor.black.cgColor
        
        
        userInfoView.addSubview(self.userImage)
        
        self.userImage.leftAnchor.constraint(equalTo: userInfoView.leftAnchor).isActive = true
        self.userImage.topAnchor.constraint(equalTo: userInfoView.topAnchor, constant: 10).isActive = true
        self.userImage.widthAnchor.constraint(equalToConstant: 38).isActive = true
        self.userImage.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        
        //setting editButton
        let editButton = UIButton()
        
        editButton.setImage(UIImage(named: "More"), for: .normal)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.addTarget(self, action: #selector(editButtonTouchUpinside), for: .touchUpInside)
        
        userInfoView.addSubview(editButton)
        
        editButton.rightAnchor.constraint(equalTo: userInfoView.rightAnchor).isActive = true
        editButton.topAnchor.constraint(equalTo: userInfoView.topAnchor, constant: 12).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 11).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        
        //setting UserName
        self.authorName = UILabel()
        self.authorName?.textAlignment = .left
        self.authorName?.font = UIFont.boldSystemFont(ofSize: 14)
        self.authorName?.textColor = .black
        
        userInfoView.addSubview(self.authorName!)
        
        self.authorName?.translatesAutoresizingMaskIntoConstraints = false
        self.authorName?.leftAnchor.constraint(equalTo: (self.userImage?.rightAnchor)!, constant: 8.5).isActive = true
        self.authorName?.topAnchor.constraint(equalTo: userInfoView.topAnchor, constant: 11).isActive = true
        self.authorName?.rightAnchor.constraint(equalTo: editButton.leftAnchor, constant: -8.5).isActive = true
        self.authorName?.heightAnchor.constraint(equalToConstant: 17).isActive = true
        

        //settting editTime (yyyy년 MM월 dd일 hh시 mm분
        self.editTime = UILabel()
        self.editTime?.textAlignment = .left
        self.editTime?.font = UIFont.systemFont(ofSize: 11)
        self.authorName?.textColor = .black
        
        userInfoView.addSubview(self.editTime!)
        
        self.editTime?.translatesAutoresizingMaskIntoConstraints = false
        self.editTime?.leftAnchor.constraint(equalTo: (self.userImage?.rightAnchor)!, constant: 8.5).isActive = true
        self.editTime?.topAnchor.constraint(equalTo: (self.authorName?.bottomAnchor)!, constant: 2.3).isActive = true
        self.editTime?.rightAnchor.constraint(equalTo: editButton.leftAnchor, constant: -8.5).isActive = true
        self.editTime?.heightAnchor.constraint(equalToConstant: 17).isActive = true
        
        
        //setting body Text Area
        self.textRecorded = UITextView()
        self.textRecorded?.font = UIFont.systemFont(ofSize: 13)
        self.textRecorded?.isUserInteractionEnabled = false
        self.contentView.addSubview(self.textRecorded!)
        
        self.textRecorded?.translatesAutoresizingMaskIntoConstraints = false
        self.textRecorded?.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12).isActive = true
        self.textRecorded?.topAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: 4).isActive = true
        self.textRecorded?.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -12).isActive = true
        self.textRecorded?.heightAnchor.constraint(equalToConstant: 164).isActive = true
        
        //setting bottom view
        let bottomView = UIView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        innerView.addSubview(bottomView)
        
        bottomView.leftAnchor.constraint(equalTo: innerView.leftAnchor).isActive = true
        bottomView.topAnchor.constraint(equalTo: (self.textRecorded?.bottomAnchor)!, constant: 3).isActive = true
        bottomView.widthAnchor.constraint(equalTo: innerView.widthAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        //lineView
        let lineView = UIView()
        let color = UIColor.darkGray.withAlphaComponent(0.3)
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomView.addSubview(lineView)
        
        lineView.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        lineView.leftAnchor.constraint(equalTo: bottomView.leftAnchor).isActive = true
        lineView.widthAnchor.constraint(equalTo: bottomView.widthAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let offsetWidth = self.contentView.frame.width - 30
        
        //add like button
        let defaultColor = UIColor(red: 0, green: 112, blue: 225, alpha: 1.0)   //Apple Default Color
        
        let likeButton = UIButton()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setTitle("좋아요", for: .normal)
        likeButton.setTitleColor(.black, for: .normal)
        likeButton.setTitleColor(.gray, for: .highlighted)
        likeButton.setTitleColor(defaultColor, for: .selected)
        likeButton.titleLabel?.font = .systemFont(ofSize: 12)
        likeButton.addTarget(self, action: #selector(likeButtonTouchUpInside(_:)), for: .touchUpInside)
        likeButton.contentVerticalAlignment = .center
        likeButton.contentHorizontalAlignment = .center
        
        bottomView.addSubview(likeButton)
        
        likeButton.leftAnchor.constraint(equalTo: bottomView.leftAnchor).isActive = true
        likeButton.topAnchor.constraint(equalTo: lineView.topAnchor).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: offsetWidth/3).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.likeButton = likeButton
        
        
        //add reply button
        let replyButton = UIButton()
        replyButton.setTitle("댓글달기", for: .normal)
        replyButton.setTitleColor(.black, for: .normal)
        replyButton.setTitleColor(.gray, for: .highlighted)
        replyButton.titleLabel?.font = .systemFont(ofSize: 12)
        replyButton.translatesAutoresizingMaskIntoConstraints = false
        replyButton.addTarget(self, action: #selector(replyButtonTouchUpInside(_:)), for: .touchUpInside)
        replyButton.contentVerticalAlignment = .center
        replyButton.contentHorizontalAlignment = .center
        
        
        bottomView.addSubview(replyButton)
        
        replyButton.leftAnchor.constraint(equalTo: likeButton.rightAnchor).isActive = true
        replyButton.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        replyButton.widthAnchor.constraint(equalToConstant: offsetWidth/3).isActive = true
        replyButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        //add reply button
        let shareButton = UIButton()
        shareButton.setTitle("공유하기", for: .normal)
        shareButton.setTitleColor(.black, for: .normal)
        shareButton.setTitleColor(.gray, for: .highlighted)
        shareButton.titleLabel?.font = .systemFont(ofSize: 12)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.addTarget(self, action: #selector(shareButtonTouchUpInside(_:)), for: .touchUpInside)
        shareButton.contentVerticalAlignment = .center
        shareButton.contentHorizontalAlignment = .center
        
        bottomView.addSubview(shareButton)
        
        shareButton.leftAnchor.constraint(equalTo: replyButton.rightAnchor).isActive = true
        shareButton.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: offsetWidth/3).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        
    }
    
    
    //Button Delegate Fucniton
    @IBAction func editButtonTouchUpinside(_ sender:UIButton){
        self.delegate?.editButtonEvent(sender:sender, cell: self)
    }
    
    @IBAction func likeButtonTouchUpInside(_ sender:UIButton){
        self.delegate?.likeButtonEvent(sender: sender, cell: self)
    }
    
    @IBAction func replyButtonTouchUpInside(_ sender:UIButton){
        self.delegate?.replyButtonEvent(sender:sender, cell: self)
    }
    
    @IBAction func shareButtonTouchUpInside(_ sender:UIButton){
        self.delegate?.shareButtonEvent(sender: sender, cell: self)
    }
    
}
