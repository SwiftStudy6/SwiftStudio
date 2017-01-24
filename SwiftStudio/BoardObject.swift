//
//  BoardObject.swift
//  SwiftStudio
//
//  Created by David June Kang on 2017. 1. 24..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit

//Define Model Of Board
class BoardObject : NSObject {
    
    var boradKey        : String?       //Board uique Key
    var authorId        : String?       //Author Id(userId)
    var authorName      : String?       //Author Name
    var profileImgUrl   : String?       //Author Profile Url by string
    var profileImg      : UIImage?      //Author Profile Image
    var bodyText        : String?       //Board Body Text
    var editTime        : String?       //Board Edited Time yyyy/MM/dd hh:mm
    
    //init each
    init(_ boardNum: String, _ authorId: String, _ authorName: String, _ profileImgUrl: String, _ bodyText : String, _ editTime : String){
        self.boradKey = boardNum
        self.authorId = authorId
        self.authorName = authorName
        self.profileImgUrl = profileImgUrl
        
        if !profileImgUrl.isEmpty {
            let imageView = UIImageView()
            imageView.sd_setImage(with: URL(string: profileImgUrl))
            
            self.profileImg = imageView.image
        }
        
        self.bodyText = bodyText
        self.editTime = editTime
    }
    
    
    //init each
    init(_ boardNum: String, _ authorId: String, _ authorName: String, _ profileImgUrl: String, _ profileImg: UIImage, _ bodyText : String, _ editTime : String){
        self.boradKey = boardNum
        self.authorId = authorId
        self.authorName = authorName
        self.profileImg = profileImg
        self.profileImgUrl = profileImgUrl
        self.bodyText = bodyText
        self.editTime = editTime
    }
    
    
    convenience override init(){
        let replaceHolderImg = UIImage(named: "user.png")
        self.init("", "", "", "" , replaceHolderImg!, "" , "")
    }
    
    func objectToNSDic() -> NSDictionary {
        let dic : NSDictionary! =  nil
        
        dic.setValue(self.authorName, forKey: "name")
        dic.setValue(self.authorId, forKey: "uid")
        
        return dic
    }
    
    
}
