//
//  Message.swift
//  FireBaseChat
//
//  Created by 유명식 on 2017. 2. 18..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit
import Firebase
class Message: NSObject {
    
    var fromId :String?
    var text:String?
    var timestamp :NSNumber?
    var toId :String?
    
    
    func chatPartnerId() ->String?{
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
        
                
//        if fromId == FIRAuth.auth()?.currentUser?.uid{
//            return toId
//        }else{
//            return fromId
//        }
        
        
    }

}
