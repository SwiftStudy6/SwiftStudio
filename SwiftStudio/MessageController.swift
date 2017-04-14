//
//  ViewController.swift
//  FireBaseChat
//
//  Created by 유명식 on 2017. 2. 12..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit
import Firebase

class MessageController: UITableViewController {
    
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        
//        let ref = FIRDatabase.database().reference(fromURL: "https://fir-chat-e94db.firebaseio.com/")
//        ref.updateChildValues(["someValue":123])
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let image = UIImage(named: "ic_message_3x")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
        checkIfUserIsLoggiedIn()
        
        tableView.register(UserCell.self, forCellReuseIdentifier:cellId)
        
        //observeMessage()
        
        
    }
    
    func observeUserMessage(){
        
        
        
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        let ref = FIRDatabase.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messagesReference = FIRDatabase.database().reference().child("messages").child(messageId)
            
            
            messagesReference.observe(.value, with: { (snapshot) in
                
                
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    let message = Message()
                    message.setValuesForKeys(dictionary)
                    self.messages.append(message)
                    
                    if let chatPartnerId = message.chatPartnerId(){
                        self.messageDictionary[chatPartnerId] = message
                        self.messages = Array(self.messageDictionary.values) // 같은 사람에게 온 메세지를 하나로 묶어줌
                        
                        self.messages.sort(by: { (message1, message2) -> Bool in
                            return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
                        }) // 시간 정렬 클로저를 사용하면 아마 더 짧게 쓸 수 있음
                    }
                    
                    
                    //This will crash because of background thread , so lets call this on dispatch_async main thread
                    
                    
                    
                    Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)//이미지가 제대로 로딩이 되지 않아서 0.1초 후에 작동하도록 타이머를 달아줌
                    
                    
                }
            }, withCancel: nil )
        }, withCancel: nil)
    }
    
    
    
    func handleReloadTable() -> Void {
        DispatchQueue.main.async(execute: {
            
            print("we reloaded the table")
            self.tableView.reloadData()
        })
    }
    
    var messages = [Message]()
    
    var messageDictionary = [String:Message]()
    
    func observeMessage(){
        
        let ref = FIRDatabase.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                let message = Message()
                message.setValuesForKeys(dictionary)
                self.messages.append(message)
                
                if let toId = message.toId{
                    self.messageDictionary[toId] = message
                    self.messages = Array(self.messageDictionary.values) // 같은 사람에게 온 메세지를 하나로 묶어줌
                    
                    self.messages.sort(by: { (message1, message2) -> Bool in
                        return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
                    }) // 시간 정렬 클로저를 사용하면 아마 더 짧게 쓸 수 있음
                }
                
                
                //This will crash because of background thread , so lets call this on dispatch_async main thread
                DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
                })
                
            }
            
            
            
            
            
        }, withCancel: nil)
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //채팅으로 온 메세지 클릭시 작동하는 부분
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else{
            return
        }
        
        let ref = FIRDatabase.database().reference().child("users").child(chatPartnerId)
        ref.observe(.value, with: { (snapshot) in
                        
            guard let dictionory = snapshot.value as? [String: AnyObject]
                else{
                    return
            }
            let user = User()
            user.id = chatPartnerId
            user.setValuesForKeys(dictionory)
            self.showchatControllerForUser(user: user)
        }, withCancel: nil)
        
       
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let message = messages[indexPath.row]
       cell.message = message
        
        return cell
    }
    
    func setupNavBarWithUser(user:User){
        
        messages.removeAll()
        messageDictionary.removeAll()
        tableView.reloadData()
        
        observeUserMessage()
        
        
        
        //self.navigationItem.title = user.name;
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        //titleView.backgroundColor = UIColor.red
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        
        if let profileImageUrl = user.profileImageUrl{
            profileImageView.loadImageUsingCacheWithUrlStirng(urlString: profileImageUrl)
        }
        containerView.addSubview(profileImageView)
        
        
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        let nameLabel = UILabel()
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant : 0).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
        
        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showchatControllerForUser)))
    }
    
    func showchatControllerForUser(user:User) -> Void {
    
        
        let chatLoginController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLoginController.user = user
        // UICollectionViewFlowLayout?
        navigationController?.pushViewController(chatLoginController, animated: true)
        
    }
    func handleNewMessage(){
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggiedIn(){
        
        if FIRAuth.auth()?.currentUser?.uid == nil {
            
            perform(#selector(handleLogout),with:nil,afterDelay:0)
        }else{
            fetchUserAndSetupNaBarTtile()
        }
    }
    
    func fetchUserAndSetupNaBarTtile(){
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        

        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String :AnyObject]{
                
                //self.navigationItem.title = dictionary["name"] as? String
                let user = User()
                user.setValuesForKeys(dictionary)
                self.setupNavBarWithUser(user: user)
                
            }
        }, withCancel: nil)

        
    }


    func handleLogout(){
        
        //FIRAuth.auth()?.signOut()//
        do{
            try FIRAuth.auth()?.signOut()
        }catch let logoutError {
            print(logoutError)
        }
        
        
        
        let loginController = LoginController()
        loginController.messagesController = self
        present(loginController, animated: true, completion: nil)
    }
}

