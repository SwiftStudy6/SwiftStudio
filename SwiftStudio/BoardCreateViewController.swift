import UIKit

class BoardCreateViewController: UIViewController {
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var toolbarView: UIView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var toolbarViewBottomAnchor: NSLayoutConstraint!
    
    var delegate: MainViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "게시글 생성"
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneHandler))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func doneHandler(){
        loadingView.startAnimating()
        
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
