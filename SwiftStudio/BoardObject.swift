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
    
    var boradKey         : String?       //Board uique Key
    var authorId         : String?       //Author Id(userId)
    var authorName       : String?       //Author Name
    var profileImgUrl    : String?       //Author Profile Url by string
    var bodyText         :  String?       //Board Body Text
    var recordTime       : String?       //Board Record Time by String
    var editTime         : String?       //Board Edited Time by String
    
    var recordTimeDouble : Double?       //Board Record Time by milesecond
    var editTimeDouble   : Double?       //Board Edited Time by Milesecond
    
    
    var attachments      : [String]?    //image files
    
    var likeCount        : Int = 0
    var like             : Dictionary<String, Bool>?
    
    //init
    init(_ boardKey: String, _ authorId: String, _ authorName: String, _ profileImgUrl: String, _ bodyText : String,_ recordTime : Double, _ editTime : Double, _ attachments: [String]){
        self.boradKey = boardKey
        self.authorId = authorId
        self.authorName = authorName
        self.profileImgUrl = profileImgUrl
        self.bodyText = bodyText
        
        self.recordTimeDouble = recordTime
        self.editTimeDouble = editTime
        
        self.recordTime = NSDate(timeIntervalSince1970: recordTime/1000).toString()
        
        self.editTime = ""
        
        if(recordTime < editTime){
            self.editTime = NSDate(timeIntervalSince1970: editTime/1000).toString().appending(" 수정됨")
        }else{
            self.editTime = NSDate(timeIntervalSince1970: editTime/1000).toString()
        }
        
        self.attachments = attachments
    }
    
    
    convenience override init(){
        self.init("", "", "", "" , "", 0, 0, [])
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
        guard obj.isKind(of: BoardObject.self) else {
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
        
        if(self.bodyText != obj.bodyText) {
            return false
        }
        
        if(self.editTime != obj.editTime) {
            return false
        }
        
        return true
    }
    
    @nonobjc
    func isEqaulContexts(_ object : BoardObject) -> Bool{
        
        var result = true
        
        if(self.bodyText != object.bodyText){
            result = false
        }
        
        if(self.editTime == nil && object.editTime != nil){
            result =  false
        }
        
        
        for (key1,_) in self.like! {
            for(key2,_) in object.like! {
                if key1 != key2 {
                    result = false
                }
            }
        }
        
        return result
        
    }
}
