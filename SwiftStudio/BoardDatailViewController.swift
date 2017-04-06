import UIKit
import Firebase
import Toaster
import SDWebImage

class User: NSObject {
    public var uid: String!
    public var userName: String!
    public var profile_url: String?
}

class Reply: NSObject {
    public var replyKey: String!
    public var text: String!
    public var user: User!
    public var recordTime: String!
}

class BoardDetailCell: UITableViewCell {
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    var reply: Reply? {
        didSet {
            if let content = reply?.text {
                contentLabel.text = content
            }
            if let time = reply?.recordTime {
                timeLabel.text = time
            }
            
            if let user = reply?.user {
                if let userName = user.userName {
                    userNameLabel.text = userName
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


class BoardDetailImageCell: UICollectionViewCell {
    
    var delegate: BoardDetailController!
    
    @IBOutlet weak var imageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showZoomInPhotoView))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
    }
    
    func showZoomInPhotoView(){
        delegate.showZoomInPhotoView(imageView: imageView, cell: self)
    }
}

class BoardDetailController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    private var page: UInt = 0
    private var isLoading = false
    
    private var replyRef: FIRDatabaseReference! = FIRDatabase.database().reference().child("Board-Replys")
    
    private var boardRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Board-Posts")
    private var noticeRef : FIRDatabaseReference! = FIRDatabase.database().reference().child("Notice-Posts")
    
    private var storageRef = FIRStorage.storage()
    
    var delegate: MainViewController?
    var boardData: BoardObject?
    var replys = [Reply]()
    var images = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolbarView: UIView!
    @IBOutlet weak var toolbarAddButton: UIButton!
    @IBOutlet weak var toolbarTextView: UITextView!
    @IBOutlet weak var toolbarViewBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var toolbarViewHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var toolbarTextViewRightAnchor: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView.isScrollEnabled = false
        
        setupData()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 45
        tableView.tableFooterView = UIView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
        
        
        navigationItem.title = "게시글 생성"
        navigationController?.navigationBar.isTranslucent = false

        //David June Kang  -----------------------------------------------------------------------------------------------------
        
        //17.01.26 - 백버튼 추가
        //17.02.01 - 백버튼 커스터마이징
        //17.02.14 - 네비바 사이즈 70 -> 64로 변경
        self.navigationController?.isNavigationBarHidden = true
        
        let statusOffset : CGFloat = 20.0;
        let heightOffset : CGFloat = 44.0;
        let naviBarOffset : CGFloat = statusOffset + heightOffset;
        
        
        //위에서 70포인트를 내린다 ( 20 (상태바) + 44 (네비바) )
        self.tableView.frame = CGRect(x: 0, y: naviBarOffset, width: self.view.frame.width, height: self.tableView.frame.height-naviBarOffset)
        
        self.view.backgroundColor = .white //배경색을 하얀색으로 둔다.(필수)
        
        //버튼을 위한 색상설정
        let defaultColor = UIColor(red: 0, green: 112, blue: 225, alpha: 1.0)   //Apple Default Color
        let defaultColor2 = UIColor(red: 0, green: 112, blue: 225, alpha: 0.25)
        
        //뒤로가기버튼
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: heightOffset))
        backButton.addTarget(self, action: #selector(backHandler), for: .touchUpInside)
        backButton.setTitle("< Back", for: .normal)
        backButton.titleLabel?.textAlignment = .left
        backButton.setTitleColor(defaultColor, for: .normal)
        backButton.setTitleColor(defaultColor2, for: .highlighted)
        
        //버튼아이템 커스텀
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftBarButtonItem

        //네비바를 강제로 넣는다.
        let naviBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: naviBarOffset))
        naviBar.items = [navigationItem]
        naviBar.barTintColor = .white
        self.view.addSubview(naviBar)
        

        

        //---------------------------------------------------------------------------------------------------------------------

        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        
        fetchReplys()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BoardDetailImageCell
        
        if let url = URL(string: images[indexPath.item]) {
            cell.imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "attachment [#1575].png"))
        }
        
        cell.delegate = self
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        guard let url = URL(string: images[indexPath.item]),
            let data = NSData(contentsOf: url) as? Data else {
            return CGSize(width: 0, height: 0)
        }
        let image = UIImage(data: data)
        
        
        let w = image?.size.width
        let h = image?.size.height
        
        let targetHeight = collectionView.frame.width/w! * h! //w!/h! * collectionView.frame.width
        //targetHeight = targetHeight > 200 ? 200 : targetHeight
        
        return CGSize(width: collectionView.frame.width, height: targetHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    var targetView: UIView?
    
    func showZoomInPhotoView(imageView: UIImageView, cell: UICollectionViewCell){
        //if let startingFrame = imageView.superview?.convert(imageView.frame, to: nil) {
            
            let vc = ZoomViewController()
            
            vc.images = self.images
            vc.delegate = self
            
            addChildViewController(vc)
            
            guard let indexPath = collectionView.indexPath(for: cell) else{
                return
            }
            
            vc.selectedIndex = indexPath.item
            //vc.collectionView.frame = startingFrame
            
            targetView = vc.view
            targetView?.alpha = 0
            view.addSubview(targetView!)
            
            vc.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
            
            UIView.animate(withDuration: 0.4, animations: {
                self.targetView?.alpha = 1
            })
            
        //}
    }
    
    func hideZoomInPhotoView(){
        if let target = self.targetView {
            
            UIView.animate(withDuration: 0.4, animations: {
                target.alpha = 0
            }, completion: { (finish) in
                target.removeFromSuperview()
            })
            
        }
    }
    
    
    func backHandler(){
        dismiss(animated: true, completion: nil)
    }
    
    func fetchReplys(){
        self.isLoading = true
        
        let boardKey = boardData?.boradKey
        
        replyRef.queryOrdered(byChild: "boardKey").queryEqual(toValue: boardKey).observeSingleEvent(of: .value, with: { (snapShot) in
            let enumerate = snapShot.children
            
            for item in enumerate {
                
                if let item = item as? FIRDataSnapshot {
                    let dic = item.value as! [String : Any]
                    let author = dic["author"] as! [String : String]
                    let user = User()
                    user.uid = author["uid"]
                    user.userName = author["userName"]
                    user.profile_url = author["profile_url"]
                    
                    let reply = Reply()
                    reply.replyKey = item.key
                    reply.text = dic["text"] as? String
                    reply.user = user
                    
                    if let time = dic["recordTime"] as? Int {
                        reply.recordTime = NSDate(timeIntervalSince1970: Double(time/1000)).toString()
                    }
                    
                    self.replys.append(reply)
                }
            
            }
            
            DispatchQueue.main.async {
                self.isLoading = false
                self.tableView.reloadData()
            }
        })
    }
    
    func hideKeyboard(){
        toolbarTextView.resignFirstResponder()
    }
    
    func updateTextView(notification: Notification){
        let userInfo = notification.userInfo!
        
        let keyboardEndFrameScreenCoordinates = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardEndFrame = view.convert(keyboardEndFrameScreenCoordinates, to: view.window)
        
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        if notification.name == Notification.Name.UIKeyboardWillHide { //keyboard hide
            self.toolbarViewBottomAnchor?.constant = 0
            
        }else { //keyboard show
            self.toolbarViewBottomAnchor?.constant = keyboardEndFrame.height
            
            
            UIView.animate(withDuration: duration, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
        
    }
    
    var numberLine = 1
    let maxLine = 7
    func textViewDidChange(_ textView: UITextView) {
        if (textView.text?.lengthOfBytes(using: .utf8))! > 0 {
            toolbarTextViewRightAnchor.constant = 60
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
                }, completion: nil)
        }else{
            toolbarTextViewRightAnchor.constant = 10
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
                }, completion: nil)
            
        }
        
        
        let newLine = toolbarTextView.numberOfLines()
        
        if newLine < maxLine {
            if numberLine < newLine {
                toolbarViewHeightAnchor.constant += CGFloat((textView.font?.lineHeight)!)
            }else if numberLine > newLine{
                toolbarViewHeightAnchor.constant -= CGFloat((textView.font?.lineHeight)!)
            }
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
                }, completion: nil)
            
            numberLine = newLine
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
    func setupData(){
        
        
        if let user = boardData?.authorName {
            userNameLabel.text = user
        }
        
        if let content = boardData?.bodyText {
            textView.text = content
            
            var imagesHeight: CGFloat = 0
            
            let contentSize = CGSize(width: view.frame.width, height: 1000)
            let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
            let estimateFrame = NSString(string: content).boundingRect(with: contentSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            imagesHeight += estimateFrame.height
            
            if let attachments = boardData?.attachments {
                self.images = attachments
                
                
                for i in 0..<self.images.count {
                    
                    let imageStr = self.images[i]
                    
                    guard let url = URL(string: imageStr),
                        let data = NSData(contentsOf: url) as? Data else{
                        
                        self.images.remove(at: i)
                        
                        continue
                    }
                    
                    let image = UIImage(data: data)
                    
                    let w = image?.size.width
                    let h = image?.size.height
                    
                    let targetHeight = collectionView.frame.width/w! * h! //w!/h! * collectionView.frame.width
                    //targetHeight = targetHeight > 200 ? 200 : targetHeight
                    imagesHeight += targetHeight + 10
                }

                
                
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                }
                
            }
            
            headerView.frame.size.height = imagesHeight + 50 + 40 + 5 + 8 + 20
            
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
            //let contentSize = CGSize(width: view.frame.width, height: 1000)
            //let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
            //let estimateFrame = NSString(string: content).boundingRect(with: contentSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
//            let attributedString = NSMutableAttributedString(string: content)
//            var imagesHeight: CGFloat = 0
//            
//            if let attachments = boardData?.attachments {
//                if attachments.count > 0 {
//                    for imageString in attachments {
//                        let url = URL(string: imageString)
//                        if let data = NSData(contentsOf: url!) {
//                            let textAttachment = NSTextAttachment()
//                            textAttachment.image = UIImage(data: data as Data)
//                            
//                            let oldWidth = textAttachment.image!.size.width;
//                            
//                            let scaleFactor = oldWidth / (textView.frame.size.width - 10) //for the padding inside the textView
//                            textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
//                            
//                            imagesHeight += (textAttachment.image?.size.height)!
//                            
//                            let attrStringWithImage = NSAttributedString(attachment: textAttachment)
//                            attributedString.append(attrStringWithImage)
//                            //attributedString.replaceCharacters(in: NSMakeRange(6, 1), with: attrStringWithImage)
//                            //textView.attributedText = attrStringWithImage
//                            //textView.font = UIFont.systemFont(ofSize: 14)
//                        }
//                    }
//                    
//                    
//                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapReadTerm))
//                    textView.addGestureRecognizer(tapGesture)
//                }
//            }
//            
//            textView.attributedText = attributedString
//            let contentSize = CGSize(width: view.frame.width, height: 1000)
//            let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
//            let estimateFrame = NSString(string: content).boundingRect(with: contentSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
//            
//            
//            
//            headerView.frame.size.height = estimateFrame.height + imagesHeight + 50 + 40 + 5 + 8 + 20 //(extra)
            
        }
        if let time = boardData?.editTime {
            timeLabel.text = time
        }
        
        
    }
    
    func didTapReadTerm(_ sender: UITapGestureRecognizer){
        guard case let senderView = sender.view, (senderView is UITextView) else {
            return
        }
        
        // calculate layout manager touch location
        let textView = senderView as! UITextView, // we sure this is an UITextView, so force casting it
        layoutManager = textView.layoutManager
        
        var location = sender.location(in: textView)
        location.x -= textView.textContainerInset.left
        location.y -= textView.textContainerInset.top
        
        // find the value
        let textContainer = textView.textContainer,
        characterIndex = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil),
        textStorage = textView.textStorage
        
        guard characterIndex < textStorage.length else {
            return
        }
        
        print("character index: \(characterIndex)")
        
        let myRange = NSRange(location: characterIndex, length: 1)
        let substring = (textView.attributedText.string as NSString).substring(with: myRange)
        print("character at index: \(substring)")
        
        
        let attributeName = "MyCustomAttributeName"
        let attributeValue = textView.attributedText.attribute(attributeName, at: characterIndex, effectiveRange: nil) as? String
        if let value = attributeValue {
            print("You tapped on \(attributeName) and the value is: \(value)")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replys.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BoardDetailCell
        cell.reply = replys[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let reply = replys[indexPath.row]
        if reply.user.uid == "test" {
            return true
        }
        
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            
            let key = replys[indexPath.row].replyKey
            replyRef.child(key!).removeValue(completionBlock: { (err, ref) in
                if err != nil {
                    debugPrint("failed to remove reply")
                    return
                }
                
                tableView.beginUpdates()
                self.replys.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            })
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        let reply = replys[indexPath.row]
        if reply.user.uid == "test" {
            return "삭제"
        }
        
        return ""
    }
    
    @IBAction func sendAction(_ sender: UIButton) {
        guard let boardKey = boardData?.boradKey else {return}
        
        
        let value : [String : Any] = [
            "text" : toolbarTextView.text,
            "recordTime" : FIRServerValue.timestamp(),
            "author" : [
                "uid" : "test",
                "profile_url" : "url",
                "userName" : "song"
            ],
            "boardKey" : boardKey
        ]
        
        replyRef.childByAutoId().setValue(value) { error, ref in
            if let err = error {
                debugPrint(err.localizedDescription)
                Toast(text: "실패").show()
            }else{
                
                debugPrint( ref.key )
                
                
                let user = User()
                user.userName = "song"
                user.uid = "test"
                user.profile_url = "usl"
                
                let reply = Reply()
                reply.replyKey = ref.key
                reply.text = self.toolbarTextView.text
                reply.recordTime = NSDate().toString()
                reply.user = user
                
                Toast(text: "성공").show()
                
                self.toolbarTextView.resignFirstResponder()
                self.toolbarTextView.text = nil
                
                self.tableView.beginUpdates()
                self.replys.insert(reply, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                
                self.tableView.endUpdates()
                
                
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        
    }
    
    func removeImage(downloadUrl: String){
        //let key = boardData?.boradKey
        
        //let path = "Board/\(downloadUrl)"
        
        storageRef.reference(forURL: downloadUrl).delete { (err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            print("success delete")
        }
        
        
    }
    
    @IBAction func moreBtnAction(_ sender: UIButton) {
        
        let user = FIRAuth.auth()?.currentUser
        
        let boardKey = boardData?.boradKey
        let authorId = boardData?.authorId
        
        
        let alertController = UIAlertController(title: "게시물 수정", message: nil, preferredStyle: .actionSheet)
        
        //공지 추가 액션
//        let addNoticeAction = UIAlertAction(title: "공지사항 등록", style: .default) { (Void) in
//            
//            let noticeKey = boardKey!
//            let data : [String : Any] = ["boardKey":boardKey!,
//                                         "author": ["uid":authorId!],
//                                         "text": self.boardData?.bodyText,
//                                         "recordTime": FIRServerValue.timestamp(),
//                                         "editTime": FIRServerValue.timestamp()]
//            if(self.noticeList.count >= 2){
//                Toast(text:"공지사항은 2개 이상 등록 할수 없습니다.").show()
//                return
//            }else{
//                self.noticeRef.child(noticeKey).setValue(data, withCompletionBlock: { (error, ref) in
//                    guard error == nil else {
//                        return
//                    }
//                    
//                    ref.observe(.value, with: { (snapshot) in
//                        guard snapshot.exists() else {
//                            return
//                        }
//                        
//                        let count = self.noticeList.count
//                        
//                        let dict = snapshot.value as! [String : Any]
//                        
//                        let user = dict["author"] as? [String : Any]
//                        
//                        var time : Double = 0
//                        
//                        if let _ = dict["editTime"] {
//                            time = dict["editTime"] as! Double
//                        }else {
//                            time = dict["recordTime"] as! Double
//                        }
//                        
//                        let obj = NoticeObject(snapshot.key,
//                                               user?["uid"] as! String,
//                                               dict["text"] as! String,
//                                               dict["recordTime"] as! Double,
//                                               time)
//                        var idx = -1
//                        for obj in self.noticeList {
//                            if (obj as! NoticeObject).noticeKey == snapshot.key{
//                                idx = idx + 1
//                            }
//                        }
//                        
//                        
//                        if(idx == -1 || self.noticeList.count == 0) {
//                            self.noticeList.append(obj)
//                        }
//                        
//                        if(count < self.noticeList.count){
//                            self.collectionView?.insertItems(at: [IndexPath(row:self.noticeList.count-1, section: 0)])
//                            self.collectionView?.reloadItems(at: [IndexPath(row:self.noticeList.count-1, section: 0)])
//                        }
//                    })
//                })
//            }
//        }
        
        
        
        //공지 삭제 액션
//        let delNoticeAction = UIAlertAction(title: "공지사항 내리기", style: .default) { (Void) in
//            
//            var noticeKey : String?
//            var indexPath : IndexPath?
//            
//            for (idx,val) in self.noticeList.enumerated() {
//                if(cell.key == (val as! NoticeObject).noticeKey){
//                    indexPath = IndexPath(row: idx, section: 0)
//                    
//                    noticeKey = (val as! NoticeObject).noticeKey
//                }
//            }
//            
//            self.noticeRef.child(noticeKey!).removeValue(completionBlock: { (error, ref) in
//                guard error == nil else {
//                    return
//                }
//                
//                let key = ref.key
//                
//                
//                
//                for (i,obj) in self.noticeList.enumerated() {
//                    if(obj as! NoticeObject).noticeKey == key {
//                        self.noticeList.remove(at: i)
//                        self.collectionView?.deleteItems(at: [IndexPath(row: i, section: 0)])
//                    }
//                }
//                
//            })
//            
//            self.noticeRef.observeSingleEvent(of: .childRemoved, with: { (snapshot) in
//                guard snapshot.exists() else{
//                    return
//                }
//                
//                let dict = snapshot.value as! [String : Any]
//                
//                if(boardKey == dict["boardKey"] as? String){
//                    self.collectionView?.deleteItems(at: [indexPath!])
//                    self.noticeList.remove(at: (indexPath?.row)!)
//                }
//            })
//            
//        }
        
        //글 수정 액션
        let editAction = UIAlertAction(title: "글 수정", style: .default) { (Void) in
            
            
            let boardEditViewController = UIStoryboard(name: "BoardCreate", bundle: nil).instantiateInitialViewController() as! BoardCreateViewController
            
            boardEditViewController.boardData = self.boardData //데이터 오브젝트를 보댄다
            //boardEditViewController.cellDelegate = cell         //현제 셀의 정보를 넘긴다.
            
            //boardEditViewController.delegate = self             //수정후 처리를 위한 델리게이트르 넘긴다.
            
            //self.showViewController(boardEditViewController, true)
            self.present(boardEditViewController, animated: true, completion: nil)
        }
        
        //글 삭제 약션
        let delAction = UIAlertAction(title: "글 삭제", style: .destructive) { (Void) in
            let attachments = self.boardData?.attachments
            let confirmControlelr = UIAlertController(title: "확인창", message: "정말로 게시물을 삭제 하실껍니까?\n(복구 안됩니다)", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: { (Void) in
                if(user?.uid == authorId){
                    self.boardRef.child((self.boardData?.boradKey)!).removeValue(completionBlock: { (error, ref) in
                        guard error == nil else {
                            print(error.debugDescription)
                            return
                        }
                        
                        if (attachments?.count)! > 0 {
                            
                            for imgStr in attachments! {
                                print("img url : ", imgStr)
                                self.removeImage(downloadUrl: imgStr)
                            }
                            
                        }
                        
                        self.delegate?.loadEvent()
                        self.closeViewController(true)
                    })
                }
            })
            
            let cancelAtion = UIAlertAction(title: "취소", style: .default, handler:nil)
            
            confirmControlelr.addAction(deleteAction)
            confirmControlelr.addAction(cancelAtion)
            
            
            self.present(confirmControlelr, animated: true, completion: nil)
        }
        
        let cancelAtion = UIAlertAction(title: "취소", style: .cancel, handler:nil)
        
        //alertController.addAction(addNoticeAction)
        //alertController.addAction(delNoticeAction)
        
        
        if(user?.uid == authorId){
            alertController.addAction(editAction)
            alertController.addAction(delAction)
        }
        
        alertController.addAction(cancelAtion)
        
        self.present(alertController, animated: true, completion: nil)
        
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

extension UITextView {
    func numberOfLines() -> Int{
        var contentSize = self.contentSize
        var contentHeight = contentSize.height
        contentHeight -= self.textContainerInset.top + self.textContainerInset.bottom
        
        
        var lines = fabs(contentHeight/(self.font?.lineHeight)!)
        
        if lines == 1 && contentSize.height > self.bounds.size.height {
            contentSize.height = self.bounds.size.height
            self.contentSize = contentSize
        }
        
        if lines == 0 {
            lines = 1
        }
        
        return Int(lines)
    }
}
