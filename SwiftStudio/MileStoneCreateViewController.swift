//
//  MileStoneCreateViewController.swift
//  SwiftStudio
//
//  Created by 홍대호 on 2017. 2. 10..
//  Copyright © 2017년 swift. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MileCreateData: NSObject {
    public var uid: UInt!
    var mileKey        : String?       //Board uique Key
    var userID         : String?       //Author Id(userId)
    var userName       : String?       //Author Name
    var profileImgUrl   : String?       //Author Profile Url by string
    var profileImg      : UIImage?      //Author Profile Image
    var mileTitle       : String?       //Board Body Text
    //var attendCnt       : Int?         //MileStone attend count
    //var attend          : String?      //MileStone attend
    var bodyText        : String?       //Board Body Text
    var editTime        : String?       //Board Edited Time yyyy/MM/dd hh:mm
    
    /*
     var uid            : Uint!
     var mileKey        : String?       //Board uique Key
     var userID        : String?       //Author Id(userId)
     var authorName      : String?       //Author Name
     var profileImgUrl   : String?       //Author Profile Url by string
     var profileImg      : UIImage?      //Author Profile Image
     var mileTitle        : String?       //Board Body Text
     var bodyText        : String?       //Board Body Text
     var editTime        : String?       //Board Edited Time yyyy/MM/dd hh:mm
     */
    
    
}




class MileStoneCreateViewController: UIViewController {
    
    
    @IBOutlet weak var MileTitleText: UITextField!
    
    @IBOutlet weak var MileDateText: UIDatePicker!
    
    @IBOutlet weak var MildDetailText: UITextView!
    
    @IBOutlet weak var main_title: UILabel!
    
    @IBOutlet weak var donelabel: UIButton!
    
    var selectedDate: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.main_title.text = "MileStone Create"
        self.MildDetailText.text = ""
        donelabel.setTitle("Done", for: .normal)
        MildDetailText!.layer.borderWidth = 1
        MildDetailText!.layer.borderColor = UIColor.black.cgColor
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        self.selectedDate = dateFormatter.string(from: NSDate() as Date)
        
    }
    
    
    
    @IBAction func MileDateAction(_ sender: Any) {
        
     let dateFormatter = DateFormatter()
     dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    let strDate = dateFormatter.string(from: MileDateText.date)
        self.selectedDate = strDate
        NSLog("%@",strDate )
        NSLog("%@",selectedDate )
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func DoneButton(_ sender: Any) {
        
        
        dataSetting()
        
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func back(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func dataSetting()
    {
        let someMileCreateData = MileObject.init()
        
        
        /*
         var mileKey        : String?       //Board uique Key
         var userID        : String?       //Author Id(userId)
         var userName      : String?       //Author Name
         var profileImgUrl   : String?       //Author Profile Url by string
         var profileImg      : UIImage?      //Author Profile Image
         var mileTitle        : String?       //Board Body Text
         var bodyText        : String?       //Board Body Text
         var editTime        : String?       //Board Edited Time yyyy/MM/dd hh:mm
        */

        someMileCreateData.userID = "ghd2167"
        someMileCreateData.userName = "hong"
        someMileCreateData.mileTitle = self.MileTitleText.text
        someMileCreateData.editTime = self.selectedDate
        someMileCreateData.bodyText = self.MildDetailText.text
        
    //    NSLog("[%s]", someMileCreateData.mileTitle)
   //     NSLog("[%@]", someMileCreateData.editTime)
   //     NSLog("[%@]", someMileCreateData.bodyText)
        
        print(someMileCreateData.mileTitle!)
        
        let ref = FIRDatabase.database().reference()
        
        let uid = FIRAuth.auth()?.currentUser?.uid
       // let user_id = FIRAuth.auth()?.currentUser?.value(forKey: "username")
        print(uid)
        someMileCreateData.instUserUid = uid
        print("printf user uid!!!")
        
        
        let key = ref.child("milelist").childByAutoId().key
        let milelist = [
                    "uid": key ,
                    "userID": someMileCreateData.userID! ,
                    "username": someMileCreateData.userName!,
                    "mileTitle": someMileCreateData.mileTitle!,
                    "editTime": someMileCreateData.editTime!,
                    "bodyText": someMileCreateData.bodyText! ,
                    "instUserUid": someMileCreateData.instUserUid! ]as [String : Any]
        let mileUpdates = ["/milelist/\(key)": milelist]
                         //   "/milelist/\(someMileCreateData.id)/\(key)/": milelist]
        ref.updateChildValues(mileUpdates)

        
      
        
        
        
        
    }
    
    
    
}






