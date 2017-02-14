import UIKit
import Firebase
import Toaster

private let boardPostChildName = "Board-Posts"
private let noticePostChildName = "Notice-Posts"


class BoardCreateViewController: UIViewController {
    
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var toolbarView: UIView!
    @IBOutlet weak var toolbarViewBottomAnchor: NSLayoutConstraint!
    
    var delegate: MainViewController?
    
    private var ref : FIRDatabaseReference! = FIRDatabase.database().reference()
    private var boardRef : FIRDatabaseReference! = FIRDatabase.database().reference().child(boardPostChildName)
    private var noticeRef : FIRDatabaseReference! = FIRDatabase.database().reference().child(noticePostChildName)
    
    lazy var doneBarButtonItem: UIBarButtonItem = {
        let bar = UIBarButtonItem(title: "생성", style: .plain, target: self, action: #selector(doneHandler))
        return bar
    }()
    
    lazy var backBarButtonItem: UIBarButtonItem = {
        let bar = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(backNavHandler))
        return bar
    }()
    
    lazy var loadingBarButtonItem: UIBarButtonItem = {
        let loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingView.hidesWhenStopped = true
        let bar = UIBarButtonItem(customView: loadingView)
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "게시글 생성"
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.rightBarButtonItem = doneBarButtonItem
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem = backBarButtonItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        
        //네비게이션바 세팅
        navBar.items = [navigationItem]
    }
    
    func backNavHandler(){
        dismiss(animated: true, completion: nil)
    }
    
    func doneHandler(){
        navigationItem.rightBarButtonItem?.isEnabled = false
        if textView.text.characters.count > 0 {
            let value : [String : Any] = [
                "text" : textView.text,
                "recordTime" : FIRServerValue.timestamp(),
                "author" : [
                    "uid" : "test",
                    "profile_url" : "url",
                    "userName" : "song"
                ]
            ]
            boardRef.childByAutoId().setValue(value) { error, ref in
                if let err = error {
                    debugPrint(err.localizedDescription)
                    Toast(text: "실패").show()
                }else{
                    self.textView.resignFirstResponder()
                    self.textView.text = nil
                    Toast(text: "성공").show()
                }
                
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
        
//        let board = Board()
//        board.content = textView.text
//        board.time = "지금 막"
//        board.id = UInt((delegate?.boards.count)!)
//        board.likeCount = 0
//        
//        let user = User()
//        user.userName = "SHW"
//        user.id = 190
//        
//        
//        board.user = user
//        
//        delegate?.addBoard(data: board)
//        
//        textView.text = ""
//        
//        navigationController?.popViewController(animated: true)
        //loadingView.stopAnimating()
        //textView.resignFirstResponder()
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
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.lengthOfBytes(using: .utf8) > 0 {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }else{
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}
