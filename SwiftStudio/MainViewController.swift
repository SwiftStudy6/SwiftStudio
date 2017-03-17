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
import PullToRefresh


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
    
    let rangeOfPosts : UInt = 10
    var pageOfPosts  : UInt = 1
    
    var lastestKey : String?
    
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
    var boardList : Array<Any>! = Array()
    var noticeList : Array<Any>! = Array()
    
    //뱅글이를 위한 것
    var indicator : UIActivityIndicatorView?
    var indicView : UIView?
    
    //초기 상태 로딩
    func loadPostsEvent(){
        
        loadOfPosts(1, false, startBlock: { () in
                let tup = self.showActivityIndicatory(uiView: self.view)
                self.indicator = tup.1
                self.indicView = tup.0
                self.indicView?.isHidden = false
        }, endBlock: { () in
            self.indicView?.isHidden = true
            self.indicator?.stopAnimating()
        } )
    }
    
    
    //게시판 내용을 블러온다 (모두)
    func loadOfPosts(_ pageCount : UInt, _ isTrue : Bool = false, startBlock : (() -> Swift.Void)? = nil, endBlock:(() -> Swift.Void)? = nil){
        
        self.boardList.removeAll() //초기화
        
        let ref = boardRef.queryOrderedByKey()
        
        if !isTrue {
            startBlock!()
        }
        
        ref.queryLimited(toFirst: rangeOfPosts * pageCount).observeSingleEvent(of: .value, with: {(snapshot) in
            guard snapshot.exists() else {
                return
            }
            
            var tempList : Array<Any>! = Array() //초기화
            
            let enumerate = snapshot.children
            while let rest = enumerate.nextObject()  as? FIRDataSnapshot {
                var dict = rest.value as! [String : Any]
                
                var userObj = dict["author"] as? [String : Any]
                
                var time : Double = 0
                
                //수정된 사항이
                if let editTIme = dict["editTime"]{
                    time = editTIme as! Double
                }else if let recordTime = dict["recordTime"] {
                    time = recordTime as! Double
                }
                
                
                //BoardObject에 넣는다.
                let obj: BoardObject! = BoardObject(rest.key,
                                                    userObj?["uid"] as! String,
                                                    userObj?["userName"] as! String,
                                                    userObj?["profile_url"] as! String,
                                                    dict["text"] as! String,
                                                    dict["recordTime"] as! Double,
                                                    time)
                
                //like 있을경우에만 parsing
                if let like = dict["like"], let likeCount = dict["likeCount"]{
                    
                    obj.like = like as? Dictionary<String, Bool>
                    obj.likeCount = likeCount as! Int
                   
                }

                tempList.append(obj)
            }
            
            self.boardList.append(contentsOf: tempList)
            
            //페이징을 위한 방법
            
            let counts = UInt(self.boardList.count) / self.rangeOfPosts
            self.pageOfPosts = counts == 0 ? self.pageOfPosts : counts
            self.lastestKey = (snapshot.children.allObjects.last as! FIRDataSnapshot).key
            
            if(self.boardList.count > 0){
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    self.collectionView?.scrollToItem(at: IndexPath(row: self.boardList.count-1, section:1), at: .bottom, animated: false)
                    if isTrue {
                        self.collectionView?.endRefreshing(at: .top)
                    }else{
                        endBlock!()
                    }
                }
            }
        })
        if (self.indicator?.isAnimating)! {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: { 
                endBlock!()
            })
        }
    }
    
    //가장 불러온 최근의 값중 100개를 가져온다.
    func appendingOfPosts(_ pageCount : UInt){
        guard self.lastestKey != nil else {
            return
        }
        
        let ref = boardRef.queryOrderedByKey()
        
        ref.queryStarting(atValue: lastestKey).queryLimited(toFirst: rangeOfPosts + UInt(1)).observeSingleEvent(of: .value, with: { (snapshot) in
            guard snapshot.exists() else {
                return
            }
            
            var tempList : Array<Any>! = Array() //초기화
            
            let enumerated = snapshot.children
            while let rest = enumerated.nextObject() as? FIRDataSnapshot {
                var dict = rest.value as! [String: Any]
                
                var userObj = dict["author"] as? [String : Any]
                
                var time : Double = 0
                
                //수정된 사항이
                if let editTIme = dict["editTime"]{
                    time = editTIme as! Double
                }else if let recordTime = dict["recordTime"] {
                    time = recordTime as! Double
                }
                
                
                //BoardObject에 넣는다.
                let obj: BoardObject! = BoardObject(rest.key,
                                                    userObj?["uid"] as! String,
                                                    userObj?["userName"] as! String,
                                                    userObj?["profile_url"] as! String,
                                                    dict["text"] as! String,
                                                    dict["recordTime"] as! Double,
                                                    time)
                
                //like 있을경우에만 parsing
                if let like = dict["like"], let likeCount = dict["likeCount"]{
                    
                    obj.like = like as? Dictionary<String, Bool>
                    obj.likeCount = likeCount as! Int
                    
                }
                
                tempList.append(obj)
            }
            
            for board in self.boardList {
                for (idx,temp) in tempList.enumerated() {
                    if (board as! BoardObject).isEqual(temp as! BoardObject) {
                        tempList.remove(at: idx)
                    }
                }
            }
            
            let count  = self.boardList.count
            
            self.lastestKey = (snapshot.children.allObjects.last as! FIRDataSnapshot).key
            
            self.boardList.append(contentsOf: tempList)
            
            if(count < self.boardList.count){
                self.pageOfPosts = self.pageOfPosts + 1
            }
            
            DispatchQueue.main.async {
                
                self.collectionView?.reloadData()
                self.collectionView?.scrollToItem(at: IndexPath(row: count-1, section: 1), at: .bottom, animated: false)
                
                self.collectionView?.endRefreshing(at: .bottom)
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { 
            self.collectionView?.endRefreshing(at: .bottom)
        }
        print("bottom reload end ----------")
        
    }

    
    
    //초기 불러오기 이벤트
    func loadEvent(){
        
        loadPostsEvent()
        
        //공지사항을 불러온다
        noticeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard snapshot.exists() else{
                return
            }
            
            var tempList : Array<Any>! = Array()
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                let noticeKey = rest.key
                let dict = rest.value as! [String :Any]
                
                let user = dict["author"] as! [String : Any]
                
                var time :Double = 0
                
                if let _ = dict["editTime"] {
                    time = dict["editTime"] as! Double
                }else {
                    time = dict["recordTime"] as! Double
                }
                
                let notiObj: NoticeObject! = NoticeObject(noticeKey,
                                                          user["uid"] as! String,
                                                          dict["text"] as! String,
                                                          dict["recordTime"] as! Double,
                                                          time)
                
                tempList.append(notiObj)
            }
            
            if(self.noticeList.count > 0){
                for idx in self.noticeList {
                    for (i,temp) in tempList.enumerated() {
                        if (idx as! NoticeObject).isEqual(temp as? NoticeObject){
                            tempList.remove(at: i)
                        }
                    }
                }
            }
            
            if(tempList.count > 0){
                self.noticeList.append(contentsOf: tempList)
                self.collectionView?.reloadData()
            }
            
        })
    }
    
    //네비게이션바 새로운 글
    func navToWriteHandle(){
        //게시판생성뷰 이동
        
        let vc = UIStoryboard(name: "BoardCreate", bundle: nil).instantiateInitialViewController() as! BoardCreateViewController
        
        //vc.delegate = self
        
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
//      //테스터 더미
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
        
        self.collectionView?.delegate = self
        
        
        //Pull to Refresth Setting
        //setupPullToRefresh()
       
    }
    
    deinit {
        collectionView?.removePullToRefresh((collectionView?.bottomPullToRefresh!)!)
        collectionView?.removePullToRefresh((collectionView?.topPullToRefresh!)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        ref.removeAllObservers()
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        //내용이 없을 경우 보여준다.
        collectionView.backgroundView = nil
    
        if (self.boardList.count == 0), (self.noticeList.count == 0) {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.frame.size.width, height: collectionView.frame.size.height))
            noDataLabel.text = "결과가 없거나 조회중입니다. 잠시만 기다려주세요"
            noDataLabel.textColor = .black
            noDataLabel.textAlignment = .center
            collectionView.backgroundView = noDataLabel
        }
        
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
            
            cell.likeButton?.isSelected = false
            
            if let like = boardObj.like {
                if let _ = like[(FIRAuth.auth()?.currentUser?.uid)!] {
                    cell.likeButton?.isSelected = true
                }else{
                    cell.likeButton?.isSelected = false
                }
            }
            
            //프로필 이미지 처리
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
            
            
            //text 
            
            let lineCount = (cell.textRecorded?.frame.size.height)! / (cell.textRecorded?.font?.lineHeight)!
            print("\(indexPath.row) : \(lineCount)")
            
            
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
            var height : CGFloat = 250.0;

            
            return CGSize(width: view.frame.width, height: height)
        }
    }
    
    
    //셀 내부 유격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //셀선택시
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(indexPath.section == 0){
            let noticeObj = self.noticeList[indexPath.row] as! NoticeObject
            
            let actionController = UIAlertController(title: "확인창", message: "해당 공지사항을 내리겠습니까?", preferredStyle: .alert)
            //공지사항 삭제
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: { (Void) in
                
                self.noticeRef.child(noticeObj.noticeKey).removeValue(completionBlock: { (error, ref) in
                    guard error == nil else {
                        return
                    }
                    let key = ref.key
                    
                    
                    for (idx,obj) in self.noticeList.enumerated() {
                        if(obj as! NoticeObject).noticeKey == key {
                            self.noticeList.remove(at: idx)
                            self.collectionView?.deleteItems(at: [IndexPath(row: idx, section: 0)])
                        }
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
            
            navigationController.isNavigationBarHidden = false
            
            showViewController(navigationController, true)
            
        }
    }
    
    // MARK : FlowlayoutDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 1
        }else{
            return 8
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
            let data : [String : Any] = ["author": ["uid":authorId!],
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
                        
                        var time : Double = 0
                        
                        if let _ = dict["editTime"] {
                            time = dict["editTime"] as! Double
                        }else {
                            time = dict["recordTime"] as! Double
                        }
                        
                        
                        //NoticeObject(_ noticeKey: String, _ boardKey: String, _ authorId: String, _ noticeText: String, _ editTime: Double){
                        let obj = NoticeObject(snapshot.key,
                                               user?["uid"] as! String,
                                               dict["text"] as! String,
                                               dict["recordTime"] as! Double,
                                               time)
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
                        }
                    })
                })
            }
        }
        
        //공지 삭제 액션
        let delNoticeAction = UIAlertAction(title: "공지사항 내리기", style: .default) { (Void) in
            
            var noticeKey : String?
            var indexPath : IndexPath?

            for (idx,val) in self.noticeList.enumerated() {
                if(cell.key == (val as! NoticeObject).noticeKey){
                    indexPath = IndexPath(row: idx, section: 0)
                    
                    noticeKey = (val as! NoticeObject).noticeKey
                }
            }
            
            self.noticeRef.child(noticeKey!).removeValue(completionBlock: { (error, ref) in
                guard error == nil else {
                    return
                }
                
                let key = ref.key
                
                
                
                for (i,obj) in self.noticeList.enumerated() {
                    if(obj as! NoticeObject).noticeKey == key {
                        self.noticeList.remove(at: i)
                        self.collectionView?.deleteItems(at: [IndexPath(row: i, section: 0)])
                    }
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
        
        //글 수정 액션
        let editAction = UIAlertAction(title: "글 수정", style: .default) { (Void) in
            

            let boardEditViewController = UIStoryboard(name: "BoardCreate", bundle: nil).instantiateInitialViewController() as! BoardCreateViewController
            
            boardEditViewController.boardData = cell.dataObject //데이터 오브젝트를 보댄다
            //boardEditViewController.cellDelegate = cell         //현제 셀의 정보를 넘긴다.
            
            //boardEditViewController.delegate = self             //수정후 처리를 위한 델리게이트르 넘긴다.
        
            self.showViewController(boardEditViewController, true)
        }
        
        //글 삭제 약션
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
        
        var flag = false    //flag for select
        
        boardRef.child(cell.key).runTransactionBlock({ (currentData) -> FIRTransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = FIRAuth.auth()?.currentUser?.uid {
                var likes: Dictionary<String, Bool>
                likes = post["like"] as? [String : Bool] ?? [:]
                var likeCount = post["likeCount"] as? Int ?? 0
                if let _ = likes[uid] {
                    // Unlike the post and remove self from likes
                    likeCount -= 1
                    likes.removeValue(forKey: uid)
                    flag = false
                } else {
                    // Like the post and add self to likes
                    likeCount += 1
                    likes[uid] = true
                    flag = true
                }
                post["likeCount"] = likeCount as AnyObject?
                post["like"] = likes as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                return FIRTransactionResult.success(withValue: currentData)
            }
            return FIRTransactionResult.success(withValue: currentData)
        }, andCompletionBlock: { (error, sucess, snapshot) in
            guard error == nil else{
                return
            }
            
            let dict = snapshot?.value as! [String:Any]
            let obj = self.boardList[cell.indexPath.row] as! BoardObject
            
            cell.likeButton?.isSelected = flag
            obj.like = dict["like"] as! Dictionary<String, Bool>?
            obj.likeCount = dict["likeCount"] as! Int
            
            self.collectionView?.reloadItems(at: [cell.indexPath])
        })
    }
    
    //Reply Button
    func replyButtonEvent(sender: UIButton, cell : BoardCell) {
        let vc = UIStoryboard(name: "BoardDetail", bundle: nil).instantiateInitialViewController() as! BoardDetailController
        vc.boardData = cell.dataObject
        
        showViewController(vc, true)
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
            
            

        }else if((activateController?.presentedViewController) != nil){
            print("showViewController - Nomal")
            activateController = activateController?.presentedViewController
            if(activateController?.isKind(of: UINavigationController.self))!{
                print("showViewController - Nomal - Navigation")
                activateController?.navigationController?.isNavigationBarHidden = true
              
            }
            
        }
        
        activateController?.present(viewController, animated: animated, completion: completion)

    }
    
    //현재 띄워진 뷰어를 닫는다. (잘 생각하고 쓰세요)
    func closeViewController(_ animated : Bool,_ completion :(() -> Swift.Void)? = nil){
        var activateController = UIApplication.shared.keyWindow?.rootViewController
        
        if(activateController?.isKind(of: UINavigationController.self))!{
            activateController = (activateController as! UINavigationController).visibleViewController
        }else if((activateController?.presentedViewController) != nil){
            activateController = activateController?.presentedViewController
        }
        
        activateController?.dismiss(animated: animated, completion: completion)
    }
    
    //indicator
    //최초 로딩시에 인디케이터를 불러온다.
    func showActivityIndicatory(uiView: UIView) -> (UIView,UIActivityIndicatorView){
        let container: UIView = UIView()
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor(netHex:0xffffff, alpha: 0.3)
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor(netHex:0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.activityIndicatorViewStyle = .whiteLarge
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        actInd.startAnimating()
        
        return (container, actInd)
    }
    
    //수정후 로직
    func afterEdit(ref : FIRDatabaseReference, cell : BoardCell?, _ isNew : Bool = false) {
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard snapshot.exists() else {
                return
            }
            
            let value = snapshot.value as! [String : Any]
            
            if !isNew {
                let bObj = self.boardList[(cell?.indexPath.row)!] as! BoardObject
                
                var nObj : NoticeObject?
                var index = -1
                for (idx, value) in self.noticeList.enumerated() {
                    if (value as! NoticeObject).noticeKey == snapshot.key {
                        nObj = self.noticeList[idx] as? NoticeObject
                        index = idx
                    }
                }
                
                bObj.bodyText = value["text"] as? String
                bObj.editTimeDouble = value["editTime"] as? Double
                bObj.editTime = NSDate(timeIntervalSince1970: (value["editTime"] as? Double)! / 1000).toString().appending(" 수정됨")
                
                
                self.boardList[(cell?.indexPath.row)!]  = bObj
                
                var indexPaths : Array<IndexPath> = Array()
                
                indexPaths.append((cell?.indexPath)!)
                self.collectionView?.reloadItems(at: indexPaths)
                
                if(index > -1){
                    nObj?.text = value["text"] as! String
                    nObj?.editTime = value["editTime"] as! Double
                    
                    //self.noticeList[index] = nObj!
                    indexPaths = Array()
                    
                    let data : [String : Any] = ["author": ["uid":nObj?.authorId!],
                                                 "text": value["text"] as! String,
                                                 "recordTime": (nObj?.recordTime)!,
                                                 "editTime": value["editTime"] as! Double]
                    
                    
                    self.noticeRef.child((nObj?.noticeKey)!).updateChildValues(data, withCompletionBlock: { (error, snapshot) in
                        guard (error == nil) else{
                            return
                        }
                        indexPaths.append(IndexPath(row: index, section: 0))
                        self.collectionView?.reloadItems(at: indexPaths)
                    })
                }
            } else {
                var userObj = value["author"] as? [String : Any]
                
                var time : Double = 0
                
                //수정된 사항이
                if let editTIme = value["editTime"]{
                    time = editTIme as! Double
                }else if let recordTime = value["recordTime"] {
                    time = recordTime as! Double
                }
                
                
                //BoardObject에 넣는다.
                let obj: BoardObject! = BoardObject(snapshot.key,
                                                    userObj?["uid"] as! String,
                                                    userObj?["userName"] as! String,
                                                    userObj?["profile_url"] as! String,
                                                    value["text"] as! String,
                                                    value["recordTime"] as! Double,
                                                    time)
                
                //like 있을경우에만 parsing
                if let like = value["like"], let likeCount = value["likeCount"]{
                    
                    obj.like = like as? Dictionary<String, Bool>
                    obj.likeCount = likeCount as! Int
                    
                }
                
                self.boardList.append(obj)
                
                let newIndexPath = IndexPath(row:self.boardList.count-1, section:1)
                self.collectionView?.insertItems(at: [newIndexPath])

            }
        })
    }
} //End of MaincViewController

//
//extension NSDate {
//    
//    func toString() -> String {
//        
//        let formater = DateFormatter()
//        formater.amSymbol = "오전"
//        formater.pmSymbol = "오후"
//        formater.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분 ss초 "
//        
//        
//        return formater.string(from: self as Date)
//    }
//    
//
//    func toString(_ format:String?) -> String {
//        
//        let formater = DateFormatter()
//        formater.amSymbol = "오전"
//        formater.pmSymbol = "오후"
//        formater.dateFormat = format ?? "yyyy년 MM월 dd일 a hh시 mm분 ss초 "
//        
//        
//        return formater.string(from: self as Date)
//    }
//}
//
//extension UIView {
//    func addConstraintWithFormat(_ format : String, _ views : UIView...){
//        
//        var viewsDictionary = [String : UIView]()
//        
//        for (index, view) in views.enumerated() {
//            let key = "v\(index)"
//            viewsDictionary[key] = view
//            view.translatesAutoresizingMaskIntoConstraints = false
//        }
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
//    }
//}
//
//extension CustomTabBarController {
//    func pushViewController(_ viewController:UIViewController, _ animated  : Bool){
//        self.navigationController?.pushViewController(viewController, animated: animated)
//    }
//}
//
//extension UIColor {
//    convenience init(red: Int, green: Int, blue: Int) {
//        assert(red >= 0 && red <= 255, "Invalid red component")
//        assert(green >= 0 && green <= 255, "Invalid green component")
//        assert(blue >= 0 && blue <= 255, "Invalid blue component")
//        
//        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
//    }
//    
//    @nonobjc
//    convenience init(red: Int, green: Int, blue: Int, alpha : Float) {
//        assert(red >= 0 && red <= 255, "Invalid red component")
//        assert(green >= 0 && green <= 255, "Invalid green component")
//        assert(blue >= 0 && blue <= 255, "Invalid blue component")
//        
//        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha))
//    }
//
//    
//    convenience init(netHex:Int) {
//        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
//    }
//    
//    convenience init(netHex:Int, alpha:Float) {
//        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff, alpha : alpha)
//    }
//}
//
//
//private extension MainViewController {
//    
//    func setupPullToRefresh() {
//        collectionView?.addPullToRefresh(PullToRefresh()) { [weak self] in
//            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
//            DispatchQueue.main.asyncAfter(deadline: delayTime) {
//                print("top reload start------")
//                self?.loadOfPosts((self?.pageOfPosts)!,true)
//                
//            }
//        }
//        
//        collectionView?.addPullToRefresh(PullToRefresh(position: .bottom)) { [weak self] in
//            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
//            DispatchQueue.main.asyncAfter(deadline: delayTime) {
//                print("botton reload start------")
//                self?.appendingOfPosts((self?.pageOfPosts)!)
//            }
//        }
//    }
//}

