import UIKit
import Firebase
import Toaster

private let boardPostChildName = "Board-Posts"
private let noticePostChildName = "Notice-Posts"


class BoardCreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var toolbarView: UIView!
    @IBOutlet weak var toolbarViewBottomAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var addPhotoButton: UIButton!
    
    var boardData: BoardObject!
    var delegate: BoardTableViewController?
    var cellDelegate : BoardTableCell?
    
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
        
        //2017.02.24
        //수정할 값이 들어올경우 기본 텍스트에 표기
        if boardData != nil {
            self.textView.text = boardData.bodyText
        }
    }
    
    
    func backNavHandler(){
        dismiss(animated: true, completion: nil)
    }
    
    func doneHandler(){
        
        debugPrint(textView.text)
        debugPrint(textView.textStorage)
        
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        if textView.text.characters.count > 0 {
            var key = boardRef.childByAutoId().key
            
            var value : [String : Any] = [
                "text" : textView.text,
                "recordTime" : FIRServerValue.timestamp(),
                "author" : [
                    "uid" : FIRAuth.auth()?.currentUser?.uid,
                    "profile_url" : "url",
                    "userName" : "Tester"
                ]
            ]
            
            //June Kang - 2017.02.23 추가적인 수정 로직 만듬
            if(boardData != nil){
                
                key = boardData.boradKey!
                value["editTime"] = FIRServerValue.timestamp()
                value["recordTime"] = boardData.recordTimeDouble
                
                var userObj = value["author"] as! [String : Any]
                userObj["uid"] = boardData.authorId
                userObj["userName"] = boardData.authorName
                userObj["profile_url"] = boardData.profileImgUrl
                
                value["author"] = userObj
                
                if boardData.like != nil{
                    value["like"] = boardData.like
                    value["likeCount"] = boardData.likeCount
                }
                
            }
            
            //데이터가 있을경우 수정 없을경우 생성
            boardRef.child(key).updateChildValues(value) { error, ref in
                if let err = error {
                    debugPrint(err.localizedDescription)
                    Toast(text: "실패").show()
                }else{
                    self.textView.resignFirstResponder()
                    self.textView.text = nil
                    Toast(text: "성공").show()
                    
                    self.dismiss(animated: true, completion: {
                        if self.boardData != nil{
                            //수정후 처리
                            self.delegate?.afterEdit(ref: ref, cell : self.cellDelegate!)
                        } else {
                            //생성 후 처리
                            self.delegate?.afterEdit(ref: ref, cell : nil, true)
                        }
                    })
                }
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
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
    
    @IBAction func addPhotoHandle(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let textAttachment = NSTextAttachment()
        textAttachment.image = image
        
        let oldWidth = textAttachment.image!.size.width;
        
        let scaleFactor = oldWidth / (textView.frame.size.width - 20) //for the padding inside the textView
        textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
        
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
        //attributedString.replaceCharacters(in: NSMakeRange(6, 1), with: attrStringWithImage)
        textView.attributedText = attrStringWithImage
        
        textView.font = UIFont.systemFont(ofSize: 18)
        
        dismiss(animated: true, completion: nil)
    }
}
