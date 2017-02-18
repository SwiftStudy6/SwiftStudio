//
//  MainViewController.swift
//  SwiftStudio
//
//  Created by David June Kang on 2016. 12. 31..
//  Copyright © 2016년 ven2s.soft. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import Toaster

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
        
        self.contentView.backgroundColor = .white
        
        textLabel = {
            let _label = UILabel()
            _label.isUserInteractionEnabled = false
            _label.translatesAutoresizingMaskIntoConstraints = false
            _label.textColor = .black
            _label.font = .boldSystemFont(ofSize: 20)
            
            return _label
        }()
        
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(textLabel!)
        
        textLabel?.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 15).isActive = true
        textLabel?.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -15).isActive = true
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
    
    lazy var homeBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "Home"), style: .plain, target: self, action: #selector(self.returnHome))
        
        return button
    }()
    
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
            guard snapshot.exists() else {
                return
            }
            
            var tempList : Array<Any>! = [] //초기화
            
            let enumerate = snapshot.children
            while let rest = enumerate.nextObject()  as? FIRDataSnapshot {
                var dict = rest.value as! [String : Any]
                var obj: BoardObject! = BoardObject()
                obj.boradKey = rest.key
                obj.bodyText = dict["text"] as! String?
                
                var userObj = dict["author"] as? [String : Any]
                
                var time : NSDate?
                
                if let editTIme = dict["editTime"]{
                    time = NSDate(timeIntervalSince1970: editTIme as! Double / 1000)
                }else if let recordTiem = dict["recordTime"] {
                    time = NSDate(timeIntervalSince1970: recordTiem as! Double / 1000)
                }

                obj = BoardObject(rest.key,
                                  userObj?["uid"] as! String,
                                  userObj?["userName"] as! String,
                                  userObj?["profile_url"] as! String,
                                  dict["text"] as! String,
                                  (time?.toString())!)
                
                
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
            
            self.boardList = tempList
            
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
            guard snapshot.exists() else{
                return
            }
            
            var tempList : Array<Any>! = []
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                let noticeKey = rest.key
                let dict = rest.value as! [String :Any]
                
                let user = dict["author"] as! [String : Any]
                
                
                let notiObj: NoticeObject! = NoticeObject(noticeKey,
                                                          dict["boardKey"] as! String,
                                                          user["uid"] as! String,
                                                          dict["text"] as! String,
                                                          dict["editTime"] as! Double)
//                notiObj.boardKey = dict["boardKey"] as! String
//                notiObj.noticeKey = key
//                notiObj.authorId = user["uid"] as! String
//                notiObj.noticeText = dict["text"] as! String
//                let time : Double = dict["editTime"] as! Double
//                notiObj.editTime = NSDate(timeIntervalSince1970: time/1000.0).toString()
                
                
                tempList.append(notiObj)
            }
            
            if(self.noticeList.count > 0){
                var i = 0
                
                for idx in self.noticeList {
                    for temp in tempList {
                        if (idx as! NoticeObject).isEqual(temp as? NoticeObject){
                            tempList.remove(at: i)
                        }
                        i = i + 1
                    }
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
    

    func returnHome(){
        closeViewController(true)
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
        

        loadEvent()

//        boardRef.observeSingleEvent(of: .value, with: { (snapshot) in    
//            let enumerator = snapshot.children
//            self.fetchBoardList(enumerator: enumerator)
//            
//        }){ (err) in
//            print(err.localizedDescription)
//        }

        
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

        
        let customController = CustomTabBarController.sharedInstance
        
        self.titleString = "메인"
        
        if let title = customController.titleStr {
            self.titleString = title
        }
        
              
        navigationItem.title = self.titleString
        navigationItem.rightBarButtonItem = composeBarButtonItem
        navigationItem.leftBarButtonItem = homeBarButtonItem
        
        //self.navigationController?.navigationBar.items = [self.navigationItem]
        
        // 네비게이션 바를 추가한다.
        let naviBar = UINavigationBar()
        naviBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64)
        naviBar.items = [navigationItem]
        naviBar.barTintColor = .white
        
        self.view.addSubview(naviBar)
        
        self.collectionView?.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: (self.collectionView?.frame.height)!-64)
        
        
        //RefreshController Setting
        self.refreshController = UIRefreshControl()
        
        
        // Register cell classes
        self.collectionView!.register(BoardCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(NoticeCell.self, forCellWithReuseIdentifier: reuseIdentifier2)
        
        //Setting View
        self.view.backgroundColor = .white
        self.collectionView?.backgroundColor = UIColor.gray.withAlphaComponent(0.25)
        
        
       
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
            
            cell.userImage.sd_setImage(with: URL(string:boardObj.profileImgUrl!), placeholderImage: UIImage(named:"User"), options: .retryFailed, completed: { (image, error, cachedType, url) in
                
                
                //이미지캐싱이 안되있을경우에 대한 애니메이션 셋팅_imageView.alpha = 1;
                if cell.userImage != nil, cachedType == .none {
                    
                    cell.userImage?.alpha = 0
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        cell.userImage?.alpha = 1
                    }, completion: { (finished) in
                        cell.userImage?.alpha = 1
                    })
                }
            })
        
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
            let noticeObj = self.noticeList[indexPath.row] as! NoticeObject
            
            let actionController = UIAlertController(title: "확인창", message: "해당 공지사항을 내리겠습니까?", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: { (Void) in
                
                self.noticeRef.child(noticeObj.noticeKey).removeValue(completionBlock: { (error, ref) in
                    guard error == nil else {
                        return
                    }
                    let key = ref.key
                    
                    var idx = 0
                    
                    for obj in self.noticeList {
                        if(obj as! NoticeObject).noticeKey == key {
                            self.noticeList.remove(at: idx)
                            self.collectionView?.deleteItems(at: [IndexPath(row: idx, section: 0)])
                        }
                        idx = idx + 1
                    }

                    
                })
                
                //왜 안되는지 모르겠다
                self.noticeRef.observeSingleEvent(of: .childRemoved, with: { (snapshot) in
                    
                    guard snapshot.exists() else {
                        return
                    }
                    
                    let key = snapshot.key 
                    
                    var idx = 0
                    
                    for obj in self.noticeList {
                        if(obj as! NoticeObject).noticeKey == key {
                            self.noticeList.remove(at: idx)
                            self.collectionView?.deleteItems(at: [IndexPath(row: idx, section: 0)])
                        }
                        idx = idx + 1
                    }
                    
                })
                
            })
            
            let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
            
            
            actionController.addAction(deleteAction)
            actionController.addAction(cancelAction)
            
            if(FIRAuth.auth()?.currentUser?.uid == noticeObj.authorId){
                self.present(actionController, animated: true, completion: nil)
            }
            
        }else{
        
            collectionView.deselectItem(at: indexPath, animated: true)
            
            let boardDetailController = UIStoryboard(name: "BoardDetail", bundle: nil).instantiateInitialViewController() as! BoardDetailController
            boardDetailController.boardData = self.boardList[indexPath.row] as? BoardObject
            
            let navigationController = UINavigationController(rootViewController: boardDetailController)
            
            //navigationController.isNavigationBarHidden = true
            navigationController.isNavigationBarHidden = false
            
            showViewController(navigationController, true)
            
            //        self.navigationController?.pushViewController(boardDetailController, animated: true)
        }
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
            let data : [String : Any] = ["boardKey":boardKey!,
                                         "author": ["uid":authorId!],
                                         "text": cell.textRecorded!.text,
                                         "recordTime": FIRServerValue.timestamp(),
                                         "editTime": FIRServerValue.timestamp()]
            if(self.noticeList.count >= 2){
                Toast(text:"공지사항은 2개 이상 등록 할수 없습니다.").show()
                return
            }else{
                self.noticeRef.child(noticeKey).setValue(data, withCompletionBlock: { (error, ref) in
                    guard error == nil else {
                        return
                    }
                    
                    ref.observe(.value, with: { (snapshot) in
                        guard snapshot.exists() else {
                            return
                        }
                        
                        let count = self.noticeList.count
                        
                        let dict = snapshot.value as! [String : Any]
                        
                        let user = dict["author"] as? [String : Any]
                        
                        //NoticeObject(_ noticeKey: String, _ boardKey: String, _ authorId: String, _ noticeText: String, _ editTime: Double){
                        let obj = NoticeObject(snapshot.key,
                                               dict["boardKey"] as! String,
                                               user?["uid"] as! String,
                                               dict["text"] as! String,
                                               dict["editTime"] as! Double)
                        var idx = -1
                        for obj in self.noticeList {
                            if (obj as! NoticeObject).noticeKey == snapshot.key{
                                idx = idx + 1
                            }
                        }
                        
                        
                        if(idx == -1 || self.noticeList.count == 0) {
                            self.noticeList.append(obj)
                        }
                        
                        if(count < self.noticeList.count){
                            self.collectionView?.insertItems(at: [IndexPath(row:self.noticeList.count-1, section: 0)])
                            self.collectionView?.reloadItems(at: [IndexPath(row:self.noticeList.count-1, section: 0)])
                        }else{
                            
                        }
                    })
                    
                    
                })
            }
        }
        
        //공지삭제 액션
        let delNoticeAction = UIAlertAction(title: "공지사항 내리기", style: .default) { (Void) in
            
            var noticeKey : String?
            var indexPath : IndexPath?
            var i = 0
            for idx in self.noticeList {
                if(cell.key == (idx as! NoticeObject).boardKey){
                    indexPath = IndexPath(row: i, section: 0)
                    
                    noticeKey = (idx as! NoticeObject).noticeKey
                }
                i = i + 1
            }
            
            self.noticeRef.child(noticeKey!).removeValue(completionBlock: { (error, ref) in
                guard error == nil else {
                    return
                }
                
                let key = ref.key
                
                var i = 0
                
                for obj in self.noticeList {
                    if(obj as! NoticeObject).noticeKey == key {
                        self.noticeList.remove(at: i)
                        self.collectionView?.deleteItems(at: [IndexPath(row: i, section: 0)])
                    }
                    i = i + 1
                }
                
            })
            
            self.noticeRef.observeSingleEvent(of: .childRemoved, with: { (snapshot) in
                guard snapshot.exists() else{
                    return
                }
                
                let dict = snapshot.value as! [String : Any]
                
                if(boardKey == dict["boardKey"] as? String){
                    self.collectionView?.deleteItems(at: [indexPath!])
                    self.noticeList.remove(at: (indexPath?.row)!)
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
           
            let confirmControlelr = UIAlertController(title: "확인창", message: "정말로 게시물을 삭제 하실껍니까?\n(복구 안됩니다)", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: { (Void) in
                if(user?.uid == authorId){
                    self.boardRef.child(cell.key).removeValue(completionBlock: { (error, ref) in
                        guard error == nil else {
                            return
                        }
                        
                        let key = ref.key
                        let obj = self.boardList[cell.indexPath.row] as! BoardObject
                        
                        if obj.boradKey == key{
                            self.boardList.remove(at: cell.indexPath.row)
                            
                            self.collectionView?.deleteItems(at: [cell.indexPath])
                            
                        }
                    })
                    
                    //작동이 안된다.
//                    self.boardRef.observeSingleEvent(of: .childRemoved, with: { (snapshot) in
//                        guard !snapshot.exists() else{
//                            return
//                        }
//                        
//                        self.collectionView?.deleteItems(at: [cell.indexPath])
//                        self.boardList.remove(at: cell.indexPath.row)
//                        
//                        
//                        var idx = 0
//                        for board in self.boardList {
//                            if(board as! BoardObject).boradKey == snapshot.key {
//                                self.boardList.remove(at: idx)
//                            }
//                            idx = idx + 1
//                        }
//                        
//                        //                    DispatchQueue.main.async(execute: {
//                        //                        self.collectionView?.reloadData()
//                        //                    })
//                        
//                    })
                    
                }
            })
            
            let cancelAtion = UIAlertAction(title: "취소", style: .default, handler:nil)
            
            confirmControlelr.addAction(deleteAction)
            confirmControlelr.addAction(cancelAtion)
            
            
            self.present(confirmControlelr, animated: true, completion: nil)
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
        //print("press like button : \(cell.indexPath.row)")
        boardRef.child(cell.key).runTransactionBlock({ (currentData) -> FIRTransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = FIRAuth.auth()?.currentUser?.uid {
                var likes: Dictionary<String, Bool>
                likes = post["like"] as? [String : Bool] ?? [:]
                var likeCount = post["likeCount"] as? Int ?? 0
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
                post["like"] = likes as AnyObject?
                
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
            print("showViewController - Navigation")
            activateController = (activateController as! UINavigationController).visibleViewController
            
            activateController?.present(viewController, animated: animated, completion: completion)

        }else if((activateController?.presentedViewController) != nil){
            print("showViewController - Nomal")
            activateController = activateController?.presentedViewController
            if(activateController?.isKind(of: UINavigationController.self))!{
                print("showViewController - Nomal - Navigation")
                activateController?.navigationController?.isNavigationBarHidden = true
                //(activateController as! UINavigationController).pushViewController(viewController, animated: true)
            }
            activateController?.present(viewController, animated: animated, completion: completion)
        }
        
//        activateController?.present(viewController, animated: animated, completion: completion)

    }
    
    
    func closeViewController(_ animated : Bool,_ completion :(() -> Swift.Void)? = nil){
        var activateController = UIApplication.shared.keyWindow?.rootViewController
        
        if(activateController?.isKind(of: UINavigationController.self))!{
            activateController = (activateController as! UINavigationController).visibleViewController
        }else if((activateController?.presentedViewController) != nil){
            activateController = activateController?.presentedViewController
        }
        
        activateController?.dismiss(animated: animated, completion: completion)
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
