//
//  MileStoneDetailViewController.swift
//  SwiftStudio
//
//  Created by 홍대호 on 2017. 
//  Copyright © 2017년 swift. All rights reserved.


import Foundation
import UIKit
import Firebase

class MILEATTEND1
{
    //  var uid            : Int?
    var mileKey        : String?       //Board uique Key
    var userId        : String?       //Author Id(userId)
    var userName      : String?       //Author Name
    var profileImgUrl   : String?       //Author Profile Url by string
    var profileImg      : UIImage?      //Author Profile Image
    var mileTitle        : String?       //Board Body Text
    var mileAttend : Dictionary<String, Bool>
    var mileCount = 0
    var bodyText        : String?       //Board Body Text
    var editTime        : String?       //Board Edited Time yyyy/MM/dd hh:mm
    var attendFlag       : String?
    
    //init each
    
    init(mileKey: String, userId: String, userName: String, profilelmgUrl:String , profileImg:String ,
         mileTitle:String )
    {

        self.userName = "hong"
        self.mileTitle = "title"
        self.bodyText = "text test"
        self.mileAttend = [:]
        self.mileCount = 0

    }
    
}

class USERATTEND {

    var uid : String?
    var user_id : String?
    var user_nm : String?
    var user_email :String?
    var attend_yn :String?
    
}




class MileStoneDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
  
    let  mile_detail_list = ["참석", "참석", "불참"]
    
    @IBOutlet weak var mainlabel: UILabel!
    
    @IBOutlet weak var acceptlabel: UILabel!
    
    @IBOutlet weak var attend_count: UILabel!
    
    @IBOutlet weak var nonattend_count: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var title_key :String?
    
   //var mileAttend = [USERATTEND]()
    var mile_user = [USERATTEND]()


    var mile_detail_title: String!
    var mileattends = [MILEATTEND1]()
    var attend : Int? = 0
    
    //var mile_user = [String : Bool]()
    
  //  let mile_user_list = [mile_user]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.mainlabel.text = "MileDetail List"
        self.mainlabel.text = mile_detail_title
        
        self.acceptlabel.text = "참석인원"
        
        
        navigationItem.title = "MileDetail List"
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(back))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        
        
        NSLog("detail printing")
        
        
        self.loadTable_1()
       // self.attend_count.text = String(self.attend!)
        //self.nonattend_count.text = String(mileattends.count - self.attend!)
        
     //   print(String(self.attend!))
      //  print(attend)
        
        self.tableView.reloadData()
        
    }
    
    let test_image = ["user", "user", "user"]
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        //return mileattends.count
        //return (mile_detail_list.count)
        
        
        return mile_user.count
        
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomMileStoneDetailViewTableViewCell
        
        
       // let mileuser = mile_user[indexPath.row]
        
        cell.detailImage.image = UIImage(named: "user"+".png")
        
        //let celluserid = mileuser.
        //
       // cell.detailLabel1.text =
        
        
        print("mileAttend!!!!!1")
       // print(mileAttend.count)
        print(indexPath.row)
        let mind = mile_user[indexPath.row]

        
    
    //    print(mind)
        
      //  attend_count.text = String(mileAttend.count)
        
        
          cell.detailLabel1.text = mind.user_email
          cell.usernamelabel.text = mind.user_nm
   
        
     //   let mileattend = mileattends[indexPath.row]
     //   cell.detailLabel1.text = mileattend.userId
      //  cell.usernamelabel.text = mileattend.userName
    //    if(mileattend.attendFlag == "Y")
     //   {
     //   cell.attendlabel.text = "참석"
    //    }
     //   else
    //    {
     //   cell.attendlabel.text = "불참"
     //   }
        
       // var attend: Int
       // var x: Int
        
       // attend = 0
        
        /*
        for var i in 0..<mileattends.count {
            attend +=  1
            print(attend)
        }
        */
        /*
        let values = []
        
        
        for item in values {
            let userName = item["userName"]
            
            let user = User()
            user.userName = userName
            
            mileAttend.append(user)
        }
        
      */
        
        return (cell)
    }
    
    
    
    
    @IBAction func back(_ sender: Any) {
        
        
        //self.topMostController()
        
        //let vc = UIStoryboard(name: "MileStone", bundle: nil).instantiateInitialViewController() as! MileStoneViewController
       
        self.dismiss(animated: true, completion: nil)
    
 
       //  navigationController?.pushViewController(vc, animated: true)
        
        
      
        
        
        // 시작
      //  showViewController(vc, true, nil)
        
    }
    func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
    
    
    
    func showViewController(_ viewController: UIViewController,_ animated : Bool,_ completion :(() -> Swift.Void)? = nil){
        var activateController = UIApplication.shared.keyWindow?.rootViewController
        
        if(activateController?.isKind(of: UINavigationController.self))!{
            activateController = (activateController as! UINavigationController).visibleViewController
        }else if((activateController?.presentedViewController) != nil){
            activateController = activateController?.presentedViewController
        }
        
        activateController?.present(viewController, animated: animated, completion: completion)
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func loadTable_1()
    {
        
        
        //  let  milelist = MileObject.init()
        var tempList : Array<Any>! = nil
        
        
        /*
         let ref = FIRDatabase.database().reference()
         _=ref.child("milelist").observe(.value, with: {snapshot in
         print(snapshot.value)
         })
         */
        
        
        
        
        
        /*
         let query = ref.child("milelist")
         query.observeSingleEvent(of: .value, with: {[weak self] snapshot in
         //    guard let wself = self else {return}
         print(snapshot.value)
         for childSnapshot in snapshot.children {
         if let childSnapshot = childSnapshot as? FIRDataSnapshot {
         let mile = Mile(snapshot: childSnapshot)
         self?.miles.append(mile)
         }
         }
         
         DispatchQueue.main.async{
         self?.tableView.reloadData()
         }
         })
         */
        
        
        //ref.child("mileattend").child("mileTitle").setValue(mile_detail_title)
        
        //let mileattends = ref.child("mileattend")
       // print(mileattends)
        
       // let query = mileattends.queryEqual(toValue: mile_detail_title, childKey: "mileTitle")
        //let mileattends = MILEATTEND1()
        
        
        
    
        
      //  var attendlists = [mileAttend]()
    
        print("title_key")
         print(title_key!)
        print(mile_detail_title)
        
       //  let ref = FIRDatabase.database().reference()
       // let mileattends = ref.child("milelist")
       // let query = mileattends.queryOrdered(byChild: "uid").queryEqual(toValue: title_key)
        
        let ref = FIRDatabase.database().reference().child("milelist").child(title_key!).child("mileAttend")
       // let query = ref.queryOrdered(byChild: "uid").queryEqual(toValue: title_key)
        
        ref.observe(.childAdded, with: {[weak self] snapshot in
           // let mileat = MILEATTEND1()
           // mileat.userID = ref.child("mileattend").setValue(<#T##value: Any?##Any?#>, forKey: "userID")
       //    mileat.userID = ref.child("mileattend").value(forKey: "userID") as! String?
            
            print("snapshot.value ")
         //   print(snapshot.key )
            print(snapshot.value )
          //  print([snapshot.value].uid )
            
         //   let snapshotValue = snapshot.value as! NSDictionary
         //   let snapshotValue = snapshot.value as! String
         //   var mileAttend : Dictionary<String, Bool>
            let snapshotValue = snapshot.value as! NSDictionary
               let  attendlists = USERATTEND()
             attendlists.user_email = snapshotValue["userEmail"] as? String ?? ""
             attendlists.user_nm = snapshotValue["userName"] as? String ?? ""
             attendlists.attend_yn = snapshotValue["attendFlag"] as? String ?? ""
        //     mileat.userId  = snapshotValue["userId"] as? String ?? ""
         //   mileat.userName  = snapshotValue["userName"] as? String ?? ""
          //  var mileAttend : Dictionary<String, Bool>
          //   mileAttend  = snapshotValue["mileAttend"] as? [String : Bool] ?? [:]
         //   mileat.mileCount = snapshotValue["mileCount"] as? Int ?? 0
         //   mileat.mileKey = snapshotValue["uid"] as? String ?? ""
            
      //      let key = snapshot.key
       //     let v_1 = snapshot.value
      //      let value = v_1
            
           
            
             print("attendlists")
      
            
            
           self?.mile_user.append(attendlists)
            
            NSLog("append")
            DispatchQueue.main.async{
                // self?.tableView.endUpdates()
                self?.tableView.reloadData()
            }
        }
        )
        
       //print(mileattends)
        //print(query)
    }

    
    
    
    
    
    
    
    
    
}
