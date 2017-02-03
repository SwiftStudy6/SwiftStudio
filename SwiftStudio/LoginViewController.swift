//
//  ViewController.swift
//  Moim
//
//  Created by David June Kang on 2016. 12. 28..
//  Copyright © 2016년 ven2s.soft. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate,FBSDKLoginButtonDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    private var emailTextField  : UITextField! = nil
    private var passwdTextField : UITextField! = nil
    lazy var profileImageView : UIImageView = {
        
        
        let imageView = UIImageView()
        imageView.image = UIImage()
        imageView.backgroundColor = UIColor.red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
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
        
        
        
        
        
        
        self.view.addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 28).isActive = true
        profileImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -28).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -37).isActive = true
        
        
        
        
        
        
        //FaceBook Login
        let facebookLoginButton = FBSDKLoginButton()
        view.addSubview(facebookLoginButton)
        facebookLoginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width-32, height: 50)
        facebookLoginButton.delegate = self
        
    }
    func handleSelectProfileImageView(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true //사진 화면 수정 카카오톡 프로필
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker : UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage //수정한 이미지
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage //원본 이미지
        }
        if let selectedImage = selectedImageFromPicker{
            profileImageView.image = selectedImage // 선택한 이미지 적용
        }
        
        let storageRed = FIRStorage.storage().reference().child("test.png");
        if let uploadData = UIImagePNGRepresentation(selectedImageFromPicker!){
            storageRed.put(uploadData, metadata: nil, completion: { (metadata, err) in
                if err != nil{
                    print("err : ",err)
                    return
                }
                print("metadata : ",metadata)
            })
        }
        
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //FaceBook Logout
        print("canceled picker")
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result:
        FBSDKLoginManagerLoginResult!, error: Error!) {
        //FaceBook Login
        
        if error != nil{
            print(error)
            return
        }
        print(result)

        
        
//        CurrentUser.shared.userName =
//        CurrentUser.shared.profileUrl =
//        CurrentUser.shared.profileImg =
//        
        
        
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






