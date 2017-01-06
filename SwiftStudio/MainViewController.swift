//
//  MainViewController.swift
//  SwiftStudio
//
//  Created by David June Kang on 2016. 12. 31..
//  Copyright © 2016년 ven2s.soft. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class BoradObject : NSObject {
    var userId : String? = nil
    var userName : String? = nil
    var profileImgUrl : String? = nil
    var bodyText : String? = nil
}

protocol BoardCellDelegate  {
    func editButtonEvent(sender:UIButton)
    func likeButtonEvent(sender:UIButton)
    func replyButtonEvent(sender:UIButton)
    func shareButtonEvent(sender:UIButton)
}

//Board Cell Definition
class BoardCell : UICollectionViewCell {
    
    var userImage    : UIImageView! = nil           //Profile image
    var userName     : UILabel? = nil               //Username
    var editTime     : UILabel? = nil               //Edited time
    var textRecorded : UITextView? = nil            //Text
    var delegate     : BoardCellDelegate? = nil     //BoardCellDelegate Object
    
    override init(frame: CGRect){
        super.init(frame:frame)
        setSetting()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //View setting
    func setSetting(){
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.darkGray.cgColor
        self.contentView.layer.masksToBounds = true
        
        //Userinfo
        let userInfoView = UIView()
        userInfoView.backgroundColor = .white
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(userInfoView)
        
        userInfoView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        userInfoView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        userInfoView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
        userInfoView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        //settting userImage
        self.userImage = UIImageView()
        self.userImage.image = UIImage(named: "User")
        self.userImage.translatesAutoresizingMaskIntoConstraints = false
        self.userImage.layer.masksToBounds = true;
        self.userImage.layer.cornerRadius = 18
        self.userImage.layer.borderWidth = 2
        self.userImage.layer.borderColor = UIColor.black.cgColor
        
        
        userInfoView.addSubview(self.userImage)
        
        self.userImage.leftAnchor.constraint(equalTo: userInfoView.leftAnchor, constant: 9).isActive = true
        self.userImage.topAnchor.constraint(equalTo: userInfoView.topAnchor, constant: 12).isActive = true
        self.userImage.widthAnchor.constraint(equalToConstant: 36).isActive = true
        self.userImage.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        
        //setting editButton
        let editButton = UIButton()
        
        editButton.setImage(UIImage(named: "More"), for: .normal)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.addTarget(self, action: #selector(editButtonTouchUpinside), for: .touchUpInside)
        
        userInfoView.addSubview(editButton)
        
        editButton.rightAnchor.constraint(equalTo: userInfoView.rightAnchor, constant: -12).isActive = true
        editButton.topAnchor.constraint(equalTo: userInfoView.topAnchor, constant: 12).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 26).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 26).isActive = true

        //TODO : Add small Menu
        //let editMenu = UIVIew()
        
        
        
        
        //setting UserName
        self.userName = UILabel()
        self.userName?.textAlignment = .left
        self.userName?.font = UIFont.boldSystemFont(ofSize: 14)
        self.userName?.textColor = .black
        
        userInfoView.addSubview(self.userName!)
        
        self.userName?.translatesAutoresizingMaskIntoConstraints = false
        self.userName?.leftAnchor.constraint(equalTo: (self.userImage?.rightAnchor)!, constant: 8.5).isActive = true
        self.userName?.topAnchor.constraint(equalTo: userInfoView.topAnchor, constant: 11).isActive = true
        self.userName?.rightAnchor.constraint(equalTo: editButton.leftAnchor, constant: -8.5).isActive = true
        self.userName?.heightAnchor.constraint(equalToConstant: 17).isActive = true
      
        
        
        //settting editTime (yyyy년 MM월 dd일 hh시 mm분
        self.editTime = UILabel()
        self.editTime?.textAlignment = .left
        self.editTime?.font = UIFont.systemFont(ofSize: 11)
        self.userName?.textColor = .black

        userInfoView.addSubview(self.editTime!)
        
        self.editTime?.translatesAutoresizingMaskIntoConstraints = false
        self.editTime?.leftAnchor.constraint(equalTo: (self.userImage?.rightAnchor)!, constant: 8.5).isActive = true
        self.editTime?.topAnchor.constraint(equalTo: (self.userName?.bottomAnchor)!, constant: 2.3).isActive = true
        self.editTime?.rightAnchor.constraint(equalTo: editButton.leftAnchor, constant: -8.5).isActive = true
        self.editTime?.heightAnchor.constraint(equalToConstant: 17).isActive = true
        
        
        //setting body Text Area
        self.textRecorded = UITextView()
        self.textRecorded?.font = UIFont.systemFont(ofSize: 13)
        self.textRecorded?.isUserInteractionEnabled = false
        self.contentView.addSubview(self.textRecorded!)
        
        self.textRecorded?.translatesAutoresizingMaskIntoConstraints = false
        self.textRecorded?.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12).isActive = true
        self.textRecorded?.topAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: 4).isActive = true
        self.textRecorded?.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -12).isActive = true
        self.textRecorded?.heightAnchor.constraint(equalToConstant: 165).isActive = true
        
        //setting bottom view
        let bottomView = UIView()
        //bottomView.backgroundColor = .gray
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(bottomView)
        
        bottomView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        bottomView.topAnchor.constraint(equalTo: (self.textRecorded?.bottomAnchor)!, constant: 3).isActive = true
        bottomView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        //add like button
        let likeButton = UIButton()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setTitle("좋아요", for: .normal)
        likeButton.setTitleColor(.black, for: .normal)
        likeButton.titleLabel?.font = .systemFont(ofSize: 12)
        likeButton.addTarget(self, action: #selector(likeButtonTouchUpInside(_:)), for: .touchUpInside)
        likeButton.contentVerticalAlignment = .center
        likeButton.contentHorizontalAlignment = .center
        
        likeButton.backgroundColor = .blue
  
        bottomView.addSubview(likeButton)
        
        likeButton.leftAnchor.constraint(equalTo: bottomView.leftAnchor).isActive = true
        likeButton.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: self.contentView.frame.width/3).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        //add reply button
        let replyButton = UIButton()
        replyButton.setTitle("댓글달기", for: .normal)
        replyButton.setTitleColor(.black, for: .normal)
        replyButton.titleLabel?.font = .systemFont(ofSize: 12)
        replyButton.translatesAutoresizingMaskIntoConstraints = false
        replyButton.backgroundColor = .red
        replyButton.addTarget(self, action: #selector(replyButtonTouchUpInside(_:)), for: .touchUpInside)
        replyButton.contentVerticalAlignment = .center
        replyButton.contentHorizontalAlignment = .center
    
        bottomView.addSubview(replyButton)
        
        replyButton.leftAnchor.constraint(equalTo: likeButton.rightAnchor).isActive = true
        replyButton.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        replyButton.widthAnchor.constraint(equalToConstant: self.contentView.frame.width/3).isActive = true
        replyButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        //add reply button
        let shareButton = UIButton()
        shareButton.setTitle("공유하기", for: .normal)
        shareButton.setTitleColor(.black, for: .normal)
        shareButton.titleLabel?.font = .systemFont(ofSize: 12)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.addTarget(self, action: #selector(shareButtonTouchUpInside(_:)), for: .touchUpInside)
        shareButton.contentVerticalAlignment = .center
        shareButton.contentHorizontalAlignment = .center
        shareButton.backgroundColor = .green
        
        bottomView.addSubview(shareButton)
        
        shareButton.leftAnchor.constraint(equalTo: replyButton.rightAnchor).isActive = true
        shareButton.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: self.contentView.frame.width/3).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        

        
    }
    
    
    //Button Delegate Fucniton
    @IBAction func editButtonTouchUpinside(_ sender:UIButton){
        print(123)
        self.delegate?.editButtonEvent(sender:sender)
    }
    
    @IBAction func likeButtonTouchUpInside(_ sender:UIButton){
        self.delegate?.likeButtonEvent(sender: sender)
    }
    
    @IBAction func replyButtonTouchUpInside(_ sender:UIButton){
        self.delegate?.replyButtonEvent(sender:sender)
    }
    
    @IBAction func shareButtonTouchUpInside(_ sender:UIButton){
        self.delegate?.shareButtonEvent(sender: sender)
    }
    
}



//Definition Class MainViewController
class MainViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, BoardCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(BoardCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //Setting View
        self.view.backgroundColor = .white
        self.collectionView?.backgroundColor = .white
        
        self.collectionView?.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: (self.collectionView?.frame.height)!-20)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BoardCell
        
        
        
        // Configure the cell
        //example
        cell.userImage?.image = UIImage(named: "User")
        
        cell.userName?.text = "User Name"
        cell.editTime?.text = "2017년 1월 3일 오후 5:00"
        cell.textRecorded?.text = "테스트"
        
        cell.delegate = self
    
        
        
        
        return cell
    }

    
    // MARK : BoardCellDelegate
    
    //Edit Button
    func editButtonEvent(sender: UIButton) {
        //Example
//        let testViewController = TestViewController()
//        var topController = UIApplication.shared.keyWindow?.rootViewController
//        while ((topController?.presentedViewController) != nil) {
//            topController = topController?.presentedViewController
//        }
//       
//        let naviController = UINavigationController(rootViewController: testViewController)
//        topController?.present(naviController, animated: true, completion: nil)
        
        
//        present(testViewController, animated: true, completion: nil)
    }
    
    //Like Button
    func likeButtonEvent(sender: UIButton) {
        //code
    }
    
    //Reply Button
    func replyButtonEvent(sender: UIButton) {
        //code
    }
    
    //Share Button
    func shareButtonEvent(sender: UIButton) {
        //code
    }
    
    
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width-30, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        print(111)
        return true
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */


    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */


}
