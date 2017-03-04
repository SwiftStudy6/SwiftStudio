//
//  BoardObject.swift
//  SwiftStudio
//
//  Created by hongdaeho on 2017. 2. 14..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit

//Define Model Of Board
class MileObject : NSObject {
    
  //  var uid            : Int?
    var mileKey        : String?       //Board uique Key
    var userID        : String?       //Author Id(userId)
    var userName      : String?       //Author Name
    var profileImgUrl   : String?       //Author Profile Url by string
    var profileImg      : UIImage?      //Author Profile Image
    var mileTitle        : String?       //Board Body Text
    var bodyText        : String?       //Board Body Text
    var editTime        : String?       //Board Edited Time yyyy/MM/dd hh:mm
    var instUserUid      : String?       //inst User Uid
    //init each
    
      override  init()
      {
        self.mileKey = "1"
        self.userID = "2"
        self.userName = "hong"
        self.mileTitle = "title"
        self.bodyText = "text test"
        
    }

    
}
