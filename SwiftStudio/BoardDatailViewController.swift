import UIKit
import Firebase
import Toaster

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

class BoardDetailController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    private let cellId = "cellId"
    private var page: UInt = 0
    private var isLoading = false
    
    private var replyRef: FIRDatabaseReference! = FIRDatabase.database().reference().child("Board-Replys")
    
    var delegate: MainViewController?
    var boardData: BoardObject?
    var replys = [Reply]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var toolbarView: UIView!
    @IBOutlet weak var toolbarAddButton: UIButton!
    @IBOutlet weak var toolbarTextView: UITextView!
    @IBOutlet weak var toolbarViewBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var toolbarViewHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var toolbarTextViewRightAnchor: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        }
        if let time = boardData?.editTime {
            timeLabel.text = time
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
