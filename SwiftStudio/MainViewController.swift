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
            let returnVal = BoardObject()
            
            returnVal.boradKey   = self.key
            returnVal.authorId   = self.authorId
            returnVal.authorName = self.authorName?.text
            returnVal.bodyText   = self.textRecorded?.text
            returnVal.profileImg = self.userImage.image
            returnVal.editTime   = self.editTime?.text
            
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
        self.contentView.backgroundColor = .white
        
        
        let innerView = UIView(frame:CGRect.zero)
        innerView.translatesAutoresizingMaskIntoConstraints = false
        
        //innerView.backgroundColor = .gray
        
        self.contentView.addSubview(innerView)
        
        innerView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 15).isActive = true
        innerView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        innerView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -30).isActive = true
        innerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        
        
        //Userinfo
        let userInfoView = UIView()
        userInfoView.backgroundColor = .white
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        innerView.addSubview(userInfoView)
        
        userInfoView.leftAnchor.constraint(equalTo: innerView.leftAnchor).isActive = true
        userInfoView.topAnchor.constraint(equalTo: innerView.topAnchor).isActive = true
        userInfoView.widthAnchor.constraint(equalTo: innerView.widthAnchor).isActive = true
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
        
        self.userImage.leftAnchor.constraint(equalTo: userInfoView.leftAnchor).isActive = true
        self.userImage.topAnchor.constraint(equalTo: userInfoView.topAnchor, constant: 10).isActive = true
        self.userImage.widthAnchor.constraint(equalToConstant: 38).isActive = true
        self.userImage.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        
        //setting editButton
        let editButton = UIButton()
        
        editButton.setImage(UIImage(named: "More"), for: .normal)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.addTarget(self, action: #selector(editButtonTouchUpinside), for: .touchUpInside)
        
        userInfoView.addSubview(editButton)
        
        editButton.rightAnchor.constraint(equalTo: userInfoView.rightAnchor).isActive = true
        editButton.topAnchor.constraint(equalTo: userInfoView.topAnchor, constant: 12).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 11).isActive = true
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
        self.textRecorded?.heightAnchor.constraint(equalToConstant: 164).isActive = true
        
        //setting bottom view
        let bottomView = UIView()
        //bottomView.backgroundColor = .gra
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        innerView.addSubview(bottomView)
        
        bottomView.leftAnchor.constraint(equalTo: innerView.leftAnchor).isActive = true
        bottomView.topAnchor.constraint(equalTo: (self.textRecorded?.bottomAnchor)!, constant: 3).isActive = true
        bottomView.widthAnchor.constraint(equalTo: innerView.widthAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        //lineView
        let lineView = UIView()
        let color = UIColor.darkGray.withAlphaComponent(0.3)
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomView.addSubview(lineView)
        
        lineView.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        lineView.leftAnchor.constraint(equalTo: bottomView.leftAnchor).isActive = true
        lineView.widthAnchor.constraint(equalTo: bottomView.widthAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let offsetWidth = self.contentView.frame.width - 30
        
        //add like button
        let likeButton = UIButton()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setTitle("좋아요", for: .normal)
        likeButton.setTitleColor(.black, for: .normal)
        likeButton.setTitleColor(.gray, for: .highlighted)
        likeButton.titleLabel?.font = .systemFont(ofSize: 12)
        likeButton.addTarget(self, action: #selector(likeButtonTouchUpInside(_:)), for: .touchUpInside)
        likeButton.contentVerticalAlignment = .center
        likeButton.contentHorizontalAlignment = .center
        
//        likeButton.backgroundColor = .blue
  
        bottomView.addSubview(likeButton)
        
        likeButton.leftAnchor.constraint(equalTo: bottomView.leftAnchor).isActive = true
        likeButton.topAnchor.constraint(equalTo: lineView.topAnchor).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: offsetWidth/3).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        //add reply button
        let replyButton = UIButton()
        replyButton.setTitle("댓글달기", for: .normal)
        replyButton.setTitleColor(.black, for: .normal)
        replyButton.setTitleColor(.gray, for: .highlighted)
        replyButton.titleLabel?.font = .systemFont(ofSize: 12)
        replyButton.translatesAutoresizingMaskIntoConstraints = false
        replyButton.addTarget(self, action: #selector(replyButtonTouchUpInside(_:)), for: .touchUpInside)
        replyButton.contentVerticalAlignment = .center
        replyButton.contentHorizontalAlignment = .center
    
//        replyButton.backgroundColor = .red
        
        bottomView.addSubview(replyButton)
        
        replyButton.leftAnchor.constraint(equalTo: likeButton.rightAnchor).isActive = true
        replyButton.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        replyButton.widthAnchor.constraint(equalToConstant: offsetWidth/3).isActive = true
        replyButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        //add reply button
        let shareButton = UIButton()
        shareButton.setTitle("공유하기", for: .normal)
        shareButton.setTitleColor(.black, for: .normal)
        shareButton.setTitleColor(.gray, for: .highlighted)
        shareButton.titleLabel?.font = .systemFont(ofSize: 12)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.addTarget(self, action: #selector(shareButtonTouchUpInside(_:)), for: .touchUpInside)
        shareButton.contentVerticalAlignment = .center
        shareButton.contentHorizontalAlignment = .center
//        shareButton.backgroundColor = .green
        
        bottomView.addSubview(shareButton)
        
        shareButton.leftAnchor.constraint(equalTo: replyButton.rightAnchor).isActive = true
        shareButton.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: offsetWidth/3).isActive = true
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

//NoticeCell Class Definition
class NoticeCell : UICollectionViewCell {
    var key             : String!       //Notice-Posts Unique Key
    var indexPath       : IndexPath?    //Notice indexPath
    var authorId        : String?       //Notice Author
    var textLabel       : UILabel?      //Text
    private var object  : NoticeObject? //NoticeObject
    
    var dataObject      : NoticeObject {
        set(newValue){
            self.key = newValue.noticeKey
            self.textLabel?.text = newValue.noticeText
            self.authorId = newValue.authorId
            
            self.object = newValue
        }
        
        get{
            return self.object!
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textLabel = {
            let _label = UILabel()
            _label.isUserInteractionEnabled = false
            _label.translatesAutoresizingMaskIntoConstraints = false
            _label.textColor = .black
            _label.font = .boldSystemFont(ofSize: 11)
            
            return _label
        }()
        
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(textLabel!)
        
        textLabel?.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        textLabel?.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        textLabel?.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        textLabel?.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NoticeCell init(coder:) has not been implemented")
    }
}



/*************************************************************************************
 * MainViewController Start
 *************************************************************************************/

//전역변수
private let reuseIdentifier = "BoardCell"
private let reuseIdentifier2 = "NoticeCell"

private let boardPostChildName = "Board-Posts"
private let noticePostChildName = "Notice-Posts"

//Definition Class MainViewController
class MainViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, BoardCellDelegate {
    
    private var ref : FIRDatabaseReference! = FIRDatabase.database().reference()
    private var data : String!
    
    private var boardRef : FIRDatabaseReference! = FIRDatabase.database().reference().child(boardPostChildName)
    private var noticeRef : FIRDatabaseReference! = FIRDatabase.database().reference().child(noticePostChildName)
    
    private let rangeOfPosts : UInt = 100
    private var pageOfPosts  : UInt = 1
    
    private var refreshController : UIRefreshControl!
    
    lazy var composeBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.navToWriteHandle))
        
        return button
    }()
    
    //메인 타이틀
    var titleString : String! = nil
    
    //데이터 리스트
    var boardList : Array<Any>! = []
    var noticeList : Array<Any>! = []
    
    var rootController : CustomTabBarController?
    
    
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
                var obj: BoardObject! = BoardObject()
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
            var j = 0
            for board in self.boardList {
                for temp in tempList {
                    if (board as! BoardObject).isEqual(temp as! BoardObject) {
                        tempList.remove(at: j)
                    }
                    j = j + 1
                }
            }
            
            if(self.boardList.count > 0){
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
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
            
            var tempList : Array<Any>! = []
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                let key = rest.key
                let dict = rest.value as! [String :Any]
                
                
                let notiObj: NoticeObject! = NoticeObject()
                notiObj.noticeKey = key
                notiObj.authorId = dict["authorId"] as! String
                notiObj.noticeText = dict["text"] as! String
                let time : Double = dict["editTime"] as! Double
                notiObj.editTime = NSDate(timeIntervalSince1970: time/1000.0).toString()
                
                tempList.append(notiObj)
            }
            
            if(self.noticeList.count > 0){
                var i = 0
                var j = 0
                
                for idx in self.noticeList {
                    for temp in tempList {
                        if (idx as! NoticeObject).isEqual(temp as? NoticeObject){
                            tempList.remove(at: j)
                        }
                        j = j + 1
                    }
                    i = i + 1
                }
            }
            
            if(tempList.count > 0){
                self.noticeList.append(contentsOf: tempList)
            }
            
        })
    }
    
    //네비게이션바 새로운 글
    func navToWriteHandle(){
        //게시판생성뷰 이동
        
        let vc = UIStoryboard(name: "BoardCreate", bundle: nil).instantiateInitialViewController() as! BoardCreateViewController
    
        showViewController(vc, true)
    }
    
    func fetchBoardList(enumerator: NSEnumerator){
        
        for item in enumerator {
            if let item = item as? FIRDataSnapshot {
                
                let dict = item.value as! [String : Any]
                let author = dict["author"] as! [String: String]
                
                let bObj : BoardObject! = BoardObject()
                
                bObj.boradKey = item.key
                bObj.authorId = author["uid"]
                bObj.authorName = author["userName"]
                bObj.bodyText = dict["text"] as? String
                
                if let time = dict["recordTime"] as? Int {
                    bObj.editTime = NSDate(timeIntervalSince1970: Double(time/1000)).toString()
                }
                
                self.boardList.append(bObj)
            }
        }
        
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boardRef.observeSingleEvent(of: .value, with: { (snapshot) in    
            let enumerator = snapshot.children
            self.fetchBoardList(enumerator: enumerator)
            
        }){ (err) in
            print(err.localizedDescription)
        }
        
//        if(self.boardList.count == 0){
//            let bObj : BoardObject! = BoardObject()
//            
//            bObj.boradKey = boardRef.childByAutoId().key
//            bObj.authorId = FIRAuth.auth()?.currentUser?.uid
//            bObj.authorName = "June Kang"
//            bObj.bodyText = "테스트용 더미(실제데이터데이스에는 추가안되어있다)"
//            bObj.editTime = "2017년 01월 24일 오후 02:30"
//            self.boardList.append(bObj)
//        }
        
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
        
        
        //RefreshController Setting
        self.refreshController = UIRefreshControl()
        
        
        // Register cell classes
        self.collectionView!.register(BoardCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier2)
        
        //Setting View
        self.view.backgroundColor = .white
        self.collectionView?.backgroundColor = UIColor.gray.withAlphaComponent(0.25)
        
        self.collectionView?.frame = CGRect(x: 0, y: 70, width: self.view.frame.width, height: (self.collectionView?.frame.height)!-70)
       
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier2, for: indexPath) as! NoticeCell
            
            cell.dataObject = self.noticeList[indexPath.row] as! NoticeObject
            
            cell.indexPath = indexPath
            
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
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if( indexPath.section == 0 ){
            if self.noticeList.count > 0 {
                return CGSize(width: view.frame.width, height: 30)
            }else {
                return CGSize.zero
            }
        }else{
            return CGSize(width: view.frame.width, height: 250)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        
        
        
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        

        if(indexPath.section == 0){
            return
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let boardDetailController = UIStoryboard(name: "BoardDetail", bundle: nil).instantiateInitialViewController() as! BoardDetailController
        boardDetailController.boardData = self.boardList[indexPath.row] as? BoardObject
        
        let navigationController = UINavigationController(rootViewController: boardDetailController)
        navigationController.isNavigationBarHidden = false
        
        showViewController(navigationController, true)
    }

    
    
    // MARK : BoardCellDelegate
    //Edit Button
    func editButtonEvent(sender: UIButton, cell : BoardCell) {
        
        let user = FIRAuth.auth()?.currentUser
        
        let boardKey = cell.key
        let authorId = cell.authorId
        
        
        
        
        let alertController = UIAlertController(title: "게시물 수정", message: nil, preferredStyle: .actionSheet)
     
        //공지 추가 액션
        let addNoticeAction = UIAlertAction(title: "공지사항 등록", style: .default) { (Void) in
            
            let noticeKey = boardKey!
            let data : [String : Any] = ["authorId":authorId!,
                                         "text": cell.textRecorded!.text,
                                         "time": FIRServerValue.timestamp()]
            
            self.noticeRef.setValue(["\(noticeKey)":data])
        }
        
        //공지삭제 액션
        let delNoticeAction = UIAlertAction(title: "공지사항 내리기", style: .default) { (Void) in
            self.noticeRef.child(boardKey!).removeValue()
            
            self.noticeRef.observeSingleEvent(of: .childRemoved, with: { (snapshot) in
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
        
        //수정액션
        let editAction = UIAlertAction(title: "글 수정", style: .default) { (Void) in
            
//            let vc = UIStoryboard(name: "BoardCreate", bundle: nil).instantiateInitialViewController() as! BoardCreateViewController
//            
//            vc.key = cell.key
//            vc.text = cell.textRecorded?.text
//            vc.authorId = cell.authorId
//            vc.authorName = cell.authorName
//        
//            navigationController?.pushViewController(vc, animated: true)
            
            
        }
        //삭제 약션
        let delAction = UIAlertAction(title: "글 삭제", style: .destructive) { (Void) in
           
            if(user?.uid == authorId){
                self.boardRef.child(cell.key).removeValue()
                
                self.boardRef.observeSingleEvent(of: .childRemoved, with: { (snapshot) in
                    guard !snapshot.exists() else{
                        return
                    }
                    
                    self.collectionView?.deleteItems(at: [cell.indexPath])
                    self.boardList.remove(at: cell.indexPath.row)
                    
                    
                    var idx = 0
                    for board in self.boardList {
                        if(board as! BoardObject).boradKey == snapshot.key {
                            self.boardList.remove(at: idx)
                        }
                        idx = idx + 1
                    }
                    
//                    DispatchQueue.main.async(execute: { 
//                        self.collectionView?.reloadData()
//                    })
                    
                    
                })
                
            }
            
        }
        
        let cancelAtion = UIAlertAction(title: "취소", style: .cancel, handler:nil)
        
        alertController.addAction(addNoticeAction)
        alertController.addAction(delNoticeAction)
        
        
        if(user?.uid == authorId){
            alertController.addAction(editAction)
            alertController.addAction(delAction)
        }
        
        alertController.addAction(cancelAtion)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //Like Button
    func likeButtonEvent(sender: UIButton, cell : BoardCell) {
        //code
        print("press like button : \(cell.indexPath.row)")
        boardRef.runTransactionBlock({ (currentData) -> FIRTransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = FIRAuth.auth()?.currentUser?.uid {
                var likes: Dictionary<String, Bool>
                likes = post["stars"] as? [String : Bool] ?? [:]
                var likeCount = post["starCount"] as? Int ?? 0
                if let _ = likes[uid] {
                    // Unlike the post and remove self from likes
                    likeCount -= 1
                    likes.removeValue(forKey: uid)
                } else {
                    // Like the post and add self to likes
                    likeCount += 1
                    likes[uid] = true
                }
                post["likeCount"] = likeCount as AnyObject?
                post["likes"] = likes as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                return FIRTransactionResult.success(withValue: currentData)
            }
            return FIRTransactionResult.success(withValue: currentData)
        }, andCompletionBlock: { (error, sucess, snapshot) in
            guard error != nil else{
                return
            }
        })
    }
    
    //Reply Button
    func replyButtonEvent(sender: UIButton, cell : BoardCell) {
        let vc = UIStoryboard(name: "BoardDetail", bundle: nil).instantiateInitialViewController() as! BoardDetailController
        vc.boardData = cell.dataObject
        
        //let rootViwController = CustomTabBarController()
        //rootViwController.pushViewController(boardDetailController,true)
        
        present(vc, animated: true, completion: nil)
    }
    
    //Share Button
    func shareButtonEvent(sender: UIButton, cell : BoardCell) {
        //code
        let alertController = UIAlertController(title: "공유", message: nil, preferredStyle: .actionSheet)
        
        let copyAction = UIAlertAction(title: "택스트내용 복사", style: .cancel, handler:{ (Void) in
            UIPasteboard.general.string = cell.textRecorded?.text
        })
        
        alertController.addAction(copyAction)
        
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //view hierarchy 오류로 인해서 방법을 바꿈
    //원인 : CustomTabbarController안에 뷰어를 인식하지 못하는것 같음
    //원래 self.view.window.rootViewController로 가능했으나 구조상의 문제로 방법을 바꿈
    func showViewController(_ viewController: UIViewController,_ animated : Bool,_ completion :(() -> Swift.Void)? = nil){
        var activateController = UIApplication.shared.keyWindow?.rootViewController
        
        if(activateController?.isKind(of: UINavigationController.self))!{
            activateController = (activateController as! UINavigationController).visibleViewController
        }else if((activateController?.presentedViewController) != nil){
            activateController = activateController?.presentedViewController
        }
        
        activateController?.present(viewController, animated: animated, completion: completion)
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

extension UIView {
    func addConstraintWithFormat(_ format : String, _ views : UIView...){
        
        var viewsDictionary = [String : UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension CustomTabBarController {
    func pushViewController(_ viewController:UIViewController, _ animated  : Bool){
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    @nonobjc
    convenience init(red: Int, green: Int, blue: Int, alpha : Float) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha))
    }

    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
