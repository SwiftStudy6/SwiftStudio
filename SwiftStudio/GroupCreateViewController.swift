//
//  GroupCreateViewController.swift
//  SwiftStudio
//
//  Created by David June Kang on 2017. 2. 17..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit
import Firebase
import Toaster

private let GroupCreateChildName = "Group"

enum GroupAuthority : NSNumber {
    case master = 0, manager, member
}

enum GroupPurpose : NSNumber {
    case family = 0, school, hobby, study, company, fan, parent, etc
}

class GroupCreateViewController: UIViewController {
    
    private let groupRef = FIRDatabase.database().reference().child(GroupCreateChildName)
    
    private let storageRef = FIRStorage.storage().reference()
    
    private let placeHolder = UIImage(named: "Camera-100.png")
    
    lazy var groupName: UITextField! = {
       let _groupName = UITextField()
        _groupName.borderStyle = .roundedRect
        _groupName.placeholder = "만드실 모임의 이름을 입력해주세요."
        _groupName.returnKeyType = .done
        _groupName.delegate = self
        
        _groupName.translatesAutoresizingMaskIntoConstraints = false
        
        return _groupName
    }()
    
    lazy var groupImage : UIImageView! = {
       
        let _groupImage : UIImageView = UIImageView(image: self.placeHolder)
        _groupImage.layer.cornerRadius = 7
        _groupImage.layer.masksToBounds = true
        _groupImage.backgroundColor = .gray
        _groupImage.contentMode = .center
        
        _groupImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlerImage)))
        
        _groupImage.translatesAutoresizingMaskIntoConstraints = false
        
        _groupImage.isUserInteractionEnabled = true
        
        return _groupImage
        
    }()
    
    lazy var groupPurpose: UIPickerView! = {
        let _groupPurpose = UIPickerView()
        _groupPurpose.dataSource = self
        _groupPurpose.delegate = self
        
        _groupPurpose.translatesAutoresizingMaskIntoConstraints = false
        
        return _groupPurpose
    }()
    
    lazy var groupVisible: UISwitch! = {
        let _groupVisible = UISwitch()
        _groupVisible.isOn = false //default
        _groupVisible.translatesAutoresizingMaskIntoConstraints = false
        
        return _groupVisible
    }()
    
    var delegate : GroupViewController?
    
    let pickerList : Array<String>! = ["가족", "학교/동아리/동창", "운동/취미/동호회", "스터디/취업" ,"회사/팀", "팬클럽/서포터즈", "맘/학무모", "기타"]

    lazy var cancelButton : UIButton = {
        let _button = UIButton()
        
        _button.setTitle("취소", for: .normal)
        _button.setTitleColor(.red, for: .normal)
        _button.setTitleColor(UIColor(netHex:0xFF69B4, alpha: 0.8), for: .highlighted)
        _button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        _button.titleLabel?.minimumScaleFactor = 0.4
        _button.addTarget(self, action: #selector(cancelToCreate(_:)), for: .touchUpInside)
        
        
        _button.translatesAutoresizingMaskIntoConstraints = false
        
        return _button
    }()
    
    lazy var createButton : UIButton = {
        let _button = UIButton()
        
        
        _button.setTitle("모임 생성", for: .normal)
        _button.setTitleColor(.black, for: .normal)
        _button.setTitleColor(.gray, for: .highlighted)
        _button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        _button.titleLabel?.minimumScaleFactor = 0.4
        
        _button.addTarget(self, action: #selector(groupCreate(_:)), for: .touchUpInside)
        
        _button.translatesAutoresizingMaskIntoConstraints = false
        
        return _button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSetUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //view Setting
    func viewSetUp(){
        self.view.backgroundColor = .white
        
        //Cancel Button
        self.view.addSubview(cancelButton)
        
        self.cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 28).isActive = true
        self.cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        self.cancelButton.heightAnchor.constraint(lessThanOrEqualToConstant: 30).isActive = true
        self.cancelButton.widthAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
        
        
        //Create Button
        self.view.addSubview(createButton)
        
        self.createButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 28).isActive = true
        self.createButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        self.createButton.heightAnchor.constraint(lessThanOrEqualToConstant: 30).isActive = true
        self.createButton.widthAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
        
        //Group Name
        self.view.addSubview(groupName)
        
        groupName.topAnchor.constraint(equalTo: view.topAnchor, constant: 91).isActive = true
        groupName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        groupName.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        groupName.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        //Group Cover ImageView
        self.view.addSubview(groupImage)
        
        let marginOffset = self.view.frame.width / 4    //양쪽 마진계산
        
        let imageHeight = (self.view.frame.width / 2)   //이미지의 크기 계산
        
        groupImage.topAnchor.constraint(equalTo: groupName.bottomAnchor, constant: 10).isActive = true
        groupImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: marginOffset).isActive = true
        groupImage.widthAnchor.constraint(equalToConstant: imageHeight).isActive = true
        groupImage.heightAnchor.constraint(equalToConstant: imageHeight * 0.75).isActive = true
        
        
        //Label purpose
        let label2 = UILabel()
        
        label2.text = "어떤 모임을 만드실껀가요?"
        label2.textAlignment = .left
        label2.textColor = .black
        label2.font = UIFont.systemFont(ofSize: 17)
        label2.minimumScaleFactor = 0.52
        
        label2.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(label2)
        
        label2.topAnchor.constraint(equalTo: groupImage.bottomAnchor, constant: 10).isActive = true
        label2.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        label2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        label2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        //Group Purpose PickerView
        self.view.addSubview(groupPurpose)
        
        groupPurpose.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 10).isActive = true
        groupPurpose.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        groupPurpose.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        groupPurpose.heightAnchor.constraint(equalToConstant: 83).isActive = true
        
        
        //Gorup Visible Label
        let label3 = UILabel()
        
        label3.text = "모임공개설정여부"
        label3.textAlignment = .center
        label3.textColor = .black
        label3.font = UIFont.systemFont(ofSize: 17)
        label3.minimumScaleFactor = 11 / label3.font.pointSize
        label3.adjustsFontSizeToFitWidth = true
        
        label3.translatesAutoresizingMaskIntoConstraints = false
        
        let size = view.frame.size
        
        let margin = (size.width - 188) / 2
        
        self.view.addSubview(label3)
        
        label3.topAnchor.constraint(equalTo: groupPurpose.bottomAnchor, constant: 40).isActive = true
        label3.leftAnchor.constraint(lessThanOrEqualTo: view.leftAnchor, constant: margin).isActive = true
        label3.widthAnchor.constraint(equalToConstant: 129).isActive = true
        label3.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        
        //Group Private Yn
        self.view.addSubview(groupVisible)
        
        groupVisible.topAnchor.constraint(equalTo: groupPurpose.bottomAnchor, constant: 40).isActive = true
        groupVisible.leftAnchor.constraint(equalTo: label3.rightAnchor, constant: 20).isActive = true
        groupVisible.rightAnchor.constraint(equalTo: view.rightAnchor, constant: margin).isActive = true
        groupVisible.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
    }

    
    //취소 버튼
    func cancelToCreate(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //생성버튼
    func groupCreate(_ sender: Any) {
        let key = groupRef.childByAutoId().key //그룹키를 생성
        
        //그룹이름 비었을경우
        guard groupName.text != nil, !(groupName.text?.isEmpty)! else {
            
            let alertController = UIAlertController(title: "알림", message: "생성할 모임의 이름을 입력하셔야 합니다.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "확인", style: .default, handler: { (action) in
                self.groupName.becomeFirstResponder()
            })
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        //이미지가 비었을경우
        guard groupImage.image != placeHolder  else {
            
            
            let alertController = UIAlertController(title: "알림", message: "생성할 모임의 커버 이미지를 선택하셔야 합니다.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "확인", style: .default, handler: { (action) in
                self.handlerImage()
            })
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
          
            return
        }
        
        let groupManagers : [String :Any] = [
            (FIRAuth.auth()?.currentUser?.uid)! : [
                "userName:" : FIRAuth.auth()?.currentUser?.displayName ?? "No Name",
                "authority" : GroupAuthority.master.hashValue
            ]
        ]
        
        let groupMembers  : [String :Any]  = [
            (FIRAuth.auth()?.currentUser?.uid)! : [
                "userName:" : FIRAuth.auth()?.currentUser?.displayName ?? "No Name",
                "authority" : GroupAuthority.master.hashValue,
                "profile_url" : ""
            ]
            
        ]
        
        var object : GroupObject! = nil
        
        let data = UIImageJPEGRepresentation(groupImage.image!, 1.0)
        
        //파일 업로드후 그룹과 유저에 저장을 한다.
        self.fileUplaod(data!, key) { (urlString) in
            
            let value : [String: Any] = [
                "groupName"     : self.groupName.text!,
                "groupPurpose"  : self.groupPurpose.selectedRow(inComponent: 0),
                "groupManagers" : groupManagers,
                "groupMembers"  : groupMembers,
                "privateYn"     : self.groupVisible.isOn,
                "coverImgUrl"   : urlString,
                "createTime"    : FIRServerValue.timestamp(),
                "editTime"      : FIRServerValue.timestamp()
            ]
            
            
            //구룹에 저장을 한다.
            self.groupRef.child(key).setValue(value) { (error, ref) in
                guard error == nil else {
                    return
                }
           
                ref.observe(.value, with: { (snapshot) in
                    guard snapshot.exists() else {
                        return
                    }
                    let dict = snapshot.value as! [String: Any]
                    
                    object = GroupObject()
                    object.key          = snapshot.key
                    object.name         = value["groupName"] as! String
                    object.managers     = value["groupManagers"] as! [String : Any]
                    object.members      = value["groupMembers"] as! [String : Any]
                    object.purpose      = value["groupPurpose"] as! NSNumber
                    object.privateYn    = dict["privateYn"] as! Bool
                    object.coverImgUrl  = dict["coverImgUrl"] as! String
                    object.createTime   = dict["createTime"] as! Double
                    object.editTime     = dict["editTime"] as! Double
                    
                    let value: [String : Any] = [
                        "groupName" : object.name,
                        "coverImgUrl" : object.coverImgUrl
                    ]
                    
                    let userRef = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
                    
                    userRef.runTransactionBlock({ (currentData) -> FIRTransactionResult in
                        if var userInfo = currentData.value as? [String : Any] {
                            var groupList : Dictionary<String, Any>
                            groupList = userInfo["groupList"] as? [String : Any] ?? [:]
                            
                            groupList[object.key] = value
                            userInfo["groupList"] = groupList
                            
                            
                            // Set value and report transaction success
                            currentData.value = userInfo
                            return FIRTransactionResult.success(withValue: currentData)
                        }
                        return FIRTransactionResult.success(withValue: currentData)
                        
                    }, andCompletionBlock: { (error, bool, snapshot) in
                        guard error == nil else{
                            return
                        }
                        
                        self.dismiss(animated: true, completion: {
                            self.delegate?.afterCreateGroup(value)
                        })
                    })
                    
                    
                }, withCancel: { (error) in
                    guard error == nil else{
                        return
                    }
                })
            }
        }
    }
    
        func handlerImage(){
        let alertSheet = UIAlertController(title: "사진선택", message: "이미지를 선택해주세요", preferredStyle: .actionSheet)
        
        
        let albumAction = UIAlertAction(title: "앨범에서 불러오기", style: .default) { (action) in
            self.imagePickerHandler(.savedPhotosAlbum)
        }
        
        let cameraAction = UIAlertAction(title: "카메라에서 바로찍기", style: .default) { (action) in
            self.imagePickerHandler(.camera)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertSheet.addAction(albumAction)
        alertSheet.addAction(cameraAction)
        alertSheet.addAction(cancelAction)
        
        self.present(alertSheet, animated: true, completion: nil)
    }
    
    
    func imagePickerHandler(_ type : UIImagePickerControllerSourceType){
        
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return
        }
        
        let pickerController = UIImagePickerController()
        
        pickerController.sourceType = type
        pickerController.delegate = self
        
        self.present(pickerController, animated: true, completion: nil)
        
    }
    
    func fileUplaod(_ data :Data, _ key : String, completionBlock : ((String) -> Swift.Void)? = nil){
        
        
        storageRef.child("GroupCoverImage/\(key).jpg").put(data, metadata: nil) { metadata, error in
            if (error != nil) {
                // Uh-oh, an error occurred!
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                 completionBlock!((metadata!.downloadURL()?.absoluteString)!)
            }
        }
    }

}

extension GroupCreateViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            groupImage.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension GroupCreateViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension GroupCreateViewController : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerList[row]
    }
}

extension GroupCreateViewController : UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerList.count == 0 ? 1 : pickerList.count
    }
}
