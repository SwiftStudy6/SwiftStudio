//
//  BoardTableViewController.swift
//  SwiftStudio
//
//  Created by David June Kang on 2017. 3. 15..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit
import Firebase
import Toaster
import SDWebImage
import PullToRefresh

private let boardReuseIndentifier = "BoardTableCell"
private let noticeReuseIndentifier = "NoticeTableCell"

private let boardPostChildName = "Board-Posts"
private let noticePostChildName = "Notice-Posts"


class BoardTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BoardTableCellDelegate {
 
    var naviBar: UINavigationBar!
    
    let maxSize = 200

    
    @IBOutlet weak var tableView: UITableView!
    
    
    private var ref : FIRDatabaseReference! = FIRDatabase.database().reference()
    private var data : String!
    
    private var boardRef : FIRDatabaseReference! = FIRDatabase.database().reference().child(boardPostChildName)
    private var noticeRef : FIRDatabaseReference! = FIRDatabase.database().reference().child(noticePostChildName)
    
    let rangeOfPosts : UInt = 10    //페이지당 표현 갯수
    var pageOfPosts  : UInt = 1     //현재 페이지갯수
    
    var lastestKey : String?
    
    private var refreshController : UIRefreshControl!
    
    lazy var homeBarButtonItem: UIBarButtonItem = {
        
        let _image = UIImage(named: "HomeWhite")?.resizeImage(targetSize: CGSize(width: 27 , height: 27))
        
        let button = UIBarButtonItem(image: _image, style: .plain, target: self, action: #selector(self.returnHome))
        
        return button
    }()
    
    
    lazy var composeBarButtonItem: UIBarButtonItem = {
        let _image = UIImage(named: "EditWhite")?.resizeImage(targetSize: CGSize(width: 27 , height: 27))
        
        let button = UIBarButtonItem(image: _image, style: .plain, target: self, action: #selector(self.navToWriteHandle))
        
        
        return button
    }()
    
    //메인 타이틀
    var titleString : String! = nil
    
    //데이터 리스트
    var boardList : Array<BoardObject>! = Array()
    var noticeList: Array<NoticeObject>!  = Array()
    
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
        
        let ref = boardRef.queryOrderedByKey()
        
        if !isTrue {
            startBlock!()
        }
        
        ref.queryLimited(toFirst: rangeOfPosts * pageCount).observeSingleEvent(of: .value, with: {(snapshot) in
            guard snapshot.exists() else {
                return
            }
            self.boardList.removeAll() //초기화
            
            var tempList : Array<BoardObject>! = Array() //초기화
            
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
            self.pageOfPosts = UInt(self.boardList.count) / self.rangeOfPosts == 0 ? self.pageOfPosts : UInt(self.boardList.count) / self.rangeOfPosts
            self.lastestKey = (snapshot.children.allObjects.last as! FIRDataSnapshot).key
            
            if(self.boardList.count > 0){
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                    
                    if isTrue {
                        self.tableView?.endRefreshing(at: .top)
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
            
            var tempList : Array<BoardObject>! = Array() //초기화
            
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
                    if board.isEqual(temp) {
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
                
                self.tableView?.reloadData()
                self.tableView.scrollToRow(at: IndexPath(row: count-1, section: 1), at: .bottom, animated: false)
                self.tableView?.endRefreshing(at: .bottom)
            }
        })
        
        //3초뒤 리프레싱을 꺼지도록 한다.(혹시모를 상황에 대비)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.tableView?.endRefreshing(at: .bottom)
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
            
            var tempList : Array<NoticeObject>! = Array()
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
                        if idx.isEqual(temp){
                            tempList.remove(at: i)
                        }
                    }
                }
            }
            
            if(tempList.count > 0){
                self.noticeList.append(contentsOf: tempList)
                self.tableView?.reloadData()
            }
            
        })
    }
    
    //네비게이션바 새로운 글
    func navToWriteHandle(){
        //게시판생성뷰 이동
        
        let vc = UIStoryboard(name: "BoardCreate", bundle: nil).instantiateInitialViewController() as! BoardCreateViewController
        
        vc.delegate = self
        
        showViewController(vc, true)
        
    }
    
    func returnHome(){
        closeViewController(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        naviBar.barStyle = .black
        naviBar.barTintColor = Common().defaultColor
        naviBar.tintColor = .white
        naviBar.isTranslucent = true
        
        self.view.addSubview(naviBar)
        
        let statusBar = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 20))
        statusBar.backgroundColor = Common().defaultStatusColor
        self.view.addSubview(statusBar)
        
        
        //RefreshController Setting
        self.refreshController = UIRefreshControl()
    
        
        //Setting View & Table View
        self.view.backgroundColor = .white
        self.tableView?.backgroundColor = UIColor(netHex: 0xAAAAAA)
        
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 260
        
        
        self.tableView.tableFooterView? = UIView()
        self.tableView.tableHeaderView? = UIView()
        
        //Pull to Refresth Setting
        setupPullToRefresh()
        
        
        //Load Data
        loadEvent()
    }


    
    //반드시 적어줘야함 (PullToRefresh를 사용할 경우)

    deinit {
        self.tableView.removePullToRefresh(tableView.topPullToRefresh!)
        self.tableView.removePullToRefresh(tableView.bottomPullToRefresh!)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source


    //표현할 섹션(섹션은 사용할 만큼의 고정값을 줘야 한다)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    //Section 당 표현 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.noticeList.count
        }else {
            return self.boardList.count
        }
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Notice Section
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: noticeReuseIndentifier, for: indexPath) as! NoticeTableCell
            
            cell.lable?.text = self.noticeList[indexPath.row].text
            cell.lable.textAlignment = .left
            
            return cell
        //Board Section
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: boardReuseIndentifier, for: indexPath) as! BoardTableCell
            
            let boardObj = self.boardList[indexPath.row]
            
            //Add TagGestureRecognizer
            let tabGesture = UITapGestureRecognizer(target: self, action: #selector(tabGestureAction(_:)))
            cell.textRecorded?.tag = indexPath.row
            cell.textRecorded?.addGestureRecognizer(tabGesture)
            
            cell.dataObject = boardObj
            
            let str : String! = boardObj.bodyText
            
             //TO-DO : 현재 보여지는 글의 범위를 위한 계산
            let numLines = (cell.textRecorded?.contentSize.height)!/(cell.textRecorded?.font?.lineHeight)!;
            
            print("***** >> \(numLines) , \(cell.indexPath?.row)")
            
            
            //더보기 추가 (현재는 글자수의 갯수에 따라서 바뀜) -> 현재 보이는 최소 라인값의 범위를 구해야함
            if(str.utf16.count >= maxSize){
                let readMore = "...더 보기"
                
                var tmp : String = (str as NSString).substring(with: NSRange(location:0, length: maxSize))
                tmp += readMore
                
                let attribs = [NSForegroundColorAttributeName : UIColor.black, NSFontAttributeName: UIFont.systemFont(ofSize: 13)]
                let attributedStr = NSMutableAttributedString(string: tmp, attributes: attribs)
                attributedStr.addAttribute(NSLinkAttributeName, value: "", range: NSRange(location: maxSize, length: readMore.utf16.count))
                
                cell.textRecorded?.text = "" //초기화
                
                //확장여부로 인해 달라지게 표현
                if !cell.isExpend {
                    cell.textRecorded?.attributedText = attributedStr
                    cell.originalText = boardObj.bodyText
                }else{
                    cell.textRecorded?.text = boardObj.bodyText
                    cell.originalText = ""
                }
            }else {
                cell.textRecorded?.text = "" //초기화
                cell.textRecorded?.text = str
                
                cell.originalText = ""
            }
         
            cell.likeButton?.isSelected = false //버튼 선택 초기화
            
            //Like버튼 선택 여부
            if let like = boardObj.like {
                if let _ = like[(FIRAuth.auth()?.currentUser?.uid)!] {
                    cell.likeButton.isSelected = true
                }else{
                    cell.likeButton.isSelected = false
                }
            }
            
            //프로필 이미지 처리(이미 캐싱이 되어 있지만 순차적으로 표현되도록 만듬)
            cell.profileImage?.sd_setImage(with: URL(string:boardObj.profileImgUrl!), placeholderImage: UIImage(named:"User"), options: .retryFailed, completed: { (image, error, cachedType, url) in
                
                
                //이미지캐싱이 안되있을경우에 대한 애니메이션 셋팅_imageView.alpha = 1;
                if cell.profileImage != nil, cachedType == .none {
                    
                    cell.profileImage?.alpha = 0
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        cell.profileImage?.alpha = 1
                    }, completion: { (finished) in
                        cell.profileImage?.alpha = 1
                    })
                }
            })
            
            cell.indexPath = indexPath
            
            cell.delegate = self
            
            return cell
        }
    }
    
    //TO-DO : 현재 보여지는 글의 범위
    func visibleTextRagne(_ textView : UITextView) -> NSRange{
        return NSRange()
    }
  
    // 공지사항 위에 여백을 준다.
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0) {
            return 10
        }
        return 0
    }
    
    //셀 선택시
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if(indexPath.section == 0){
            let noticeObj = self.noticeList[indexPath.row]
            
            let actionController = UIAlertController(title: "확인창", message: "해당 공지사항을 내리겠습니까?", preferredStyle: .alert)
            //공지사항 삭제
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: { (Void) in
                
                self.noticeRef.child(noticeObj.noticeKey).removeValue(completionBlock: { (error, ref) in
                    guard error == nil else {
                        return
                    }
                    let key = ref.key
                    
                    
                    for (idx,obj) in self.noticeList.enumerated() {
                        if obj.noticeKey == key {
                            self.noticeList.remove(at: idx)
                            
                            self.tableView.deleteRows(at: [IndexPath(row: idx, section: 0)], with: .none)
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
            
            //TO-DO : 그룹의 권한정보에 따른 삭제설정
            
        }else{
            

            let boardDetailController = UIStoryboard(name: "BoardDetail", bundle: nil).instantiateInitialViewController() as! BoardDetailController
            boardDetailController.boardData = self.boardList[indexPath.row]
            
            let navigationController = UINavigationController(rootViewController: boardDetailController)
            
            navigationController.isNavigationBarHidden = false
            
            showViewController(navigationController, true)
            
        }

    }
  
    // MARK : - BoardTableCell Delegate
    
    //menuButtonEvent
    func menuButtonEvent(sender: UIButton, cell: BoardTableCell) {
        
        //초기값
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
                        
                        let count = self.noticeList.count   //현재 공지사항의 갯수
                        
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
                            if obj.noticeKey == snapshot.key{
                                idx = idx + 1
                            }
                        }
                        
                        
                        if(idx == -1 || self.noticeList.count == 0) {
                            self.noticeList.append(obj)
                        }
                        
                        if(count < self.noticeList.count){
                            let _indexPath = IndexPath(row:self.noticeList.count-1, section: 0)
                            self.tableView.insertRows(at: [_indexPath], with: .none)
                            self.tableView.reloadRows(at: [_indexPath], with: .none)
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
                if(cell.key == val.noticeKey){
                    indexPath = IndexPath(row: idx, section: 0)
                    
                    noticeKey = val.noticeKey
                }
            }
            
            self.noticeRef.child(noticeKey!).removeValue(completionBlock: { (error, ref) in
                guard error == nil else {
                    return
                }
                
                let key = ref.key
                
                for (i,obj) in self.noticeList.enumerated() {
                    if obj.noticeKey == key {
                        self.noticeList.remove(at: i)
                        self.tableView.deleteRows(at: [IndexPath(row: i, section: 0)], with: .none)
                    }
                }
                
            })
            
            self.noticeRef.observeSingleEvent(of: .childRemoved, with: { (snapshot) in
                guard snapshot.exists() else{
                    return
                }
                
                let dict = snapshot.value as! [String : Any]
                
                if(boardKey == dict["boardKey"] as? String){
                    self.tableView.deselectRow(at: indexPath!, animated: true)
                    self.noticeList.remove(at: (indexPath?.row)!)
                }
            })
            
        }
        
        //글 수정 액션
        let editAction = UIAlertAction(title: "글 수정", style: .default) { (Void) in
            
            
            let boardEditViewController = UIStoryboard(name: "BoardCreate", bundle: nil).instantiateInitialViewController() as! BoardCreateViewController
            
            boardEditViewController.boardData = cell.dataObject //데이터 오브젝트를 보댄다
            boardEditViewController.cellDelegate = cell         //현제 셀의 정보를 넘긴다.
            
            boardEditViewController.delegate = self             //수정후 처리를 위한 델리게이트르 넘긴다.
            
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
                        let obj = self.boardList[(cell.indexPath?.row)!]
                        
                        if obj.boradKey == key{
                            self.boardList.remove(at: (cell.indexPath?.row)!)
                            
                            self.tableView.deleteRows(at: [(cell.indexPath)!], with: .automatic)
            
                            
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
    
    //like Button Event
    func likeButtonEvent(sender: UIButton, cell: BoardTableCell) {
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
            let obj = self.boardList[(cell.indexPath?.row)!]
            
            cell.likeButton?.isSelected = flag
            obj.like = dict["like"] as! Dictionary<String, Bool>?
            obj.likeCount = dict["likeCount"] as! Int
            
            self.tableView.reloadRows(at: [cell.indexPath!], with: .none)
        })
    }
    
    //reply Button Event
    func replyButtonEvent(sender: UIButton, cell: BoardTableCell) {
        let vc = UIStoryboard(name: "BoardDetail", bundle: nil).instantiateInitialViewController() as! BoardDetailController
        vc.boardData = cell.dataObject
        
        showViewController(vc, true)
    }
    
    //share Button Event
    func shareButtonEvent(sender: UIButton, cell: BoardTableCell) {
        
        var str = cell.textRecorded?.text ?? ""
 
        if(str.utf16.count < cell.originalText.utf16.count){
            str = cell.originalText!
        }
        
        let activityViewController = UIActivityViewController(activityItems: [str], applicationActivities: [])
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    //ReadMore Event
    func readMoreEvent(cell: BoardTableCell) {
        tableView.beginUpdates()
        tableView.endUpdates()
        
        tableView.scrollToRow(at: cell.indexPath!, at: .top, animated: false)
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
    func afterEdit(ref : FIRDatabaseReference, cell : BoardTableCell?, _ isNew : Bool = false) {
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard snapshot.exists() else {
                return
            }
            
            let value = snapshot.value as! [String : Any]
            
            if !isNew {
                let bObj = self.boardList[(cell?.indexPath?.row)!]
                
                var nObj : NoticeObject?
                var index = -1
                for (idx, value) in self.noticeList.enumerated() {
                    if value.noticeKey == snapshot.key {
                        nObj = self.noticeList[idx]
                        index = idx
                    }
                }
                
                bObj.bodyText = value["text"] as? String
                bObj.editTimeDouble = value["editTime"] as? Double
                bObj.editTime = NSDate(timeIntervalSince1970: (value["editTime"] as? Double)! / 1000).toString().appending(" 수정됨")
                
                
                self.boardList[(cell?.indexPath?.row)!]  = bObj
                
                var indexPaths : Array<IndexPath> = Array()
                
                indexPaths.append((cell?.indexPath)!)
                self.tableView.reloadRows(at: indexPaths, with: .top)
                
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
                        self.tableView.reloadRows(at: indexPaths, with: .top)
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
                self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                
            }
        })
    }
    
    //TextView TabGesture Action
    func tabGestureAction(_ sender:UITapGestureRecognizer){
        let _view = sender.view as? UITextView
        
        let cell = tableView.cellForRow(at: IndexPath(row: (_view?.tag)!, section: 1)) as? BoardTableCell
        
        print("Tab >>>> \(String(describing: cell?.isExpend))")

        
        if((cell?.isExpend)!){
            cell?.isExpend = false
            
            self.tableView.reloadData()
            
            self.tableView.scrollToRow(at: IndexPath(row: (_view?.tag)!, section: 1), at: .top, animated: true)
        }else{
            tableView(tableView, didSelectRowAt: IndexPath(row: (_view?.tag)!, section: 1))
        }
    }

    
}

/*
 
 BoardTableViewController Extension
 
 */

//PullToRefresh Setting
private extension BoardTableViewController {
    
    func setupPullToRefresh() {
        tableView?.addPullToRefresh(PullToRefresh()) { [weak self] in
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                print("top reload start------")
                self?.loadOfPosts((self?.pageOfPosts)!,true)
                
            }
        }
        
        tableView?.addPullToRefresh(PullToRefresh(position: .bottom)) { [weak self] in
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                print("botton reload start------")
                self?.appendingOfPosts((self?.pageOfPosts)!)
            }
        }
    }
}




/*
 
 추가적인 Extension구현을 위한 구간(공통)
 
 */

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

//AutoLayout을 생성하기 위한 함수
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

//UIColor rgb , Hex버전으로 변경
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
    
    convenience init(netHex:Int, alpha:Float) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff, alpha : alpha)
    }
}


extension UIViewController {
    
    //새로운 뷰를 띄울경우 사용 할것 (가장 최상단의 뷰어를 찾아서 present를 한다)
    func showViewController(_ viewController: UIViewController,_ animated : Bool,_ completion :(() -> Swift.Void)? = nil){
        var activateController = UIApplication.shared.keyWindow?.rootViewController
        
        if(activateController?.isKind(of: UINavigationController.self))!{
            activateController = (activateController as! UINavigationController).visibleViewController
        }else if((activateController?.presentedViewController) != nil){
            activateController = activateController?.presentedViewController
        }
        
        activateController?.present(viewController, animated: animated, completion: completion)
    }
    
    //현재 띄워진 뷰어를 닫는다. (잘 생각하고 쓰세요)
    //가능하면 self.dismiss 를 사용 할것
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

extension UIImage {
    //resizing Image
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x:0, y:0, width:newSize.width, height:newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
