import UIKit

class User: NSObject {
    public var id: UInt!
    public var userName: String!
    public var avatar: String?
}

class Reply: NSObject {
    public var id: UInt!
    public var content: String!
    public var user: User!
    public var time: String!
}

class BoardDetailCell: UITableViewCell {
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    var reply: Reply? {
        didSet {
            if let content = reply?.content {
                contentLabel.text = content
            }
            if let time = reply?.time {
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
        //tableView.keyboardDismissMode = .interactive
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
        
        
        navigationItem.title = "게시글 생성"
        navigationController?.navigationBar.isTranslucent = false
        
        //David June Kang  -----------------------------------------------------------------------------------------------------
        
        //17.01.26 - 백버튼 추가
        //17.02.01 - 백버튼 커스터마이징
        
        self.view.backgroundColor = .white //배경색을 하얀색으로 둔다.(필수)
        
        //버튼을 위한 색상설정
        let defaultColor = UIColor(red: 0, green: 112, blue: 225, alpha: 1.0)   //Apple Default Color
        let defaultColor2 = UIColor(red: 0, green: 112, blue: 225, alpha: 0.25)
        
        //뒤로가기버튼
        let backButton = UIButton(frame: CGRect(x: 0, y: 10, width: 60, height: 30))
        backButton.addTarget(self, action: #selector(backHandler), for: .touchUpInside)
        backButton.setTitle("< Back", for: .normal)
        backButton.titleLabel?.textAlignment = .left
        backButton.setTitleColor(defaultColor, for: .normal)
        backButton.setTitleColor(defaultColor2, for: .highlighted)
        
        //버튼아이템 커스텀
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftBarButtonItem

        //네비바를 강제로 넣는다.
        let naviBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
        naviBar.items = [navigationItem]
        naviBar.barTintColor = .white
        self.view.addSubview(naviBar)
        
        //위에서 70포인트를 내린다 ( 20 (상태바) + 50 (네비바) )
        self.tableView.frame = CGRect(x: 0, y: 70, width: self.view.frame.width, height: self.tableView.frame.height-70)
        
        
        //---------------------------------------------------------------------------------------------------------------------

        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        
        fetchReplys()
    }
    
    
    func backHandler(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    func fetchReplys(){
        self.isLoading = true
        
        
        while page < 10 {
            
            createReply()
            page += 1
        }
        
        DispatchQueue.main.async {
            self.isLoading = false
            self.tableView.reloadData()
        }
        
    }
    
    func createReply(){
        let reply = Reply()
        reply.content = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        
        reply.id = page
        reply.time = "어제밤"
        
        let user = User()
        user.id = page
        user.userName = "user \(page+1)"
        
        reply.user = user
        
        
        replys.append(reply)
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
    
    @IBAction func sendAction(_ sender: UIButton) {
        //toolbarTextView.resignFirstResponder()
        
        
        let reply = Reply()
        reply.content = toolbarTextView.text
        reply.id = 200
        reply.time = "방금막"
        
        let user = User()
        user.userName = "SHW"
        user.id = 190
        
        reply.user = user
        
        tableView.beginUpdates()
        replys.insert(reply, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        tableView.endUpdates()
        
        
        toolbarTextView.text = ""
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
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
