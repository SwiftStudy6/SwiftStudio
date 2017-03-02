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
    var attachments     : [String]?
    
    var likeCount       : Int = 0
    var likes           : Dictionary<String, Bool>?
    
    //init each
    init(_ boardNum: String, _ authorId: String, _ authorName: String, _ profileImgUrl: String, _ bodyText : String, _ editTime : String, _ attachments: [String]){
        self.boradKey = boardNum
        self.authorId = authorId
        self.authorName = authorName
        self.profileImgUrl = profileImgUrl
        self.attachments = attachments
        
//        if !profileImgUrl.isEmpty {
//            let imageView : UIImageView? = UIImageView()
//            
//            imageView?.sd_setImage(with: URL(string: profileImgUrl), placeholderImage: UIImage(named: "User"), options: .retryFailed, completed: { (image, error, cachedType, url) in
//                
//                //이미지캐싱이 안되있을경우에 대한 애니메이션 셋팅_imageView.alpha = 1;
//                if imageView != nil, cachedType == .none {
//                   
//                    imageView?.alpha = 0
//                    
//                    UIView.animate(withDuration: 0.2, animations: {
//                        imageView?.alpha = 1
//                    }, completion: { (finished) in
//                        imageView?.alpha = 1
//                    })
//                }
//            })
//            
//            self.profileImg = imageView?.image
//            
//        }
        
        self.bodyText = bodyText
        self.editTime = editTime
    }
    
    
    //init each
    init(_ boardNum: String, _ authorId: String, _ authorName: String, _ profileImgUrl: String, _ profileImg: UIImage, _ bodyText : String, _ editTime : String, _ attachments: [String]){
        self.boradKey = boardNum
        self.authorId = authorId
        self.authorName = authorName
        self.profileImg = profileImg
        self.profileImgUrl = profileImgUrl
        self.bodyText = bodyText
        self.editTime = editTime
        self.attachments = attachments
    }
    
    
    convenience override init(){
        let replaceHolderImg = UIImage(named: "user.png")
        self.init("", "", "", "" , replaceHolderImg!, "" , "", [""])
    }
    
    func objectToNSDic() -> NSDictionary {
        let dic : NSDictionary! =  nil
        
        dic.setValue(self.authorName, forKey: "name")
        dic.setValue(self.authorId, forKey: "uid")
        
        return dic
    }
    
    
}
extension BoardObject{
    @nonobjc
    func isEqual(_ obj : BoardObject) -> Bool {
        guard !obj.isKind(of: BoardObject.self) else {
            return false
        }
        
        
        if (self.boradKey != obj.boradKey) {
            return false
        }
        if(self.authorId != obj.authorId){
            return false
        }
        if(self.authorName != obj.authorName) {
            
        }
        if(self.profileImgUrl != obj.profileImgUrl) {
            return false
        }
        if(self.profileImg != obj.profileImg) {
            return false
        }
        
        if(self.bodyText != obj.bodyText) {
            return false
        }
        
        if(self.editTime != obj.editTime) {
            return false
        }
        
        return true
    }
}

