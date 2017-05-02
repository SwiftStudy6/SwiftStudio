//
//  MileStoneViewController.swift
//  SwiftStudio
//
//  Created by 홍대호 on 2017. 1. 12..
//  Copyright © 2017년 swift. All rights reserved.
//
import Foundation
import Firebase
import UIKit
import SDWebImage


//milestone struct
class Mile: Equatable {
    var username = ""
    var userID = ""
    var uid = ""
    var mileTitle = ""
    var editTime = ""
    var bodyText = ""
    var instUserUid = ""
    var instUserProfileUrl = ""
    var ref:FIRDatabaseReference

    init(snapshot: FIRDataSnapshot)
    {
        let snapshotValue = snapshot.value as! NSDictionary
        username = snapshotValue["userName"] as? String ?? ""
        userID = snapshotValue["userID"] as? String ?? ""
        mileTitle = snapshotValue["mileTitle"] as? String ?? ""
        uid = snapshotValue["uid"] as? String ?? ""
        editTime = snapshotValue["editTime"] as? String ?? ""
        bodyText = snapshotValue["bodyText"] as? String ?? ""
        instUserUid = snapshotValue["instUserUid"] as? String ?? ""
         instUserProfileUrl = snapshotValue["instUserProfileUrl"] as? String ?? ""
        ref = snapshot.ref
    }
}

func ==(lhs: Mile, rhs: Mile)->Bool {
    return lhs.uid == rhs.uid

}

class MILEATTEND
{
    //  var uid            : Int?
    var mileKey        : String?         //Board uique Key
    var userID        : String?           //Author Id(userId)
    var userName      : String?       //Author Name
    var profileImgUrl   : String?     //Author Profile Url by string
    var profileImg      : UIImage?     //Author Profile Image
    var mileTitle        : String?        //Board Body Text
    var attendCnt       : Int?            //MileStone attend count
    var bodyText        : String?       //Board Body Text
    var editTime        : String?       //Board Edited Time yyyy/MM/dd hh:mm
    var attendFlag       : String?
    
    //init each
    
      init()
    {
        self.mileKey = "1"
        self.userID = "2"
        self.userName = "hong"
        self.mileTitle = "title"
        self.bodyText = "text test"
        
    }
    
}

class USER {
    
    var userEmail : String
    var userName : String
    var uid : String
    var profile_url :String
    
  init()
  {
     self.userEmail = ""
     self.userName = ""
     self.uid = ""
     self.profile_url = ""
  }
   
}



class MileStoneViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    
    lazy var homeBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "Home"), style: .plain, target: self, action: #selector(self.returnHome))
        
        return button
    }()
    
    lazy var composeBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.milenewbutton))
        
        return button
    }()
    
    //메인 타이틀
    var titleString : String! = nil
    var textcontent : String! = nil
   
    @IBOutlet weak var tableView: UITableView!
    var miles = [Mile]()
    let user = USER()
    
    @IBOutlet weak var yesbt: UIButton!
    @IBOutlet weak var nobt: UIButton!
    
    
    var mileList : Array<Any>! = []
    
    
    let test_image = ["user", "user", "user"]
    let mile_list_title = ["스터디 1주차", "스터디 2주차", "스터디 3주차"]
    let mile_list_data = ["1월 11일 6시 ENI", "1월 17일 6시 ENI", "1월 23일 6시 ENI"]
    
    var  MileTitleText :String = ""
    var MildDetailText :String = ""
    var selectedDateString :String = ""
    var selectedDate :Date =  NSDate() as Date
    
    
    func returnHome(){
        closeViewController(true)
    }
    
    
    override func closeViewController(_ animated : Bool,_ completion :(() -> Swift.Void)? = nil){
        var activateController = UIApplication.shared.keyWindow?.rootViewController
        
        if(activateController?.isKind(of: UINavigationController.self))!{
            activateController = (activateController as! UINavigationController).visibleViewController
        }else if((activateController?.presentedViewController) != nil){
            activateController = activateController?.presentedViewController
        }
        
        activateController?.dismiss(animated: animated, completion: completion)
    }

    
    public func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        
        return 1
    }
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       // return (mile_list_title.count)
        //return self.mileList.count
        NSLog("miles.count : [%ld]", miles.count)
        
        return miles.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomMileStoneViewControllerTableViewCell
       
        
        let mile = miles[indexPath.row]
        cell.mainlabel.text = mile.mileTitle
        cell.usernamelabel.text = mile.username
        cell.detaillabel.text = mile.editTime
        cell.userlabel.text = mile.userID
        cell.textlabel.text = mile.bodyText
        
        
        //프로필 이미지 처리
        cell.MileImage.sd_setImage(with: URL(string:mile.instUserProfileUrl), placeholderImage: UIImage(named:"30. User@3x.png"), options: .retryFailed, completed: { (image, error, cachedType, url) in
            
            
            //이미지캐싱이 안되있을경우에 대한 애니메이션 셋팅_imageView.alpha = 1;
            if cell.MileImage != nil, cachedType == .none {
                
                cell.MileImage?.alpha = 0
                
                UIView.animate(withDuration: 0.2, animations: {
                    cell.MileImage?.alpha = 1
                }, completion: { (finished) in
                    cell.MileImage?.alpha = 1
                })
            }
        })
        
      //  let radius = CGRectGetWidth(cell.MileImage.frame) / 2
        cell.MileImage.layer.cornerRadius = cell.MileImage.frame.size.width/2
        cell.MileImage.layer.masksToBounds = true
        
        cell.accceptbutton.tag = indexPath.row
        cell.rejectbutton.tag = indexPath.row
        
  
        cell.morebt.tag = indexPath.row
        
       
        print(cell.morebt.tag)
        print("morebt.tag")
        
        //more button
        cell.morebt.setImage(UIImage(named: "menu_option [#1374]@2x.png"), for: UIControlState.normal)
        cell.morebt.setTitle("", for: .normal)
        
        
        
        NSLog("[%ld]", cell.accceptbutton.tag)
        
        cell.accceptbutton.setTitle("참석", for: .normal)
        cell.rejectbutton.setTitle("불참", for: .normal)
    //    cell.detailmorebutton.setTitle(nil, for: .normal)
      
 
        return (cell)
        

    
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        
    {
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let vc = UIStoryboard(name: "MileDetail", bundle: nil).instantiateInitialViewController() as! MileStoneDetailViewController
        
        
        
        let mile = miles[indexPath.row]
        vc.mile_detail_title = mile.mileTitle
        vc.mile_time = mile.editTime
        vc.mile_body = mile.bodyText
        vc.mile_user_nm = mile.username
        vc.mile_user_id = mile.userID
        vc.mile_user_profile_url = mile.instUserProfileUrl
        
        vc.title_key = mile.uid
        
     
        // 시작
        showViewController(vc, true, nil)
        
        // 끝
        

        
          NSLog("Click")

        
    }
    

    //show new view

    override func showViewController(_ viewController: UIViewController,_ animated : Bool,_ completion :(() -> Swift.Void)? = nil){
        var activateController = UIApplication.shared.keyWindow?.rootViewController
        
        if(activateController?.isKind(of: UINavigationController.self))!{
            activateController = (activateController as! UINavigationController).visibleViewController
        }else if((activateController?.presentedViewController) != nil){
            activateController = activateController?.presentedViewController
        }
        
        activateController?.present(viewController, animated: animated, completion: completion)
    }
  
    // cell delete, modify
    @IBAction func milemorebutton(_ sender:  UIButton) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        
        //Create and an option action
        let deleteAction: UIAlertAction = UIAlertAction(title: "삭제", style: .default) { action -> Void in
        //Do some other stuff
            let uid = FIRAuth.auth()?.currentUser?.uid
            
            if (uid != self.miles[sender.tag].instUserUid)
            {
                
                let alertController: UIAlertController = UIAlertController(title: nil, message: "본인이 올리신 글만 삭제할수 있습니다.", preferredStyle: .alert)
                
                let cancelAction: UIAlertAction = UIAlertAction(title: "확인", style: .default) { action -> Void in
                    //Do some stuff
                }
                
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }

          
            else {
            
        NSLog("miles.row : %ld", sender.tag)
            self.delete_miledata(childWantToRemove  :  self.miles[sender.tag].uid  )
            
            print(self.miles[sender.tag].uid  )
            print("delete cell uid")
                
            }
        }
        actionSheetController.addAction(deleteAction)
        
        //Create and an option action
        let modifyAction: UIAlertAction = UIAlertAction(title: "수정", style: .default) { action -> Void in
            //Do some other stuff
           
      //      let indexPath = tableView.
            
               let uid = FIRAuth.auth()?.currentUser?.uid
            
            if (uid != self.miles[sender.tag].instUserUid)
            {
                
                   let alertController: UIAlertController = UIAlertController(title: nil, message: "본인이 올리신 글만 수정할수 있습니다.", preferredStyle: .alert)
                
                
                let cancelAction: UIAlertAction = UIAlertAction(title: "확인", style: .default) { action -> Void in
                    //Do some stuff
                }
                
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                
                
            }
            else
            {
            print("tag sender")
            print(sender.tag)
            print(self.miles)
            
            print(self.miles[sender.tag].uid )
            
            
         
              self.modify_milddata(childWantToModify  :  self.miles[sender.tag].uid  )
            
                
            let vc = UIStoryboard(name: "MileCreate", bundle: nil).instantiateInitialViewController() as! MileStoneCreateViewController
            
            print("modify info")
            print(self.MileTitleText)
            print(self.MileTitleText)
            print(self.selectedDate)
            
     
            
            
            
            vc.mtitle = self.miles[sender.tag].mileTitle
            vc.mdetail = self.miles[sender.tag].bodyText
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
             let selectedDate  = dateFormatter.date(from: ( self.miles[sender.tag].editTime ) )
            
           vc.mdate = selectedDate
           vc.moidfy_uid =  self.miles[sender.tag].uid
            

            self.showViewController(vc, true, nil)
            }
            
        }
        
        actionSheetController.addAction(modifyAction)
        
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .default) { action -> Void in
            //Do some stuff
        }
        
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
        
        
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
    
    
    
    // modify mile list database
    func modify_milddata(childWantToModify: String) {
        
        let ref = FIRDatabase.database().reference()
        
        
       print("modyfy11111111")
      print(childWantToModify)

        
     //   ref.child("milelist").child(childWantToModify).observeSingleEvent(of: .value, with : { (snapshot) in

        ref.child("milelist").child(childWantToModify).observeSingleEvent(of: .value,   with: { (snapshot) in
           
        
             print("modyfy22222")
            
            print(snapshot.value)
            
        
            
            let snapshotValue = snapshot.value as! NSDictionary
             let MileTitleText  = snapshotValue["mileTitle"] as? String ?? ""
             let  MildDetailText  = snapshotValue["bodyText"] as? String ?? ""
             let selectedDateString = snapshotValue["editTime"] as? String ?? ""
    
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
             let selectedDate  = dateFormatter.date(from: (selectedDateString))!
            
            
            self.MileTitleText = MileTitleText
            self.MildDetailText = MildDetailText
            self.selectedDate = selectedDate
            
                 print("modyfy info list")
                 print(self.MileTitleText)
               print(self.MildDetailText)
               print(self.selectedDateString)
            //self.selectedDate = dateFormatter.string(from: NSDate() as Date)
            
            

        })
      
        
        
      
        
        // 시작
        
        
    }

    
    //milestone create
    @IBAction func milenewbutton(_ sender: Any) {
        
        let vc = UIStoryboard(name: "MileCreate", bundle: nil).instantiateInitialViewController() as! MileStoneCreateViewController
        
        
        // 시작
        showViewController(vc, true, nil)

        
    }
    
    func celltab(cell: CustomMileStoneViewControllerTableViewCell)
    {
        print(tableView.indexPath(for: cell)?.row)
    }
    
    
    //attend button
    @IBAction func yesbutton(_ sender: UIButton) {
        
        NSLog("yes")
       
        NSLog("yes")
        
        
        NSLog("miles.row : %ld", sender.tag)
        
        
        let actionSheetController: UIAlertController = UIAlertController(title: "참석하시겠습니까?", message: "", preferredStyle: .alert)
    
       
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "참석", style: .default) { action -> Void in
            //Do some other stuff
             self.mileAttendInsert(rownum: sender.tag, attendflag: "Y")
            
        }
        actionSheetController.addAction(nextAction)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .default) { action -> Void in
            //Do some stuff
        }
        
         actionSheetController.addAction(cancelAction)
        
        
        
        self.present(actionSheetController, animated: true, completion: nil)
        
        
        
        
    }

    /*
    func vc_data_setting()
    {
        let vc = UIStoryboard(name: "MileDetail", bundle: nil).instantiateInitialViewController() as! MileStoneDetailViewController
        
        
        
        let mile = miles[indexPath.row]
        vc.mile_detail_title = mile.mileTitle
        vc.mile_time = mile.editTime
        vc.mile_body = mile.bodyText
        vc.mile_user_nm = mile.username
        vc.mile_user_id = mile.userID
        vc.mile_user_profile_url = mile.instUserProfileUrl
        
        vc.title_key = mile.uid
    }
   */
    
    //not attend button
    @IBAction func nobutton(_ sender: UIButton) {

        
        NSLog("no")
        
        NSLog("miles.row : %ld", sender.tag)
        
        let actionSheetController: UIAlertController = UIAlertController(title: "불참하시겠습니까?", message: "", preferredStyle: .alert)
        
        
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "불참", style: .default) { action -> Void in
            //Do some other stuff
            
            self.mileAttendInsert(rownum: sender.tag, attendflag: "N")
            
        }
        actionSheetController.addAction(nextAction)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .default) { action -> Void in
            //Do some stuff
        }
        
        actionSheetController.addAction(cancelAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    // detail button
    @IBAction func detailbutton(_ sender: UIButton) {
        
         NSLog("miles.row : %ld", sender.tag)
        let actionSheetController: UIAlertController = UIAlertController(title: "세부사항", message: self.miles[sender.tag].bodyText, preferredStyle: .alert)
        
    
        //Create and an option action
    
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "확인", style: .default) { action -> Void in
            //Do some stuff
        }
        
        actionSheetController.addAction(cancelAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
        
    
    }
    
    
    
    func viewChange()
    {
        NSLog("체인지")
        self.navigationController?.pushViewController(MileStoneDetailViewController(), animated: false)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
        
        // Dispose of any resources that can be recreated.
    }
    
    
    func createView(){
        
      //   self.main_title_label.text = "MileStoneList"
 
 
    }
    private let rangeOfPosts : UInt = 10
    let ref = FIRDatabase.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let  mile_data = MileObject.init()
        
        print(mile_data.userName!)
        
        miles = [Mile]()
        user_info()
        
       
        navigationItem.rightBarButtonItem = composeBarButtonItem
        navigationItem.leftBarButtonItem = homeBarButtonItem
        
        // 네비게이션 바를 추가한다.
        let naviBar = UINavigationBar()
        naviBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64)
        naviBar.items = [navigationItem]
        naviBar.barTintColor = .white
        
        self.view.addSubview(naviBar)
        
        DispatchQueue.main.async{
            self.loadTable()
            
        }
        self.tableView.reloadData()
    }
    
    
    // user Attend Value insert
    func mileAttendInsert(rownum: Int, attendflag: String)
    {
        let someMileAttnendData = MILEATTEND()
        
        
        
        someMileAttnendData.userID = miles[rownum].userID
        someMileAttnendData.userName = miles[rownum].username
        someMileAttnendData.mileTitle = miles[rownum].mileTitle
  
        
        var attendFlag : Bool
        if(attendflag == "Y")
        {
            attendFlag = true
        }
        else{
            attendFlag = false
        }
        
        
        let ref = FIRDatabase.database().reference()
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
      

        if(attendFlag == true)
        {
            self.userinfo_ins(milelist_uid:  self.miles[rownum].uid, attendFlag:  "1", rownum: rownum)
        }
        else
        {
            self.userinfo_ins(milelist_uid:  self.miles[rownum].uid, attendFlag: "0", rownum:  rownum)
        }
        
    }

    func attend_cnt_ins(milelist_uid: String,  attendFlag: String) {
        
        
    }
    
    
    
    func userinfo_ins(milelist_uid: String,  attendFlag: String, rownum: Int) {
        
        
         let ref1 = FIRDatabase.database().reference()

        var key : String
        
        key   = self.user.uid
       
        let mileuser = [
         
            "userName": self.user.userName,
            "userEmail": self.user.userEmail,
            "uid": key,
            "attendFlag": attendFlag,
            "profile_url": self.user.profile_url]as [String : Any]
        let mileUpdates = ["/milelist/\(milelist_uid)/mileAttend/\(key)": mileuser]
        //   "/milelist/\(someMileCreateData.id)/\(key)/": milelist]
        ref1.updateChildValues(mileUpdates)
        print("print user update!!!")

        
        
        
        
        let vc = UIStoryboard(name: "MileDetail", bundle: nil).instantiateInitialViewController() as! MileStoneDetailViewController
        
        
        
        let mile = miles[rownum]
        
        vc.mile_detail_title = mile.mileTitle
        vc.mile_time = mile.editTime
        vc.mile_body = mile.bodyText
        vc.mile_user_nm = mile.username
        vc.mile_user_id = mile.userID
        vc.mile_user_profile_url = mile.instUserProfileUrl
        
        vc.title_key = mile.uid
        
           // 시작
        showViewController(vc, true, nil)
        
        
        
        
    }
    
    func user_info() {
        
        
        let ref = FIRDatabase.database().reference()
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with:  { (snapshot) in
            
            print("user value")
            print(snapshot.value)
            
            let snapshotValue = snapshot.value as! NSDictionary
            self.user.userEmail  = snapshotValue["email"] as? String ?? ""
            self.user.userName  = snapshotValue["userName"] as? String ?? ""
            self.user.profile_url  = snapshotValue["profile_url"] as? String ?? ""
            self.user.uid  = uid!
            
            print("user value3333")
            print(self.user.userEmail)
            print(self.user.userName)
        })
        
        
    }

    
    
    
    // table data setting
    func loadTable()
    {
        
        
      //  let  milelist = MileObject.init()
        var tempList : Array<Any>! = nil
    
        
        /*
        let ref = FIRDatabase.database().reference()
        _=ref.child("milelist").observe(.value, with: {snapshot in
            print(snapshot.value)
         })
        */
    
         
         let ref = FIRDatabase.database().reference()
        
        //let ref = FIRDatabase.database()
        
        ref.child("milelist").runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = FIRAuth.auth()?.currentUser?.uid {
                var mileats : Dictionary<String, Bool>
                mileats = post["mileattend"] as? [String : Bool] ?? [:]
                var mileCount = post["mileCount"] as? Int ?? 0
               
                
               print(post)
               print(uid)
               print(mileats)
               print(mileCount)
                
                
                // Set value and report transaction success
                currentData.value = post
                
                return FIRTransactionResult.success(withValue: currentData)
            }
            return FIRTransactionResult.success(withValue: currentData)
        })
        { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }

        
        
        _=ref.child("milelist").observe(.childAdded, with: {[weak self] snapshot in
            //    guard let wself = self else {return}
            print(snapshot.value)
            let mile = Mile(snapshot: snapshot)
            self?.miles.append(mile)
            
            DispatchQueue.main.async{
               // self?.tableView.endUpdates()
                self?.tableView.reloadData()
            }
        })
        
        
         _=ref.child("milelist").observe(.childRemoved, with: {[weak self] snapshot in
         //    guard let wself = self else {return}
         print(snapshot.value)
         let mile = Mile(snapshot: snapshot)
         if let removetindex=self?.miles.index(of: mile){
         self?.tableView.beginUpdates()
         self?.miles.remove(at:removetindex)
         self?.tableView.deleteRows(at: [IndexPath(row:removetindex, section: 0)], with:.left )            }
           self?.tableView.endUpdates()
            
         DispatchQueue.main.async{
       
             self?.tableView.reloadData()
         }
            
         })
         
        
        
        
    }

}
