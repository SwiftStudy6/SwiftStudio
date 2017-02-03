//
//  CurrentUser.swift
//  SwiftStudio
//
//  Created by 유명식 on 2017. 2. 3..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit

final class CurrentUser: NSObject {
    
    static let shared = CurrentUser()   //signleton
    
    var userName: String!
    var profileImg : UIImage?
    var profileUrl : NSURL?
    
    
    
}
