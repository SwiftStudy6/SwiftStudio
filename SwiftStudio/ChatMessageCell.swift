//
//  ChatMessageCell.swift
//  FireBaseChat
//
//  Created by 유명식 on 2017. 2. 20..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit

class ChatMessageCell:UICollectionViewCell{
    
    
    let textView :UITextView = {
        let tv = UITextView()
        tv.text = "SampleText For Now"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = UIColor.white
        return tv
}()
    
    let profileImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "moon")
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.layer.cornerRadius = 16
        imageview.layer.masksToBounds = true
        imageview.contentMode = .scaleAspectFill
        return imageview
        
    }()
    static let blueColor = UIColor(red:0,green:137,blue:249)
    
    let bubleView :UIView = {
        let view = UIView()
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        return view
    }()
    
    var bubleWidthAnchor :NSLayoutConstraint?
    var bubleViewRightAnchor : NSLayoutConstraint?
    var bubleViewLeftAnchor :NSLayoutConstraint?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubleView)
        addSubview(textView)
        addSubview(profileImageView)
        
        
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor,constant:8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        
        bubleViewRightAnchor = bubleView.rightAnchor.constraint(equalTo: self.rightAnchor,constant:-8);
        bubleViewRightAnchor?.isActive = true
        bubleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubleWidthAnchor = bubleView.widthAnchor.constraint(equalToConstant: 200)
        bubleWidthAnchor?.isActive = true
        bubleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
       
        
        bubleViewLeftAnchor = bubleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        
        //textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: bubleView.leftAnchor,constant:8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
