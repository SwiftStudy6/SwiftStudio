//
//  ChatLogController.swift
//  FireBaseChat
//
//  Created by 유명식 on 2017. 2. 17..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit
import Firebase


class  ChatLogController: UICollectionViewController,UITextFieldDelegate,UICollectionViewDelegateFlowLayout {
    
    
    var cellId = "cellId"
    var user:User?{
        didSet{
            navigationItem.title = user?.userName
            observeMessage()
        }
    }
    
    
    var messages = [Message]()
    func observeMessage(){
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        
        let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(uid)
        
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            let messageId = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child("messages").child(messageId)
            
            messagesRef.observe(.value, with: { (snapshot) in
                print(snapshot)
                
                guard let dictionary = snapshot.value as? [String:AnyObject] else{
                    return
                }
                let message = Message()
                
                message.setValuesForKeys(dictionary)
                
                
                if message.chatPartnerId() == self.user?.id{
                    self.messages.append(message)
                    
                    DispatchQueue.main.async(execute: {
                        self.collectionView?.reloadData()
                    })
                }
                
                
            }, withCancel: nil)
        }, withCancel: nil)
        
    }
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.contentInset = UIEdgeInsets(top:8,left:0,bottom:58,right:0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top:0,left:0,bottom:50,right:0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        setupInputComponents()
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        
        
        setupCell(cell: cell,message:message)
        
        
            
        cell.bubleWidthAnchor?.constant = estimateFrameForText(text: message.text!).width + 32
        
        
        return cell
    }
    
    private func setupCell(cell:ChatMessageCell,message:Message) -> Void {
        
        if let profileImageUrl = self.user?.profile_url{
            cell.profileImageView.loadImageUsingCacheWithUrlStirng(urlString: profileImageUrl)
        }
        
        
        
        if message.fromId == FIRAuth.auth()?.currentUser?.uid{
            cell.bubleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            
            cell.bubleViewRightAnchor?.isActive = true
            cell.bubleViewLeftAnchor?.isActive = false
        }else{
            cell.bubleView.backgroundColor = UIColor(r:240,g:240,b:240)
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            cell.bubleViewRightAnchor?.isActive = false
            cell.bubleViewLeftAnchor?.isActive = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout() // 화면 변환시 새로 고침
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 80
        
        
        if let text = messages[indexPath.item].text{
            height = estimateFrameForText(text: text).height + 20//여백을 위해서 20정도 넣어줌
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    private func estimateFrameForText(text: String)-> CGRect{
        ///사이즈 높이
        let size = CGSize(width: 200, height: 1000)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: option, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 16)], context: nil)
    }
    func setupInputComponents(){
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
        let sendButton  = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        
              containerView.addSubview(inputTextField)
        
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant:8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(r:220,g:220,b:220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    func handleSend(){
        
        
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id!;
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let timestamp :NSNumber = NSNumber(value :NSDate().timeIntervalSince1970)
        let values = ["text":inputTextField.text,"toId": toId,"fromId":fromId , "timestamp":timestamp] as [String : Any]
        //childRef.updateChildValues(values)
        childRef.updateChildValues(values) { (err, ref) in
            if err != nil{
                print(err)
            }
            
            self.inputTextField.text = nil
            let userMessageRef = FIRDatabase.database().reference().child("user-messages").child(fromId)
            let messageId = childRef.key
            userMessageRef.updateChildValues([messageId:1] )
            
            let recipientUserMessageRer = FIRDatabase.database().reference().child("user-messages").child(toId)
            recipientUserMessageRer.updateChildValues([messageId:1])    
        }
        
    }
    
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
}
