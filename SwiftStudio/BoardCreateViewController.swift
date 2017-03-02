import UIKit
import Firebase
import Toaster


class CustomImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var delegate: BoardCreateViewController!
    //var idx: Int!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        //imageView.backgroundColor = .blue
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tabAction))
        addGestureRecognizer(tapGesture)
    }
    
    func tabAction(sender: UITapGestureRecognizer){
        delegate.addPhotoHandle(cell: self)
    }


}


private let boardPostChildName = "Board-Posts"
private let noticePostChildName = "Notice-Posts"


class BoardCreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var toolbarView: UIView!
    @IBOutlet weak var toolbarViewBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var boardData: BoardObject!
    var delegate: MainViewController?
    
    let currentUser = FIRAuth.auth()?.currentUser
    
    let storageRef = FIRStorage.storage()
    
    
    var images = [UIImage]()
    
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
    
    lazy var downBarButtonItem: UIBarButtonItem = {
        let bar = UIBarButtonItem(title: "키보드 다운", style: .plain, target: self, action: #selector(downKeyboardHandler))
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
    
    func downKeyboardHandler(){
        textView.resignFirstResponder()
    }
    
    func uploadImage(_ image: UIImage, _ name: String, with completion:@escaping (_ success:Bool, _ url:String?) -> ()){
        
        //let imageName = NSUUID().uuidString
        
        let data = UIImageJPEGRepresentation(image, 0.1)
        let path = "Board/\(name).jpg"
        
        self.storageRef.reference(withPath: path).put(data!, metadata: nil, completion: { (metaData, err) in
            if let err = err {
                print(err.localizedDescription)
                completion(false, nil)
                
            }else if let meta = metaData, let url = meta.downloadURL() {
                completion(true, url.absoluteString)
            }
        })
    }
    
    func uploadImages(images: [UIImage], with completion:@escaping (_ urls:[String]) -> ()){
        var urls = [String]()
        
        let count = images.count
        var idx = 0
        
        for image in images {
            idx += 1
            uploadImage(image, ""){ (success: Bool, url: String?) in
                if success {
                    if let url = url {
                        print(url)
                        urls.append(url)
                    }
                }
                
                if idx == count {
                    completion(urls)
                }
            }
        }
    }
    
    func uploadImageAndUpdateBoardData(key: String, with completion:@escaping (_ success: Bool) -> ()){
        
        var urls = [String]()
        var idx = 0
        let count = self.images.count
        
        for image in self.images {
            idx += 1
            let name = "\(key)_\(idx)"
            uploadImage(image, name){ (success: Bool, url: String?) in
                if success {
                    if let url = url {
                        urls.append(url)
                    }
                }
                
                if idx == count {
                    print(urls)
                    let value = ["attachments" : urls]
                    self.boardRef.child(key).updateChildValues(value)
                    
                    completion(true)
                }
            }
        }
        
    
    }
    
    func doneHandler(){
        //debugPrint(textView.text)
        //debugPrint(textView.textStorage)
        
        guard let user = currentUser else{
            return
        }
        
        
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        if textView.text.characters.count > 0 { //save content
            //profile image upload
            
            var value : [String : Any] = [
                "text" : textView.text,
                "recordTime" : FIRServerValue.timestamp(),
                "author" : [
                    "uid" : user.uid,
                    "profile_url" : "url",
                    "userName" : "test" //user.displayName
                ],
                "attachments" : []
            ]
            
            
            boardRef.childByAutoId().setValue(value) { error, ref in
                if let err = error {
                    debugPrint(err.localizedDescription)
                    Toast(text: "실패").show()
                }else{
                    
                    self.uploadImageAndUpdateBoardData(key: ref.key){ (_ success) in
                        self.textView.resignFirstResponder()
                        self.textView.text = nil
                        self.images.removeAll()
                        
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                        
                        Toast(text: "성공").show()
                    }
                    
                    
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
            
            self.navigationItem.leftBarButtonItem = self.backBarButtonItem
            
        }else { //keyboard show
            self.toolbarViewBottomAnchor?.constant = keyboardEndFrame.height
            
            self.navigationItem.leftBarButtonItem = self.downBarButtonItem
            
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
    
    
    var cell: UICollectionViewCell!
    
    func addPhotoHandle(cell: UICollectionViewCell) {
        
        let alertCtrl = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        
        
        let photoLib = UIAlertAction(title: "앨범에서 사진선택", style: .default) { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                imagePicker.allowsEditing = false
                
                
                self.cell = cell
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { (action) in
            if let cell = cell as? CustomImageCell {
                
                if let indexPath = self.collectionView.indexPath(for: cell) {
                    self.images.remove(at: indexPath.item)
                    cell.imageView.image = nil
                    
                    let count = self.collectionView.numberOfItems(inSection: 0)
                    
                    
                    if count > 1 {
                        print("cell count : ", count)
                        print("indexPath : ", indexPath.item)
                        self.collectionView.deleteItems(at: [indexPath])
                        //self.collectionView.deselectItem(at: indexPath, animated: true)
                    }
                }
                
            }
        }
        
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        
        alertCtrl.addAction(photoLib)
        if let cell = cell as? CustomImageCell {
            if cell.imageView.image != nil {
                alertCtrl.addAction(deleteAction)
            }
        }
        
        alertCtrl.addAction(cancelAction)
        
        present(alertCtrl, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
//        let imageUrl = info[UIImagePickerControllerReferenceURL] as! NSURL
//        let imageName = imageUrl.lastPathComponent
//        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//        let photoURL = NSURL(fileURLWithPath: documentDirectory)
//        let localPath = photoURL.appendingPathComponent(imageName!)
//        
//        print(localPath)
        
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
        if let cell = self.cell as? CustomImageCell {
            
            let indexPath = self.collectionView.indexPath(for: cell)
            
            if cell.imageView.image != nil { //update
                
                self.images[(indexPath?.item)!] = image
                
                
            }else{ //insert
                self.images.append(image)
                let indexPath = NSIndexPath(item: self.images.count, section: 0)
                collectionView.insertItems(at: [indexPath as IndexPath])
            }
            
            cell.imageView.image = image
        }
        
        
        
//        
//        let textAttachment = NSTextAttachment()
//        textAttachment.image = image
//        
//        let oldWidth = textAttachment.image!.size.width;
//        
//        let scaleFactor = oldWidth / (textView.frame.size.width - 20) //for the padding inside the textView
//        textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
//        
//        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
//        //attributedString.replaceCharacters(in: NSMakeRange(6, 1), with: attrStringWithImage)
//        textView.attributedText = attrStringWithImage
//        
//        textView.font = UIFont.systemFont(ofSize: 18)
//        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CustomImageCell
        
        cell.imageView.backgroundColor = .red
        cell.delegate = self
        
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100 - 8 - 8, height: 100 - 8 - 8)
    }
}
