//
//  NoticeObject.swift
//  SwiftStudio
//
//  Created by David June Kang on 2017. 1. 21..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit

class NoticeObject: NSObject {
    var noticeKey  :String! //Notice Unique Key
    var authorId   :String! //Notice User Unique key
    var text       :String! //Notice Contents
    var recordTime :Double! //notice Record Time by milesecond
    var editTime   :Double! //notice Edited Time by milesecond
    
    init(_ noticeKey: String, _ authorId: String, _ text: String,_ recordTime: Double, _ editTime: Double){
        super.init()
        self.noticeKey = noticeKey
        self.authorId = authorId
        self.text = text
        self.recordTime = recordTime
        self.editTime = editTime
    }
    
    convenience override init() {
        self.init()
        self.noticeKey = ""
        self.authorId = ""
        self.text = ""
        self.recordTime = 0
        self.editTime = 0
    }
}

extension NoticeObject {
    @nonobjc
    func isEqual(_ obj: NoticeObject) -> Bool {
        
        guard !obj.isKind(of: NoticeObject.self) else {
            return false
        }
        
        guard self.noticeKey != obj.noticeKey, self.text != obj.text, self.recordTime != obj.recordTime, self.editTime != obj.editTime else {
            return true
        }
        
        return false
    }
}


