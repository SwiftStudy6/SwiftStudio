//
//  NewMessageController.swift
//  FireBaseChat
//
//  Created by 유명식 on 2017. 2. 13..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {

    
    
    let cellId = "cellId"
    
    
    
    var users = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
   
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        fetchUser()
    
    }
    func fetchUser(){
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                let user = User()
                user.id = snapshot.key
                //if you se this setter , your app will crash if your class properties don't exactly match up with the firebase'
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                
                
                
                self.tableView.reloadData()
                
                DispatchQueue.main.async {self.tableView.reloadData()}
                //print(user.name, user.email)
            }
//            print("User found")
//            print(snapshot)
        }, withCancel: nil)
    }
    func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.userName
        cell.detailTextLabel?.text = user.email
//        cell.imageView?.image = UIImage(named:"moon")
//        cell.imageView?.contentMode = .scaleAspectFill
        if let profileImageUrl = user.profile_url{
            
            cell.profileImageView.loadImageUsingCacheWithUrlStirng(urlString: profileImageUrl)
//            let url = NSURL(string: profileImageUrl)
//            URLSession.shared.dataTask(with: url! as URL,completionHandler:{(data,response,err)in
//                if err != nil{
//                    print(err)
//                    return
//                }
//                DispatchQueue.main.async {
//                    cell.profileImageView.image = UIImage(data: data!)
//                    //cell.imageView?.image=UIImage(data:data!)
//                    }
//                
//            }).resume();
            
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72  // 각자 테이블 뷰의 아이템 높이
    }
    
    var messagesController :MessageController?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) { 
            print("Dismiss completed")
            let user = self.users[indexPath.row]
            self.messagesController?.showchatControllerForUser(user: user)
        }
    }

   
}
