//
//  LoginController.swift
//  FireBaseChat
//
//  Created by 유명식 on 2017. 2. 12..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

class LoginController:UIViewController{
    
    var messagesController : MessageController?
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let loginRegisterButton :UIButton = {
        
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r:80, g: 101, b:161)
        button.setTitle("Register",for:.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLoginRegister), for:.touchUpInside)
        return button
    }()
    
    let loginRegiseterSegmentedControl :UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login","Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1 // 시작 위치 지정
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    func handleLoginRegisterChange(){
        let title = loginRegiseterSegmentedControl.titleForSegment(at: loginRegiseterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        
        //Change height
        inputsContainerViewHeightAnchor?.constant = loginRegiseterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
 
        nameTextFieldHeightAngher?.isActive = false
        nameTextFieldHeightAngher = nameTextFiled.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegiseterSegmentedControl.selectedSegmentIndex == 0 ? 0: 1/3)
        //로그인 화면을 클릭을 경우 사이즈를 0로 레지스터 화면을 클릭을경우 화면을 1/3로
        nameTextFieldHeightAngher?.isActive = true
        nameTextFiled.isHidden = loginRegiseterSegmentedControl.selectedSegmentIndex == 0 ? true:false //Name Label 사라지지 않는 버그 해결
        
        //nameTextFieldHeightAngher
        
        
        
        emailTextFieldHeightAngher?.isActive = false
        emailTextFieldHeightAngher = emailTextFiled.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegiseterSegmentedControl.selectedSegmentIndex == 0 ? 1/2: 1/3)
        //로그인 화면을 클릭을 경우 사이즈를 1/2로 레지스터 화면을 클릭을경우 화면을 1/3로
        emailTextFieldHeightAngher?.isActive = true
        
        
        passwordTextFieldHeightAngher?.isActive = false
        passwordTextFieldHeightAngher = passwordTextFiled.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegiseterSegmentedControl.selectedSegmentIndex == 0 ? 1/2: 1/3)
        //로그인 화면을 클릭을 경우 사이즈를 1/2로 레지스터 화면을 클릭을경우 화면을 1/3로
        passwordTextFieldHeightAngher?.isActive = true
    }
    func handleLoginRegister(){
    
        
        
    
        if loginRegiseterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        }else{
            handleRegister()
        }
    }
    func handleLogin(){
        
        guard let email = emailTextFiled.text, let passowrd = passwordTextFiled.text else{
            print("Form is not valuse")
            return
        }
        
        
        FIRAuth.auth()?.signIn(withEmail: email, password: passowrd, completion: { (user, err) in
            if err != nil{
                print(err ?? "not Data")
                return
            }
            
            
            self.messagesController?.fetchUserAndSetupNaBarTtile()
            
            self.dismiss(animated: true, completion: nil)
        })
        
    }
    func handleRegister(){
    
        guard let email = emailTextFiled.text, let _ = passwordTextFiled.text, let name = nameTextFiled.text else{
            print ("Forme is not value")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: emailTextFiled.text!, password: passwordTextFiled.text!, completion: { (FIRUser, error) in
            if error != nil{
                print(error ?? "Not data")
                return
            }
            guard let uid = FIRUser?.uid else{
                return
            }
            let imageName = NSUUID().uuidString
            
            
            let storageRef = FIRStorage.storage().reference().child("profile_images ").child("\(imageName).png")
            // UIImageJPEGRepresentation  : Compression Fuction
            if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1){
               
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil{
                        print(error)
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString{
                        
                         let values = ["name":name, "email":email,"profileImageUrl":profileImageUrl] as [String : Any]
                        self.registerUserIntoDatabaseWithUID(uid: uid,values:values as [String : Any])
                        
                    }
                    
                   
                    
                })
                
            }
            
            
            
        })
    }
    func registerUserIntoDatabaseWithUID(uid:String,values:[String:Any]) -> Void {
        let ref = FIRDatabase.database().reference()
        let userReference = ref.child("users").child(uid)
        //
        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil{
                print(err ?? "not Data")
                return
            }
            let user = User()
            user.setValuesForKeys(values)
            self.messagesController?.setupNavBarWithUser(user: user)
            print("saved user successfully into firebase db")
            self.dismiss(animated: true, completion: nil)
        })
        
    }
    
    
    let nameTextFiled: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    
    let nameSeparatorView :UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r:220,g:220,b:220)
        view.translatesAutoresizingMaskIntoConstraints = false
    
       return view
    }()
    
    let emailTextFiled: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Email"
         tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let emailSeparatorView :UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r:220,g:220,b:220)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    let passwordTextFiled: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    
    let profileTextField : UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var profileImageView : UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "car")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImage)))
        imageView.isUserInteractionEnabled=true
        return imageView
    }()
    
    let passwordStateLabel :UILabel = {
       let label = UILabel()
        label.text = "TEST"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        return label
    }()
    
    let textStateLabel :UILabel = {
        let label = UILabel()
        
        label.text = "TEST"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        return label
        
    }()
    
    func handleSelectProfileImage(){
        handleSelectProfileImageView()
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor(r:61,g:91,b:151)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegiseterSegmentedControl)
        
        
        setupInputsContainerView()
        setuoLoginRegisterButton()
        setupProfileImage()
        setLoginRegisterSegmentedControl()
        
        
        
        
    }
    func setLoginRegisterSegmentedControl(){
        loginRegiseterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegiseterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegiseterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier : 1).isActive = true
        loginRegiseterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    func setupProfileImage(){
        
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegiseterSegmentedControl.topAnchor,constant:-15).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
    }
    
    var inputsContainerViewHeightAnchor :NSLayoutConstraint?
    var nameTextFieldHeightAngher:NSLayoutConstraint?
    var emailTextFieldHeightAngher:NSLayoutConstraint?
    var passwordTextFieldHeightAngher:NSLayoutConstraint?
    
    
    func setupInputsContainerView(){
        
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextFiled)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextFiled)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextFiled)
        inputsContainerView.addSubview(passwordStateLabel)
        inputsContainerView.addSubview(textStateLabel)
        
        
        //need x, y, width, height constraints
        
        nameTextFiled.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextFiled.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextFiled.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAngher = nameTextFiled.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier:1/3)
        nameTextFieldHeightAngher?.isActive = true
        
        
        
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextFiled.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        emailTextFiled.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextFiled.topAnchor.constraint(equalTo: nameTextFiled.bottomAnchor).isActive = true
        emailTextFiled.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAngher = emailTextFiled.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier:1/3)
        emailTextFieldHeightAngher?.isActive = true
        
        
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextFiled.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        
        
        passwordTextFiled.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextFiled.topAnchor.constraint(equalTo: emailTextFiled.bottomAnchor).isActive = true
        passwordTextFiled.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAngher = passwordTextFiled.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier:1/3)
        
        passwordTextFieldHeightAngher?.isActive = true
        
        
        passwordStateLabel.topAnchor.constraint(equalTo: passwordTextFiled.topAnchor,constant : 15).isActive = true
        passwordStateLabel.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor,constant:8).isActive = true
        
        
        textStateLabel.topAnchor.constraint(equalTo: emailTextFiled.topAnchor,constant : 15).isActive = true
        textStateLabel.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor,constant:8).isActive = true
        
        
        
        //중요 코드 리뷰 했으면 좋은 부분 -> 아직까지 Rx개념이 제대로 잡히지 않음
        emailTextFiled.rx.text.orEmpty.asObservable().map({ (isValidEmail(testStr:$0))}).subscribe(onNext: { (validity) in
            self.textStateLabel.text = validity ? "" : "아이디를 정확이 입력해주세요"
            
        })
        
        
        //중요 코드 리뷰 했으면 좋은 부분 -> 아직까지 Rx개념이 제대로 잡히지 않음
        passwordTextFiled.rx.text.orEmpty.asObservable().map({ ($0.characters.count) >= 5 || $0.isEmpty}).subscribe(onNext: { (validity) in
            self.passwordStateLabel.text = validity ? "" : "다섯글자 이상 입력해주세요"
            
        })
    
    
    
    
    
    }
    
    
    
    
    
    
    
    
    func setuoLoginRegisterButton(){
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    }
    
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    
    
    
    
}
func isValidEmail(testStr:String) -> Bool {
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

extension UIColor{
    
    convenience init(r:CGFloat, g:CGFloat, b:CGFloat){
        
        
        self.init(red:r/255,green:g/255,blue:b/255,alpha:1)
    }
}
extension LoginController :UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    func handleSelectProfileImageView(){
        
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        
        
        var selectedImageFromePicker : UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromePicker = editedImage
            
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromePicker = originalImage
            
        }
        if let selectedImage = selectedImageFromePicker{
            profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel picker")
    }
    
    
}
