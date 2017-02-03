//
//  NoticeObject.swift
//  SwiftStudio
//
//  Created by David June Kang on 2017. 1. 21..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit

class NoticeObject: NSObject {
    var noticeKey  :String!
    var authorId   :String!
    var noticeText :String!
    var editTime   :String!
    
    convenience override init() {
        self.init()
        self.noticeKey = ""
        self.authorId = ""
        self.noticeText = ""
        self.editTime = ""

    }
    
    
    init(_ noticeKey: String, _ authorId: String, _ noticeText: String, _ editTime: String){
        super.init()
        self.noticeKey = noticeKey
        self.authorId = authorId
        self.noticeText = noticeText
        self.editTime = editTime
    }
    
    @nonobjc
    init(_ noticeKey: String, _ authorId: String, _ noticeText: String, _ editTime: Double){
        super.init()
        self.noticeKey = noticeKey
        self.authorId = authorId
        self.noticeText = noticeText
        self.editTime = NSDate(timeIntervalSince1970: editTime / 1000.0).toString()
    }
    
}

extension NoticeObject {
    @nonobjc
    func isEqual(_ obj: NoticeObject) -> Bool {
        
        guard !obj.isKind(of: NoticeObject.self) else {
            return false
        }
        
        guard self.noticeKey != obj.noticeKey, self.noticeText != obj.noticeText, self.editTime != obj.editTime else {
            return true
        }
        
        return false
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
