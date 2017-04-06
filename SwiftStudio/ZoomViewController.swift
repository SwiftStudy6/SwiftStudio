import UIKit
import SDWebImage
import Firebase

private let reuseIdentifier = "Cell"

class ZoomCollectionViewCell: UICollectionViewCell {
    
    var image: String! {
        didSet {
            let url = URL(string: image)
            imageView.sd_setImage(with: url)
        }
    }
    
    let imageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleToFill
        
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .red
        
        addSubview(imageView)
        
        addConstraintWithFormat("H:|[v0]|", imageView)
        addConstraintWithFormat("V:|[v0]|", imageView)
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        print(layoutAttributes.frame.origin.y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ZoomViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var delegate: BoardDetailController!
    var images = [String]()
    var selectedIndex: Int = 1
    var currentIndex: Int = 0
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let frame = self.view.frame
        let v = UICollectionView(frame: frame, collectionViewLayout: layout)
        return v
    }()
    
    lazy var navBar: UINavigationBar = {
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: 44))
        
        navBar.isTranslucent = false
        navBar.barTintColor = .black
        navBar.backgroundColor = .black
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        return navBar
    }()
    
    lazy var closeButtonItem: UIBarButtonItem = {
        let v = UIBarButtonItem(title: "닫기", style: .done, target: self, action: #selector(hideView))
        v.tintColor = .white
        return v
    }()
    
    lazy var downButtonItem: UIBarButtonItem = {
        let v = UIBarButtonItem(title: "다운로드", style: .done, target: self, action: #selector(downImageHandle))
        v.tintColor = .white
        return v
    }()
    
    lazy var removeButtonItem: UIBarButtonItem = {
        let v = UIBarButtonItem(title: "삭제", style: .done, target: self, action: #selector(removeImageHandle))
        v.tintColor = .white
        return v
    }()
    
    let navItem: UINavigationItem = {
        let item = UINavigationItem()
        return item
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navItem.title = "\(selectedIndex+1)/\(images.count)"
        navItem.leftBarButtonItem = closeButtonItem
        navItem.rightBarButtonItems = [removeButtonItem, downButtonItem]
        navBar.setItems([navItem], animated: false)
        
        
        view.addSubview(navBar)
        
        view.backgroundColor = .black
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideView))
        tapGesture.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGesture)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        
        view.addSubview(collectionView)
        
        //view.addConstraintWithFormat("H:|[v0]|", collectionView)
        //view.addConstraintWithFormat("V:[v0(200)]", collectionView)
        //view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        
        //view.addConstraintWithFormat("V:|[v0]|", collectionView)
        
        
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            let height = (self.view.frame.width / self.collectionView.frame.width) * self.collectionView.frame.height
            
            let y = self.view.frame.height / 2 - height / 2
            
            
            self.collectionView.frame = CGRect(x: 0, y: Int(y), width: Int(self.view.frame.width), height: Int(height))
            
        }, completion: nil)
        
        self.collectionView.isPagingEnabled = true
        self.collectionView.register(ZoomCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    
    
    func downImageHandle(){
        let aletCtrl = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: "저장", style: .default) { (action) in
            print("저장")
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        aletCtrl.addAction(action)
        aletCtrl.addAction(cancelAction)
        
        present(aletCtrl, animated: true, completion: nil)
    }
    
    func removeImageHandle(){
        let aletCtrl = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: "삭제", style: .destructive) { (action) in
            print("삭제")
            
            let url = self.images[self.selectedIndex]
            self.delegate.removeImage(downloadUrl: url)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        aletCtrl.addAction(action)
        aletCtrl.addAction(cancelAction)
        
        present(aletCtrl, animated: true, completion: nil)
    }
    
    func hideView(){
        delegate.hideZoomInPhotoView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ZoomCollectionViewCell
        cell.image = images[indexPath.item]
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let imageStr = images[indexPath.item]
        let url = URL(string: imageStr)
        let data = NSData(contentsOf: url!)
        let image = UIImage(data: data as! Data)
        
        return CGSize(width: self.collectionView.frame.width, height: (image?.size.height)! * self.view.frame.width / (image?.size.width)!)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = NSIndexPath(item: Int(index), section: 0)
        
        currentIndex = indexPath.item
        
        navItem.title = "\(indexPath.item + 1)/\(images.count)"
    }
}
