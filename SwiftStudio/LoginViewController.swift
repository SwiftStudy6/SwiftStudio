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

    private var emailTextField  : UITextField! = nil
    private var passwdTextField : UITextField! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func createView(){
        
        //View Background color
        self.view.backgroundColor = UIColor.white
        
        let pinkshRed = UIColor(red: 233/255, green: 29/255, blue: 41/255, alpha: 1.0)
        
        
        //Label
        let label : UILabel = {
            let _label = UILabel(/*frame: CGRect(x: 28, y: 90, width: view.frame.width-(28*2), height: 65)*/)
            _label.text = "Swift Study"
            _label.textColor = pinkshRed
            _label.font = UIFont.boldSystemFont(ofSize: 48)
            _label.textAlignment = NSTextAlignment.center
            _label.translatesAutoresizingMaskIntoConstraints = false
            
            return _label
        }()
        
        self.view.addSubview(label)
        
        
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 28).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -28).isActive = true 
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
        label.heightAnchor.constraint(equalToConstant: 65).isActive = true
        
        //Email TextField
        self.emailTextField = {
            let _textField = UITextField(/*frame: CGRect(x: 28, y: 222, width: view.frame.width-(28*2), height: 50)*/)
            let padding = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 16))
            _textField.leftView = padding
            _textField.leftViewMode = UITextFieldViewMode.always
            _textField.placeholder = "EMAIL"
            _textField.font = UIFont.systemFont(ofSize: 14)
            _textField.borderStyle = UITextBorderStyle.line
            _textField.delegate = self
            _textField.keyboardType = .emailAddress
            _textField.tag = 1
            _textField.translatesAutoresizingMaskIntoConstraints = false
            _textField.keyboardType = .emailAddress
            _textField.returnKeyType = .next
            _textField.autocapitalizationType = .none
            
            return _textField
        }()
        
        self.view.addSubview(self.emailTextField)
        
        self.emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 28).isActive = true
        self.emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -28).isActive = true
        self.emailTextField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 67).isActive = true
        self.emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //Password TextField
        self.passwdTextField = {
            let _textField = UITextField(frame: CGRect(x: 28, y: 282, width: view.frame.width-(28*2), height: 50))
            let padding = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 16))
            _textField.leftView = padding
            _textField.leftViewMode = UITextFieldViewMode.always
            _textField.placeholder = "PASSWORD"
            _textField.font = UIFont.systemFont(ofSize: 14)
            _textField.borderStyle = UITextBorderStyle.line
            _textField.isSecureTextEntry = true
            _textField.delegate = self
            _textField.tag = 2
            _textField.returnKeyType = .done
            _textField.autocapitalizationType = .none
            
            return _textField
        }()
        self.view.addSubview(self.passwdTextField)
        
        self.passwdTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 28).isActive = true
        self.passwdTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -28).isActive = true
        self.passwdTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 10).isActive = true
        self.passwdTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        //Login Button
        let loginButton: UIButton = {
            let _button = UIButton(/*frame: CGRect(x: 28, y: 352, width: view.frame.width-(28*2), height: 50)*/)
            _button.backgroundColor = pinkshRed
            _button.setTitleColor(.white, for: .normal)
            _button.setTitleColor(pinkshRed, for: .highlighted)
            _button.setTitle("LOGIN", for: .normal)
            _button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            _button.titleLabel?.textAlignment = NSTextAlignment.center
            _button.addTarget(self, action:#selector(buttonTouchUpInside(_:)), for: .touchUpInside)
            _button.tag = 0
            _button.translatesAutoresizingMaskIntoConstraints = false
            
            return _button
        }()
        self.view.addSubview(loginButton)
        
        loginButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 28).isActive = true
        loginButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -28).isActive = true
        loginButton.topAnchor.constraint(equalTo: self.passwdTextField.bottomAnchor, constant: 20).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    

        
        //forgot button
        let forgotButton : UIButton = {
            let _button = UIButton(/*frame: CGRect(x: 28, y: 427, width: view.frame.width-(28*2), height: 19)*/)
            _button.setTitle("Forgot Password?", for: .normal)
            _button.titleLabel?.textAlignment = .center
            _button.setTitleColor(UIColor(red:139/255, green:153/255, blue:159/255, alpha:1.0), for: .normal)
            _button.setTitleColor(.white, for: .highlighted)
            _button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            _button.addTarget(self, action: #selector(buttonTouchUpInside(_:)), for: .touchUpInside)
            _button.tag = 1
            _button.translatesAutoresizingMaskIntoConstraints = false
            
            return _button
        }()
        self.view.addSubview(forgotButton)
        
        forgotButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 28).isActive = true
        forgotButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -28).isActive = true
        forgotButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 25).isActive = true
        forgotButton.heightAnchor.constraint(equalToConstant: 19).isActive = true
        
        //signin button
        let signinButton : UIButton = {
            let _button = UIButton(/*frame: CGRect(x: 28, y: 608, width: view.frame.width-(28*2), height: 22)*/)
            _button.setTitle("Don’t have an account?", for: .normal)
            _button.titleLabel?.textAlignment = .center
            _button.setTitleColor(UIColor(red:139/255, green:153/255, blue:159/255, alpha:1.0), for: .normal)
            _button.setTitleColor(.white, for: .highlighted)
            _button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            _button.addTarget(self, action: #selector(buttonTouchUpInside(_:)), for: .touchUpInside)
            _button.tag = 2
            _button.translatesAutoresizingMaskIntoConstraints = false
            
            return _button
        }()
        self.view.addSubview(signinButton)
        
        signinButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 28).isActive = true
        signinButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -28).isActive = true
        signinButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        signinButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -37).isActive = true
        
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
    
    
    
    @IBAction func buttonTouchUpInside(_ sender:AnyObject){
               
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
                
                let stroyBoard = UIStoryboard(name: "Board", bundle: nil)
                
                if let resultController = stroyBoard.instantiateViewController(withIdentifier: "CustomTabBarController") as? CustomTabBarController {
                    self.view.window?.rootViewController?.present(resultController, animated: true, completion: nil)
                    
                    //self.present(resultController, animated: true, completion: nil)
                }

            })
            
            
        }else if(sender.tag == 1){ //forgot buuton
            let test = TestViewController()
            let navi = UINavigationController(rootViewController: test)
            
            present(navi, animated: true, completion: nil)
            
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
                    
                    print("SIGN UP :\n (user!)")
                    
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



