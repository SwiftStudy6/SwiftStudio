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

/*
class USER {
    
    var userEmail : String
    var userName : String
    
    init()
    {
        self.userEmail = ""
        self.userName = ""
    }
    
}
*/

class MileStoneCreateViewController: UIViewController {
    
    
    lazy var homeBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "Home"), style: .plain, target: self, action: #selector(self.back))
        
        return button
    }()
    
    lazy var composeBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "done [#1476].png"), style: .plain, target: self, action: #selector(self.DoneButton(_:)))
        
        return button
    }()
    
    
    
    @IBOutlet weak var MileTitleText: UITextField!
    
    @IBOutlet weak var MileDateText: UIDatePicker!
    
    @IBOutlet weak var MildDetailText: UITextView!
    
    @IBOutlet weak var main_title: UILabel!
    
    @IBOutlet weak var donelabel: UIButton!
    
    var selectedDate: String!
    var moidfy_uid : String! = "nodata"

    let user = USER()
    
    var mtitle: String?
    var mdetail: String?
    var mdate :Date? =  NSDate() as Date
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    //    self.main_title.text = "MileStone Create"
        self.MileTitleText.text = mtitle
        self.MildDetailText.text =  mdetail
        self.MileDateText.date = mdate!
        
      //  donelabel.setTitle("Done", for: .normal)
        MildDetailText!.layer.borderWidth = 1
        MildDetailText!.layer.borderColor = UIColor.black.cgColor
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm"
        let minute = dateFormatter.string(from: NSDate() as Date)
        if ( Int(minute)! >= 30 )
        {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:30"
        }
        else
        {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:00"
        }
        
       // let dateFormatter = DateFormatter()
       // dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        self.selectedDate = dateFormatter.string(from: NSDate() as Date)
        
        
        navigationItem.rightBarButtonItem = composeBarButtonItem
        navigationItem.leftBarButtonItem = homeBarButtonItem
        
        // 네비게이션 바를 추가한다.
        let naviBar = UINavigationBar()
        naviBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64)
        naviBar.items = [navigationItem]
        naviBar.barTintColor = .white
        
        self.view.addSubview(naviBar)

        
        
        
        
        // keyboard control
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        user_info()
    
        
    }
    
    
   
    // Called when 'return' key pressed. return NO to ignore.
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        MildDetailText.resignFirstResponder()
        print("background click")
        return true
    }
    
    // Called when the user click on the view (outside the UITextField).
    
    
    
    // in swift 3 click view event !!
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)  {
        if let touch = touches.first {
            let currnetPoint = touch.location(in:  self.view)
            print(currnetPoint)
           keyboardDismiss()
        }
    }
    
    
    // func touchesMoved
    // func touchesEnded 
    
    func keyboardDismiss() {
        MildDetailText.resignFirstResponder()
        MileTitleText.resignFirstResponder()
    }
    
    //ADD Gesture Recignizer to Dismiss keyboard then view tapped
    @IBAction func viewTapped(_ sender: AnyObject) {
        keyboardDismiss()
    }
    
    //Dismiss keyboard using Return Key (Done) Button
    //Do not forgot to add protocol UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        keyboardDismiss()
        
        return true
    }
    
    
    // keyboard show
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 100
            }
        }
        
    }
    // keyboard hide
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 100
            }
        }
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
        
        
        if self.moidfy_uid != "no"
        {
            
            delete_miledata(childWantToRemove  : self.moidfy_uid)
            
        }
        
        
           /*
        if self.moidfy_uid != "no"
        {
        let vc = UIStoryboard(name: "MileStone", bundle: nil).instantiateInitialViewController() as! MileStoneViewController
        
        vc.delete_miledata(childWantToRemove  : self.moidfy_uid)
        }
      */
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
        
        //let ref = FIRDatabase.database().reference()
        
        
        someMileCreateData.userID  = self.user.userEmail
        someMileCreateData.userName = self.user.userName
        someMileCreateData.instUserUid = self.user.uid
        
         let      ref = FIRDatabase.database().reference()
        
      
        
        //uid = FIRAuth.auth()?.currentUser?.uid
       // let user_id = FIRAuth.auth()?.currentUser?.value(forKey: "username")
    //    print(uid)
        //someMileCreateData.instUserUid = uid
        print("print user uid!!!")
        
        
        let key = ref.child("milelist").childByAutoId().key
        let milelist = [
                    "uid": key ,
                    "userID": someMileCreateData.userID! ,
                    "userName": someMileCreateData.userName!,
                    "mileTitle": someMileCreateData.mileTitle!,
                    "editTime": someMileCreateData.editTime!,
                    "bodyText": someMileCreateData.bodyText! ,
                    "instUserUid": someMileCreateData.instUserUid! ]as [String : Any]
        let mileUpdates = ["/milelist/\(key)": milelist]
                         //   "/milelist/\(someMileCreateData.id)/\(key)/": milelist]
        ref.updateChildValues(mileUpdates)

        
    
        
    }
    
    // delete mile list database
    func delete_miledata(childWantToRemove: String)  {
        
        
        //miles.remove(at: index)
        let ref = FIRDatabase.database().reference()
        
        ref.child("milelist").child(childWantToRemove).removeValue { (error, ref) in
            if error != nil {
                print("error \(error)")
                
            }
        }
        
        
        
    }
    
    
    
    
    func user_info() {
        
        
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference()
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with:  { (snapshot) in
            
            print("user value")
            print(snapshot.value)
            
            let snapshotValue = snapshot.value as! NSDictionary
            self.user.userEmail  = snapshotValue["email"] as? String ?? ""
            self.user.userName  = snapshotValue["userName"] as? String ?? ""
            self.user.uid  = uid!
            
            print("user value3333")
            print(self.user.userEmail)
            print(self.user.userName)
        })
        
        
    }
    
    
}






