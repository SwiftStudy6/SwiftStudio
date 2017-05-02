//
//  MileStoneDetailViewController.swift
//  SwiftStudio
//
//  Created by 홍대호 on 2017. 
//  Copyright © 2017년 swift. All rights reserved.


import Foundation
import UIKit
import Firebase
import SDWebImage

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
    //abcd
    
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
    var profile_url :String?
}




class MileStoneDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {
   

  

    


    
    lazy var homeBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "Home"), style: .plain, target: self, action: #selector(self.back))
        
        return button
    }()
    
 
    
    
    let  mile_detail_list = ["참석", "참석", "불참"]
    
    @IBOutlet weak var mainlabel: UILabel!
    
    @IBOutlet weak var acceptlabel: UILabel!
    
    @IBOutlet weak var nonattendlabel: UILabel!
    
    @IBOutlet weak var attend_count: UILabel!
    
    @IBOutlet weak var nonattend_count: UILabel!
    
    

    
    
    @IBOutlet weak var timelabel: UILabel!
    
    @IBOutlet weak var bodytext: UITextView!
    
    @IBOutlet weak var milecreat_user_img: UIImageView!
    
    @IBOutlet weak var milecreat_user_nm: UILabel!
    
    @IBOutlet weak var milecreate_user_id: UILabel!
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var collectionA: UICollectionView!
    
    @IBOutlet weak var collectionB: UICollectionView!
    
    
    var title_key :String?
    
   //var mileAttend = [USERATTEND]()
    var mile_user = [USERATTEND]()
    var  mile_user_2 = [USERATTEND]()

    
    var mile_user_nm : String!
    var mile_user_id  : String!
    var mile_user_profile_url : String!
    
    var mile_detail_title: String!
    var mile_time: String!
    var mile_body:String!
    var mileattends = [MILEATTEND1]()
    var attend : Int = 0
    var absent : Int = 0
    var textcontent : String! = nil
    
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
  var count = 0
        
        if collectionView == self.collectionA
        {
        count =  mile_user.count
        return count
        }
        
        else if collectionView == self.collectionB
        {
        count =  mile_user_2.count
       return count
        }
        
        else
        {
        count = 1
        return count
        }
        //return count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        if collectionView == self.collectionA {
            
            let cellA = collectionA.dequeueReusableCell(withReuseIdentifier: "CollectionViewACell", for: indexPath) as! customcellA
            
            // Set up cell
            
            print("mile_user.count  ")
            print(mile_user.count )
            
           if(self.attend > 0)
           {
            
            let mind = mile_user[indexPath.row]
            cellA.userName.text = mind.user_nm
            cellA.userImage.sd_setImage(with: URL(string:mind.profile_url!), placeholderImage: UIImage(named:"30. User@3x.png"), options: .retryFailed, completed: { (image, error, cachedType, url) in
                
                
                //이미지캐싱이 안되있을경우에 대한 애니메이션 셋팅_imageView.alpha = 1;
                if cellA.userImage != nil, cachedType == .none {
                    
                    cellA.userImage?.alpha = 0
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        cellA.userImage?.alpha = 1
                    }, completion: { (finished) in
                        cellA.userImage?.alpha = 1
                    })
                }
            })
            
            cellA.userImage.layer.cornerRadius = cellA.userImage.frame.size.width/2
            cellA.userImage.layer.masksToBounds = true
            
            }
            return cellA
        }
            
        else {
            let cellB = collectionB.dequeueReusableCell(withReuseIdentifier: "CollectionViewBCell", for: indexPath) as! customcellB
            
            // ...Set up cell
            
            
            print("mile_user_2.count  ")
            print(mile_user_2.count )
            
           if(self.absent > 0)
           {
           
            let mind2 = mile_user_2[indexPath.row]
            cellB.userName.text = mind2.user_nm
            cellB.userImage.sd_setImage(with: URL(string:mind2.profile_url!), placeholderImage: UIImage(named:"30. User@3x.png"), options: .retryFailed, completed: { (image, error, cachedType, url) in
                
                
                //이미지캐싱이 안되있을경우에 대한 애니메이션 셋팅_imageView.alpha = 1;
                if cellB.userImage != nil, cachedType == .none {
                    
                    cellB.userImage?.alpha = 0
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        cellB.userImage?.alpha = 1
                    }, completion: { (finished) in
                        cellB.userImage?.alpha = 1
                    })
                }
            })
            
            cellB.userImage.layer.cornerRadius = cellB.userImage.frame.size.width/2
            cellB.userImage.layer.masksToBounds = true
            
            }
            
            return cellB
        }
        /*
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewBCell", for: indexPath as IndexPath) as!
        customcellA

        return cell
 */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.mainlabel.text = "MileDetail List"
        self.mainlabel.text = mile_detail_title
        self.timelabel.text = mile_time
        self.bodytext.text = mile_body
        self.milecreat_user_nm.text = mile_user_nm
        self.milecreate_user_id.text = mile_user_id
        
        
        self.milecreat_user_img.sd_setImage(with: URL(string:self.mile_user_profile_url), placeholderImage: UIImage(named:"30. User@3x.png"), options: .retryFailed, completed: { (image, error, cachedType, url) in
            
            
            //이미지캐싱이 안되있을경우에 대한 애니메이션 셋팅_imageView.alpha = 1;
            if self.milecreat_user_img != nil, cachedType == .none {
                
                self.milecreat_user_img?.alpha = 0
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.milecreat_user_img?.alpha = 1
                }, completion: { (finished) in
                    self.milecreat_user_img?.alpha = 1
                })
            }
        })
        
        self.milecreat_user_img.layer.cornerRadius = self.milecreat_user_img.frame.size.width/2
        self.milecreat_user_img.layer.masksToBounds = true

        
        
        
        
        self.acceptlabel.text = "참석"
        
         self.nonattendlabel.text = "불참"
     
        // collectionViewB.delegate = self
       //  collectionViewB.dataSource = self
        
        
        NSLog("detail printing")
        
        //navigationItem.title = self.titleString
        //navigationItem.rightBarButtonItem = composeBarButtonItem
        navigationItem.leftBarButtonItem = homeBarButtonItem
        
        // 네비게이션 바를 추가한다.
        let naviBar = UINavigationBar()
        naviBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64)
        naviBar.items = [navigationItem]
        naviBar.barTintColor = .white
        
        self.view.addSubview(naviBar)
        
           self.loadTable_1()
        
           self.collectionA.reloadData()
           self.collectionB.reloadData()
    }
     func attendCnt()
     {
       
    }
    
    
    
    
    let test_image = ["user", "user", "user"]
    
    
    
    
    
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
    
    
    
    override func showViewController(_ viewController: UIViewController,_ animated : Bool,_ completion :(() -> Swift.Void)? = nil){
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
        
       
        print("title_key")
        print(title_key!)
        print(mile_detail_title)
        
    
        
        let ref = FIRDatabase.database().reference().child("milelist").child(title_key!).child("mileAttend")
   
        ref.observe(.childAdded, with: {[weak self] snapshot in
          
            print("snapshot.value ")
            
            print(snapshot.value )
      
            
            
            
            
            let snapshotValue = snapshot.value as! NSDictionary
            
            print("snapshot.attendFlag ")
            print(snapshotValue["attendFlag"] )
            
            let  attendlists = USERATTEND()
            let  nonattendlists = USERATTEND()
            
            let tmp_attendflag = snapshotValue["attendFlag"] as? String ?? ""
            
            
            if(tmp_attendflag == "1")
            {
            attendlists.user_email = snapshotValue["userEmail"] as? String ?? ""
            attendlists.user_nm = snapshotValue["userName"] as? String ?? ""
            attendlists.uid = snapshotValue["uid"] as? String ?? ""
            attendlists.attend_yn = snapshotValue["attendFlag"] as? String ?? ""
            attendlists.profile_url = snapshotValue["profile_url"] as? String ?? ""
            }
            else
            {
            nonattendlists.user_email = snapshotValue["userEmail"] as? String ?? ""
            nonattendlists.user_nm = snapshotValue["userName"] as? String ?? ""
            nonattendlists.uid = snapshotValue["uid"] as? String ?? ""
            nonattendlists.attend_yn = snapshotValue["attendFlag"] as? String ?? ""
            nonattendlists.profile_url = snapshotValue["profile_url"] as? String ?? ""
            }
            
            if( attendlists.attend_yn  == "1" )
            {
                self?.attend  +=  1
                print("self?.absent ")
                print(self?.absent )
                
            }
            
            if( nonattendlists.attend_yn  == "0" )
            {
                self?.absent   +=  1
                print("self?.attend ")
                print(self?.attend )
            }
            
            
            
            
            let attedString :String? = String( describing: self?.attend  )
            let absentString :String? = String( describing: self?.absent  )
            
        
            
            
            print("attendlists")
            var String1 :String
            var String2 : String
            
            //     String1 = attedString
            //     String2 = absentString
            
            
            self?.mile_user.append(attendlists)
            self?.mile_user_2.append(nonattendlists)
            
            NSLog("append")
            DispatchQueue.main.async{
                // self?.tableView.endUpdates()
                self?.collectionA.reloadData()
                 self?.collectionB.reloadData()
                self?.attend_count.text = NSNumber(value: (self?.attend)!).stringValue
                self?.nonattend_count.text = NSNumber(value: (self?.absent)!).stringValue
                
                
            }
            }
        )
        
    }

    
}

class customcellA: UICollectionViewCell
{
    var indexPath       : IndexPath?    //Notice indexPath
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
}



class customcellB: UICollectionViewCell
{
    var indexPath       : IndexPath?    //Notice indexPath

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!

}




