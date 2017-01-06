//
//  ViewController.swift
//  Moim
//
//  Created by David June Kang on 2016. 12. 28..
//  Copyright © 2016년 ven2s.soft. All rights reserved.
//

import UIKit

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
            _label.text = "Moim"
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
        print("touchupInsideUp Button : \(sender.tag)")
        
        if(sender.tag == 0){//login button
            
            let stroyBoard = UIStoryboard(name: "Board", bundle: nil)
            
            if let resultController = stroyBoard.instantiateViewController(withIdentifier: "CustomTabBarController") as? CustomTabBarController {
                self.view.window?.rootViewController?.present(resultController, animated: true, completion: nil)
                
                //self.present(resultController, animated: true, completion: nil)
            }
                      
            
            
        }else if(sender.tag == 1){ //forgot buuton
            
        }else{ //signin button
            
        }
    }
    
}



