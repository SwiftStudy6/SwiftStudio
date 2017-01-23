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
