//
//  ViewController.swift
//  Moim
//
//  Created by David June Kang on 2016. 12. 28..
//  Copyright © 2016년 ven2s.soft. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Toaster

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwdTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        createView()
        //    //권한 생성으로 인해서 바꾸지 말아주세요 테스트용으로 냅둘겁니다
        #if DEBUG
            self.emailTextField.text = "you6878@icloud.com"
            self.passwdTextField.text = "123456"
        #endif
        loginButton.addTarget(self, action: #selector(self.buttonTouchUpInside(_:)), for: .touchUpInside)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.tag == 1){
            if(textField.text?.isEmpty)!{
                let alertViewController = UIAlertController(title: "알림", message: "Email을 입력하여 주십시오.", preferredStyle:.alert)
                alertViewController.addAction(UIAlertAction(title: "확인", style: .default, handler:nil))
                
                present(alertViewController, animated: true, completion: nil)
                return true
            }
            self.passwdTextField.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    
    
    func buttonTouchUpInside(_ sender:AnyObject){
        
        print("aaa")
        
        if(sender.tag == 0){//login button
            
            guard self.emailTextField.text != nil, self.passwdTextField.text != nil else {
                Toast(text: "이메일 혹은 패스워드를 다시 확인하여주십시오").show()
                return
            }
            
            
            
            FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passwdTextField.text!, completion: { (user, error) in
                
                
                guard user?.uid != nil , error == nil else {
                    let toast = Toast(text: "등록이 안되어 있거나, 이메일, 비밀번호를 다시 확인 하여주십시오.")
                    
                    toast.show()
                    return
                }
                
                print("SIGN IN :\n \(user!)")
                //
                //                let storyBoardName = "Tabbar"
                //
                //                let storyBoard = UIStoryboard(name: storyBoardName, bundle: nil)
                //
                //                let resultController = storyBoard.instantiateInitialViewController()!
                //
                //                self.present(resultController, animated: true, completion: nil)
                //
                
                let storyBoardName = "Board"
                let identifier = "CustomTabBarController"
                
                let stroyBoard = UIStoryboard(name: storyBoardName, bundle: nil)
                
                if let resultController = stroyBoard.instantiateViewController(withIdentifier: identifier) as? CustomTabBarController {
                    
                    let singleton = CustomTabBarController.sharedInstance
                    singleton.titleStr = "Swift Study"
                    
                    self.view.window?.rootViewController?.present(resultController, animated: true, completion: nil)
                }
                
            })
            
            
        }else if(sender.tag == 1){ //forgot buuton
            let test = GroupViewController()
            
            
            present(test, animated: true, completion: nil)
            
        }else{ //signin button
            let signUpController = UIAlertController(title: "회원가입", message:"이메일, 비번.유저명 입력해주세요", preferredStyle: .alert)
            
            signUpController.addTextField(configurationHandler: { (email) in
                //code
                email.placeholder = "Email"
                email.keyboardType = .emailAddress
                email.returnKeyType = .next
                
            })
            signUpController.addTextField(configurationHandler: { (passwd) in
                //
                passwd.placeholder = "PASSWORD"
                passwd.isSecureTextEntry = true
                passwd.returnKeyType = .next
            })
            signUpController.addTextField(configurationHandler: { (userName) in
                //
                userName.placeholder = "User Name"
                userName.returnKeyType = .done
            })
            
            
            let uploadAction = UIAlertAction(title: "가입하기", style: .default, handler: { (alert) in
                let email : UITextField! = signUpController.textFields![0]
                let passwd : UITextField! = signUpController.textFields![1]
                let name : UITextField! = signUpController.textFields![2]
                
                FIRAuth.auth()?.createUser(withEmail: email.text!, password: passwd.text!, completion: {(user, error) in
                    
                    
                    guard error == nil, user != nil else{
                        Toast(text: "이미 있는 유저이거나 잘못된 정보를 입력하셨습니다.").show()
                        return
                    }
                    
                    print("SIGN UP :\n \(user!)")
                    
                    let ref = FIRDatabase.database().reference()
                    ref.child("users").child((user?.uid)!).setValue(["username":name.text])
                    
                    
                    ref.observeSingleEvent(of: .childAdded, with: { (snapshot) in
                        if(snapshot.value != nil){
                            Toast(text: "등록 완료로그인을 해주세요").show()
                        }
                    })
                    
                    
                })
            })
            
            let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: { (UIAlertAction) in
                
            })
            
            signUpController.addAction(uploadAction)
            signUpController.addAction(cancelAction)
            
            present(signUpController, animated: true, completion: nil)
            
            
        }
    }
     
}



