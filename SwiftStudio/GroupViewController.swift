//
//  GroupViewController.swift
//  SwiftStudio
//
//  Created by David June Kang on 2017. 2. 1..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit
import Firebase

class GroupObject : NSObject {
    var key         : String! = nil         //Group Unique Key
    var name        : String! = nil         //Group Name
    var managers    : [String : Any]! = nil     //Group Manager List
    var members     : [String : Any]! = nil     //Group Member List
    var privateYn   : Bool! = false         //Group Private Yn
    var purpose     : NSNumber!             //Group Created Purpose
    var coverImgUrl : String! = nil         //Group Cover Image Url
    
    var createTime : Double! = 0.0
    var editTime   : Double! = 0.0
    
    override init() {
        super.init()
        key = ""
        name = ""
        managers = nil
        members = nil
        coverImgUrl = ""
        purpose = 0
    }
}


class GroupCell : UICollectionViewCell {
    
    lazy var imageView: UIImageView! = {
        var _imageView = UIImageView()
        _imageView.contentMode = .scaleToFill
        _imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return _imageView
    }()
    
    lazy var textLabel: UILabel! = {
        var _label = UILabel()
        
        _label.text = ""
        _label.backgroundColor = .white
        _label.font = UIFont.systemFont(ofSize: 26)
        _label.textColor = .black
        _label.numberOfLines = 1
        _label.minimumScaleFactor = 0.6
        _label.adjustsFontSizeToFitWidth = true
        _label.textAlignment = .center
        _label.translatesAutoresizingMaskIntoConstraints = false
        
        return _label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        let size = frame.size
        
        
        addSubview(self.imageView)
        addSubview(self.textLabel)
        
        
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: size.width * 0.75).isActive = true
        

        
        self.textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        self.textLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        self.textLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        self.textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        self.textLabel.heightAnchor.constraint(equalToConstant: size.width * 0.25).isActive = true

//
//        addConstraintWithFormat("H:|[v0]|", imageView)
//        addConstraintWithFormat("H:|[v0]|", textLabel)
//        addConstraintWithFormat("V:|[v0(\(size.height/0.75))]-[v1(\(size.height/0.25))]|", imageView, textLabel)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AddCell : UICollectionViewCell {
    
    lazy var textLabel : UILabel! = {
        var _textLabel = UILabel()
        
        _textLabel.font = UIFont.systemFont(ofSize: 29)
        _textLabel.textColor = .black
        
        _textLabel.minimumScaleFactor = 0.5
        _textLabel.adjustsFontSizeToFitWidth = true
        _textLabel.textAlignment = .center
        _textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return _textLabel
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        addSubview(textLabel)
        
        
        addConstraintWithFormat("V:|[v0]|", textLabel)
        addConstraintWithFormat("H:|[v0]|", textLabel)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

class GroupHeaderView: UICollectionReusableView, UIScrollViewDelegate {
    
    var scrollView :UIScrollView!
    var pageControl :UIPageControl!
    
    var viewList : [UIImageView]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewList = [] //initalize
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
    
        
        addConstraintWithFormat("H:|[v0]|", scrollView)
        addConstraintWithFormat("V:|[v0]|", scrollView)
        
        pageControl = UIPageControl()
        pageControl.currentPage = viewList.count/2;
        pageControl.numberOfPages = viewList.count
        pageControl.tintColor = .red
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .black
        
        addSubview(pageControl)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private let reuseIdentifier = "GroupCell"
private let reuseIdentifier2 = "AddCell"

private let groupChildName = "Group"

class GroupViewController: UIViewController{
    
    var groupRef = FIRDatabase.database().reference().child(groupChildName).queryOrderedByKey()
    
    var dataList :Array<[String : Any]> = [];
    
    
    lazy var menuButtonItem : UIBarButtonItem = {
        let image = UIImage(named:"Menu")
        var _inButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(menuButtonEvent))
        
        return _inButton
    }()
    
    var collectioView : UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGroupViewController()
        
        loadDefault()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setUpGroupViewController(){
        self.view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = menuButtonItem
        
        let naviBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64))
        naviBar.items = [navigationItem]
        naviBar.backgroundColor = .white
        view.addSubview(naviBar)
        
        let size = view.frame.size
        
        print("Size : \(size.width/2 - 5)")
        
        let layout = UICollectionViewFlowLayout()
        //layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: (size.width/2 - 5) , height: (size.width/2 - 5))
        
        
        collectioView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectioView.dataSource = self
        collectioView.delegate = self
        
        collectioView.backgroundColor = .gray
        
        collectioView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectioView)
        
        view.addConstraintWithFormat("V:|-64-[v0]|", collectioView)
        view.addConstraintWithFormat("H:|[v0]|", collectioView)
        
        collectioView.register(GroupCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectioView.register(AddCell.self, forCellWithReuseIdentifier: reuseIdentifier2)
        
        
    }
    
    func loadDefault(){
        let ref = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard snapshot.exists() else {
                return
            }
            
            var array : Array<[String : Any]>! = []
            let dict = snapshot.value as! [String : Any]
            
            var info = dict["groupList"] as!  [String : Any]
            
            for (key, _) in info {
                info["key"] = key
                array.append(info[key] as! [String : Any])
            }
            
            self.dataList.removeAll() //reset
            
            if(array.count > 0){
                self.dataList = array
                self.collectioView.reloadData()
            }
            
        }) { (error) in
            guard error == nil else {
                return
            }
        }
    }
    
    func menuButtonEvent(){
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension GroupViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("index = \(indexPath.row)")
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        if(cell?.isKind(of: GroupCell.self))!{
           
            print((cell as! GroupCell).textLabel.text!)
            
//            let storyBoardName = "Board"
//            let identifier = "CustomTabBarController"
//            
//            let stroyBoard = UIStoryboard(name: storyBoardName, bundle: nil)
//            
//            if let resultController = stroyBoard.instantiateViewController(withIdentifier: identifier) as? CustomTabBarController {
//                
//                let singleton = CustomTabBarController.sharedInstance
//                singleton.titleStr = "Swift Study"
//                
//                self.view.window?.rootViewController?.present(resultController, animated: true, completion: nil)
//            }

        }else {
            let groupCreateViewContorller = GroupCreateViewController()
            
            groupCreateViewContorller.delegate = self
            
            self.present(groupCreateViewContorller, animated: true, completion: nil)
        }
        
    }
    
    
    
    func afterCreateGroup(_ obj : [String:Any]){
        dataList.append(obj)
        DispatchQueue.main.async { 
            self.collectioView.reloadData()
        }
    }
    
}

extension GroupViewController : UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  dataList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GroupCell
        
        if indexPath.row == dataList.count  {
            let cell = collectioView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier2, for: indexPath) as! AddCell
            cell.textLabel.text = "새로운 모임생성"
            
            let selectedView = UIView()
            selectedView.backgroundColor = UIColor(netHex: 0x000000, alpha: 0.4)
            
            cell.selectedBackgroundView = selectedView
            
            return cell
        }
        
        let rowItem = dataList[indexPath.row]
        
        var url = URL(string: "http://bigmatch.i-um.net/wp-content/uploads/2014/12/Apple_Swift_Logo.png")
        
        url = URL(string: rowItem["coverImgUrl"] as! String)
        
        
        cell.imageView.sd_setImage(with: url, placeholderImage: UIImage(), options: .retryFailed, completed: { (image, error, cachedType, url) in
            
            
            //이미지캐싱이 안되있을경우에 대한 애니메이션 셋팅_imageView.alpha = 1;
            if cell.imageView != nil, cachedType == .none {
                
                cell.imageView?.alpha = 0
                
                UIView.animate(withDuration: 0.2, animations: {
                    cell.imageView?.alpha = 1
                }, completion: { (finished) in
                    cell.imageView?.alpha = 1
                })
            }
        })
        
//        cell.textLabel.text = "모임 우왕 우왕 \(indexPath.row)"
        cell.textLabel.text = rowItem["groupName"] as? String
        
        let selectedView = UIView()
        selectedView.backgroundColor = .black
        cell.selectedBackgroundView = selectedView
        
      
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
    
  
    
}
