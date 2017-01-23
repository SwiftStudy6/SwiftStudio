//
//  MainViewController.swift
//  SwiftStudio
//
//  Created by David June Kang on 2016. 12. 31..
//  Copyright © 2016년 ven2s.soft. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import SDWebImage

private let reuseIdentifier = "BoardCell"
private let reuseIdentifier2 = "NoticeCell"

//Define Model Of Board
class BoardObject : NSObject {
    
    var boradKey        : String?       //Board uique Key
    var authorId        : String?       //Author Id(userId)
    var authorName      : String?       //Author Name
    var profileImgUrl   : String?       //Author Profile Url by string
    var profileImg      : UIImage?      //Author Profile Image
    var bodyText        : String?       //Board Body Text
    var editTime        : String?       //Board Edited Time yyyy/MM/dd hh:mm
    
    //init each
    init(_ boardNum: String, _ authorId: String, _ authorName: String, _ profileImgUrl: String, _ bodyText : String, _ editTime : String){
        self.boradKey = boardNum
        self.authorId = authorId
        self.authorName = authorName
        self.profileImgUrl = profileImgUrl
        
        if !profileImgUrl.isEmpty {
            let imageView = UIImageView()
            imageView.sd_setImage(with: URL(string: profileImgUrl))
            
            self.profileImg = imageView.image
        }

        self.bodyText = bodyText
        self.editTime = editTime
    }
    
    
    //init each
    init(_ boardNum: String, _ authorId: String, _ authorName: String, _ profileImgUrl: String, _ profileImg: UIImage, _ bodyText : String, _ editTime : String){
        self.boradKey = boardNum
        self.authorId = authorId
        self.authorName = authorName
        self.profileImg = profileImg
        self.profileImgUrl = profileImgUrl
        self.bodyText = bodyText
        self.editTime = editTime
    }

    //inin with json
    init(_ json:Any){
        let json = JSON(json)
        
        self.boradKey = json["boardNo"].string
        self.authorId   = json["userId"].string
        self.authorName = json["userName"].string
        if let url = json["profileUrl"].string {
            let imageView = UIImageView()
            imageView.sd_setImage(with: URL(string: url))
            
            self.profileImg = imageView.image
        }
        
        self.bodyText = json["bodyText"].string
        self.editTime = json["editTime"].string
    }
    
    convenience override init(){
        let replaceHolderImg = UIImage(named: "user.png")
        self.init("", "", "", "" , replaceHolderImg!, "" , "")
    }
    
    func objectToNSDic() -> NSDictionary {
        let dic : NSDictionary! =  nil
        
        dic.setValue(self.authorName, forKey: "name")
        dic.setValue(self.authorId, forKey: "uid")
        
        return dic
    }
    
 
    func isEqualObject(_ obj : BoardObject) -> Bool {
            if (self.boradKey != obj.boradKey) {
                return false
            }
            if(self.authorId != obj.authorId){
                return false
            }
            if(self.authorName != obj.authorName) {
            
            }
            if(self.profileImgUrl != obj.profileImgUrl) {
                return false
            }
            if(self.profileImg != obj.profileImg) {
                return false
            }

            if(self.bodyText != obj.bodyText) {
                return false
            }
        
            if(self.editTime != obj.editTime) {
                return false
            }

            return true
    }


}

protocol BoardCellDelegate  {
    func editButtonEvent(sender:UIButton, cell : BoardCell)
    func likeButtonEvent(sender:UIButton, cell : BoardCell)
    func replyButtonEvent(sender:UIButton, cell : BoardCell)
    func shareButtonEvent(sender:UIButton, cell : BoardCell)
}

//Board Cell Definition
class BoardCell : UICollectionViewCell {
    
    
    var key          : String! = nil                  //Board Key
    var authorId     : String! = nil                //Board Writer Id(User Id)
    var userImage    : UIImageView! = nil           //Profile image
    var authorName   : UILabel? = nil               //Username
    var editTime     : UILabel? = nil               //Edited time
    var textRecorded : UITextView? = nil            //Text
    
    var delegate     : BoardCellDelegate? = nil     //BoardCellDelegate Object
    
    var dataObject   : BoardObject! {
       
        set(newValue){
            self.key = newValue.boradKey
            self.authorName?.text = newValue.authorName
            self.authorId = newValue.authorId
            self.userImage.image = newValue.profileImg
            self.textRecorded?.text = newValue.bodyText
            self.editTime?.text = newValue.editTime
        }
        
        get{
            let returnVal : BoardObject! = nil
            
            returnVal.boradKey = self.key
            returnVal.authorId   = self.authorId
            returnVal.authorName = self.authorName?.text
            returnVal.bodyText = self.textRecorded?.text
            returnVal.profileImg = self.userImage.image
            returnVal.editTime = self.editTime?.text
            
            return returnVal
        }
    }
    
    var indexPath : IndexPath!
    
        override init(frame: CGRect){
        super.init(frame:frame)
        setSetting()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //View setting
    func setSetting(){
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.darkGray.cgColor
        self.contentView.layer.masksToBounds = true
        
        //Userinfo
        let userInfoView = UIView()
        userInfoView.backgroundColor = .white
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(userInfoView)
        
        userInfoView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        userInfoView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        userInfoView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
        userInfoView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        //settting userImage
        self.userImage = UIImageView()
        self.userImage.image = UIImage(named: "User")
        self.userImage.translatesAutoresizingMaskIntoConstraints = false
        self.userImage.layer.masksToBounds = true;
        self.userImage.layer.cornerRadius = 18
        self.userImage.layer.borderWidth = 2
        self.userImage.layer.borderColor = UIColor.black.cgColor
        
        
        userInfoView.addSubview(self.userImage)
        
        self.userImage.leftAnchor.constraint(equalTo: userInfoView.leftAnchor, constant: 9).isActive = true
        self.userImage.topAnchor.constraint(equalTo: userInfoView.topAnchor, constant: 12).isActive = true
        self.userImage.widthAnchor.constraint(equalToConstant: 36).isActive = true
        self.userImage.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        
        //setting editButton
        let editButton = UIButton()
        
        editButton.setImage(UIImage(named: "More"), for: .normal)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.addTarget(self, action: #selector(editButtonTouchUpinside), for: .touchUpInside)
        
        userInfoView.addSubview(editButton)
        
        editButton.rightAnchor.constraint(equalTo: userInfoView.rightAnchor, constant: -12).isActive = true
        editButton.topAnchor.constraint(equalTo: userInfoView.topAnchor, constant: 12).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 26).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 26).isActive = true


        //setting UserName
        self.authorName = UILabel()
        self.authorName?.textAlignment = .left
        self.authorName?.font = UIFont.boldSystemFont(ofSize: 14)
        self.authorName?.textColor = .black
        
        userInfoView.addSubview(self.authorName!)
        
        self.authorName?.translatesAutoresizingMaskIntoConstraints = false
        self.authorName?.leftAnchor.constraint(equalTo: (self.userImage?.rightAnchor)!, constant: 8.5).isActive = true
        self.authorName?.topAnchor.constraint(equalTo: userInfoView.topAnchor, constant: 11).isActive = true
        self.authorName?.rightAnchor.constraint(equalTo: editButton.leftAnchor, constant: -8.5).isActive = true
        self.authorName?.heightAnchor.constraint(equalToConstant: 17).isActive = true
      
        
        
        //settting editTime (yyyy년 MM월 dd일 hh시 mm분
        self.editTime = UILabel()
        self.editTime?.textAlignment = .left
        self.editTime?.font = UIFont.systemFont(ofSize: 11)
        self.authorName?.textColor = .black

        userInfoView.addSubview(self.editTime!)
        
        self.editTime?.translatesAutoresizingMaskIntoConstraints = false
        self.editTime?.leftAnchor.constraint(equalTo: (self.userImage?.rightAnchor)!, constant: 8.5).isActive = true
        self.editTime?.topAnchor.constraint(equalTo: (self.authorName?.bottomAnchor)!, constant: 2.3).isActive = true
        self.editTime?.rightAnchor.constraint(equalTo: editButton.leftAnchor, constant: -8.5).isActive = true
        self.editTime?.heightAnchor.constraint(equalToConstant: 17).isActive = true
        
        
        //setting body Text Area
        self.textRecorded = UITextView()
        self.textRecorded?.font = UIFont.systemFont(ofSize: 13)
        self.textRecorded?.isUserInteractionEnabled = false
        self.contentView.addSubview(self.textRecorded!)
        
        self.textRecorded?.translatesAutoresizingMaskIntoConstraints = false
        self.textRecorded?.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12).isActive = true
        self.textRecorded?.topAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: 4).isActive = true
        self.textRecorded?.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -12).isActive = true
        self.textRecorded?.heightAnchor.constraint(equalToConstant: 165).isActive = true
        
        //setting bottom view
        let bottomView = UIView()
        //bottomView.backgroundColor = .gray
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(bottomView)
        
        bottomView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        bottomView.topAnchor.constraint(equalTo: (self.textRecorded?.bottomAnchor)!, constant: 3).isActive = true
        bottomView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        //add like button
        let likeButton = UIButton()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setTitle("좋아요", for: .normal)
        likeButton.setTitleColor(.black, for: .normal)
        likeButton.titleLabel?.font = .systemFont(ofSize: 12)
        likeButton.addTarget(self, action: #selector(likeButtonTouchUpInside(_:)), for: .touchUpInside)
        likeButton.contentVerticalAlignment = .center
        likeButton.contentHorizontalAlignment = .center
        
        //likeButton.backgroundColor = .blue
  
        bottomView.addSubview(likeButton)
        
        likeButton.leftAnchor.constraint(equalTo: bottomView.leftAnchor).isActive = true
        likeButton.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: self.contentView.frame.width/3).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        //add reply button
        let replyButton = UIButton()
        replyButton.setTitle("댓글달기", for: .normal)
        replyButton.setTitleColor(.black, for: .normal)
        replyButton.titleLabel?.font = .systemFont(ofSize: 12)
        replyButton.translatesAutoresizingMaskIntoConstraints = false
        replyButton.addTarget(self, action: #selector(replyButtonTouchUpInside(_:)), for: .touchUpInside)
        replyButton.contentVerticalAlignment = .center
        replyButton.contentHorizontalAlignment = .center
    
        //replyButton.backgroundColor = .red
        
        bottomView.addSubview(replyButton)
        
        replyButton.leftAnchor.constraint(equalTo: likeButton.rightAnchor).isActive = true
        replyButton.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        replyButton.widthAnchor.constraint(equalToConstant: self.contentView.frame.width/3).isActive = true
        replyButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        //add reply button
        let shareButton = UIButton()
        shareButton.setTitle("공유하기", for: .normal)
        shareButton.setTitleColor(.black, for: .normal)
        shareButton.titleLabel?.font = .systemFont(ofSize: 12)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.addTarget(self, action: #selector(shareButtonTouchUpInside(_:)), for: .touchUpInside)
        shareButton.contentVerticalAlignment = .center
        shareButton.contentHorizontalAlignment = .center
        //shareButton.backgroundColor = .green
        
        bottomView.addSubview(shareButton)
        
        shareButton.leftAnchor.constraint(equalTo: replyButton.rightAnchor).isActive = true
        shareButton.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: self.contentView.frame.width/3).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        

        
    }
    
    
    //Button Delegate Fucniton
    @IBAction func editButtonTouchUpinside(_ sender:UIButton){
        self.delegate?.editButtonEvent(sender:sender, cell: self)
    }
    
    @IBAction func likeButtonTouchUpInside(_ sender:UIButton){
        self.delegate?.likeButtonEvent(sender: sender, cell: self)
    }
    
    @IBAction func replyButtonTouchUpInside(_ sender:UIButton){
        self.delegate?.replyButtonEvent(sender:sender, cell: self)
    }
    
    @IBAction func shareButtonTouchUpInside(_ sender:UIButton){
        self.delegate?.shareButtonEvent(sender: sender, cell: self)
    }
    
}

class NoticeCell : UICollectionViewCell {
    let key : String? = nil
    var textLabel : UILabel? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        textLabel = {
            let _label = UILabel()
            _label.isUserInteractionEnabled = false
            _label.translatesAutoresizingMaskIntoConstraints = false
            
            
            
            return _label
        }()
        
        
        self.contentView.addSubview(textLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NoticeCell init(coder:) has not been implemented")
    }
}




/*************************************************************************************
 * Board Start
 *************************************************************************************/

//Definition Class MainViewController
class MainViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, BoardCellDelegate {
    
    private var ref : FIRDatabaseReference!
    private var data : String!
    private var boardRef : FIRDatabaseReference! = FIRDatabase.database().reference().child("Board-Posts")
    private var noticeRef : FIRDatabaseReference! = FIRDatabase.database().reference().child("Notice-Posts")
    
    private let rangeOfPosts : UInt = 100
    private var pageOfPosts  : UInt = 1
    
    var titleString : String! = nil
    
    lazy var composeBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.navToWriteHandle))
        
        return button
    }()
    
    //데이터 리스트
    var boardList : Array<Any>! = nil
    var noticeList : Array<Any>! = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        if(self.titleString == nil){
            self.titleString = "메인"
        }
        
        navigationItem.title = self.titleString
        navigationItem.rightBarButtonItem = composeBarButtonItem
        
        // 네비게이션 바를 추가한다.
        let naviBar = UINavigationBar()
        naviBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70)
        naviBar.items = [navigationItem]
        naviBar.barTintColor = .white
        
        
        self.view.addSubview(naviBar)
    
        
        self.ref = FIRDatabase.database().reference()
        
        // Register cell classes
        self.collectionView!.register(BoardCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier2)
        
        //Setting View
        self.view.backgroundColor = .white
        self.collectionView?.backgroundColor = .white
        
        self.collectionView?.frame = CGRect(x: 0, y: 70, width: self.view.frame.width, height: (self.collectionView?.frame.height)!-70)
    
       
       
    }
    
    
    //불러운 포스트 개수를 배열에 추가한다. (100 * x)
    func loadOfPosts(_ pageCount : UInt){
        boardRef.queryLimited(toFirst: rangeOfPosts * pageCount).observeSingleEvent(of: .value, with: {(snapshot) in
            guard !snapshot.exists() else {
                return
            }
            
            var tempList : Array<Any>! = nil
            
            let enumerate = snapshot.children
            while let rest = enumerate.nextObject()  as? FIRDataSnapshot {
                var dict = rest.value as! [String : Any]
                var obj : BoardObject! = nil
                obj.boradKey = rest.key
                obj.bodyText = dict["bodyText"] as! String?
                
                let userObj = dict["author"] as! [String : Any]
                obj = BoardObject(rest.key,
                                  userObj["uid"] as! String,
                                  userObj["name"] as! String,
                                  userObj["imgUrl"] as! String,
                                  dict["bodyText"] as! String,
                                  dict["editTime"] as! String)
                
                
                tempList.append(obj)
            }
            
            //기존 대상과 비교하여 있는 경우 해당 부분을 삭제
            var i = 0
            var j = 0
            for board in self.boardList {
                for temp in tempList {
                    if (board as! BoardObject).isEqualObject(temp as! BoardObject) {
                       tempList.remove(at: j)
                    }
                    j = j + 1
                }
                i = i + 1
            }
            
            if(self.boardList.count > 0){
                self.collectionView?.reloadData()
            }
        })
    }
    
    //초기 불러오기 이벤트
    func loadEvent(){
        //게시판 내용 불러오기
        loadOfPosts(self.pageOfPosts)
        
        //공지사항을 불러온다
        noticeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard !snapshot.exists() else{
                return
            }
            
            
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                let key = rest.key
                
                var noticeDict = rest.value as! [String : Any]
                noticeDict["key"] = key
                
                self.noticeList.append(noticeDict)
            }
            
            if(self.noticeList.count > 0){
                
            }
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    
    func dataSetting(){
        
        
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        if(section == 0){
            return self.noticeList.count
        } else if (section == 1) {
            return self.boardList.count
        }else{
            return 3
        }
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //공지사항을 위한 cell
        if(indexPath.section == 0){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier2, for: indexPath) 
            
            
            
            
            return cell
        
        //일반적인 게시물을 위한 cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BoardCell
            let boardObj = self.boardList[indexPath.row] as! BoardObject
            
            cell.dataObject = boardObj
            
            cell.indexPath = indexPath
            
            cell.delegate = self
            return cell
        }
    }

    
    // MARK : BoardCellDelegate
    
    //Edit Button
    func editButtonEvent(sender: UIButton, cell : BoardCell) {
        
        let boardKey = cell.key
        let noticeRef = ref.child("notice-posts")
        
        let user = FIRAuth.auth()?.currentUser

        let authorId = cell.authorId
        
        
        
        
        let alertController = UIAlertController(title: "게시물 수정", message: nil, preferredStyle: .actionSheet)
     
        
        let addNoticeAction = UIAlertAction(title: "공지사항 등록", style: .default) { (Void) in
            
            let noticeKey = boardKey!
            let data : [String : Any] = ["authorId":authorId!,
                                         "text": cell.textRecorded!.text,
                                         "time": FIRServerValue.timestamp()]
            
            noticeRef.setValue(["\(noticeKey)":data])
        }
        
        let delNoticeAction = UIAlertAction(title: "공지사항 내리기", style: .default) { (Void) in
            noticeRef.child(boardKey!).removeValue()
            
            noticeRef.observeSingleEvent(of: .childRemoved, with: { (snapshot) in
                guard !snapshot.exists() else{
                    return
                }
                
                let deleteKey = snapshot.key
                if(boardKey == deleteKey){
                    self.collectionView?.deleteItems(at: [cell.indexPath])
                    self.noticeList.remove(at: cell.indexPath.row)
                }
            })
            
        }
        
        let editAction = UIAlertAction(title: "글 수정", style: .default) { (Void) in
            
        }
        let delAction = UIAlertAction(title: "글 삭제", style: .destructive) { (Void) in
           
            if(user?.uid == authorId){
                //TODO : change DelYn
                
            }
            
        }
        
        
        alertController.addAction(addNoticeAction)
        alertController.addAction(delNoticeAction)
        
        
        if(user?.uid == authorId){
            alertController.addAction(editAction)
            alertController.addAction(delAction)
        }
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //Like Button
    func likeButtonEvent(sender: UIButton, cell : BoardCell) {
        //code
    }
    
    //Reply Button
    func replyButtonEvent(sender: UIButton, cell : BoardCell) {
//        let vc = UIStoryboard(name: "BoardDetail", bundle: nil).instantiateInitialViewController() as! BoardDetailController
//        
//        navigationController?.pushViewController(vc, animated: true)
        
        //code
//        let boardDetailController = UIViewController()
//        let navigationController = UINavigationController(rootViewController: boardDetailController)
//        
//        self.view.window?.rootViewController?.present(navigationController, animated: true, completion: nil)
        
    }
    
    //Share Button
    func shareButtonEvent(sender: UIButton, cell : BoardCell) {
        //code
        let alertController = UIAlertController(title: "공유", message: nil, preferredStyle: .actionSheet)
        
        let cancleAction = UIAlertAction(title: "택스트내용 복사", style: .cancel, handler:{ (Void) in
            UIPasteboard.general.string = cell.textRecorded?.text
        })
        
        alertController.addAction(cancleAction)
        
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width-30, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = UIStoryboard(name: "BoardDetail", bundle: nil).instantiateInitialViewController() as! BoardDetailController
//        
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    func navToWriteHandle(){
        //게시판생성뷰 이동
        
//        let vc = UIStoryboard(name: "BoardCreate", bundle: nil).instantiateInitialViewController() as! BoardCreateViewController
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    

}

extension NSDate {
    
    func toString() -> String {
        
        let formater = DateFormatter()
        formater.amSymbol = "오전"
        formater.pmSymbol = "오후"
        formater.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분 ss초 "
        
        
        return formater.string(from: self as Date)
    }
    
    func toString(_ format:String?) -> String {
        
        let formater = DateFormatter()
        formater.amSymbol = "오전"
        formater.pmSymbol = "오후"
        formater.dateFormat = format ?? "yyyy년 MM월 dd일 a hh시 mm분 ss초 "
        
        
        return formater.string(from: self as Date)
    }
}
