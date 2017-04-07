//
//  NoticeCell.swift
//  SwiftStudio
//
//  Created by David June Kang on 2017. 2. 24..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit


//NoticeCell Class Definition
class NoticeCell : UICollectionViewCell {
    var key             : String!       //Notice-Posts Unique Key
    var indexPath       : IndexPath?    //Notice indexPath
    var authorId        : String?       //Notice Author
    var textLabel       : UILabel?      //Text
    private var object  : NoticeObject? //NoticeObject
    
    var dataObject      : NoticeObject {
        set(newValue){
            self.key = newValue.noticeKey
            self.textLabel?.text = newValue.text
            self.authorId = newValue.authorId
            
            self.object = newValue
        }
        
        get{
            return self.object!
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .white
        
        textLabel = {
            let _label = UILabel()
            _label.isUserInteractionEnabled = false
            _label.translatesAutoresizingMaskIntoConstraints = false
            _label.textColor = .black
            _label.font = .boldSystemFont(ofSize: 20)
            
            return _label
        }()
        
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(textLabel!)
        
        textLabel?.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 15).isActive = true
        textLabel?.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -15).isActive = true
        textLabel?.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        textLabel?.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NoticeCell init(coder:) has not been implemented")
    }
}
