//
//  GroupSettingController.swift
//  SwiftStudio
//
//  Created by David June Kang on 2017. 4. 11..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit
import Firebase

enum GroupSettingAccessary : Int {
    case None = 0, Switch, Detail
}

private var settingDataList1 :[[String:Any]]!
private var settingDataList2 :[[String:Any]]!
private var settingDataList3 :[[String:Any]]!

private var authority : GroupAuthority! = nil



class GroupSettingController: UIViewController {
    
    var tableView : UITableView!
    
    weak var dataSource : GroupObject?
    
    let reuseIdentifier = "SettingCell"
    
    var ref : FIRDatabaseReference!
    
   lazy var backBarItem : UIBarButtonItem = {
        var _item = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(backButtonEvent))
 
        return _item
    }()
    
    func backButtonEvent() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //데이터가 없으면 셋팅창을 종료 시켜 버리겠어
        guard dataSource == nil else {
            
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        ref = FIRDatabase.database().reference().child("Group").child((dataSource?.key)!)
        
        setUpView()
        
        setUpAuthority((dataSource ?? nil)!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setUpView(){
        
        //기본 데이터 셋팅
        settingDataList1 = [
            ["text":"권한관리", "type":2],
            ["text":"공개여부", "type":1]
        ]
        settingDataList2 = [
            ["text":"프로필 수정", "type":2],
            ["text":"모임알림", "type":1],
            ["text":"채팅알람", "type":1]
        ]
        settingDataList3 = [
            ["text":"모임 탈퇴하기", "type":0],
            ["text":"모임 삭제하기", "type":0]
        ]
        
        //Navigation Item
        navigationItem.leftBarButtonItem = backBarItem
        
        let naviBar = UINavigationBar()
        naviBar.items = [navigationItem]
        naviBar.tintColor = Common().defaultColor
        naviBar.barTintColor = .white
        
        
        naviBar.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(naviBar)
        
        naviBar.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        naviBar.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        naviBar.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        naviBar.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        let statusBar = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 20))
        statusBar.backgroundColor = Common().defaultStatusColor
        self.view.addSubview(statusBar)
        
        
        //TableView Setting
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: naviBar.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    
    }
    
    //Swich Event
    func switchChangeEvent(_ target: UISwitch){
        let section = target.tag / 100
//        let row = target.tag - section
        
        if section == 1 {
            ref.runTransactionBlock({ (currentData) -> FIRTransactionResult in
                
                if var value = currentData.value as? [String : AnyObject] {
                    
                    value["privateYn"] = target.isOn as AnyObject
                    
                    currentData.value = value
                
                    
                }
                
                // Set value and report transaction success
                
                return FIRTransactionResult.success(withValue: currentData)
            }, andCompletionBlock: { (error, success, snapshot) in
                guard let _ = error else {
                    assertionFailure("Error : \(String(describing: error))")
                    return
                }
            })
        }
        
        if section == 2 {
            //TO-DO : 알림 설정에 관련 된 부분
        }
        
    }
    
    //권한에 따른 셋팅 화면 설정
    func setUpAuthority(_ data : GroupObject? = nil){
        guard data == nil else {
            return
        }
        let cUid = FIRAuth.auth()?.currentUser?.uid
        
        let managerList : [String : Any]! = data?.managers
        for (uid, val) in managerList {
            if( cUid == uid ){
                let value = val as! [String : Any]
                authority = GroupAuthority(rawValue: value["authority"] as! NSNumber)!
                
                if authority == .member {
                    settingDataList3.remove(at: 0)  //그룹 삭제 금지
                    settingDataList1.removeAll()    //그룹 권한 및 공개설정 금지
                }else if authority == .manager {
                    settingDataList3.remove(at: 0)  //그룹 삭제 금지
                    
                }
            }
        }
        
        
        
        
    }
}

extension GroupSettingController : UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        var sectionRow : Int = 0
        
        if section == 0 {
            sectionRow = 1
        }
        
        if section == 1 {
            sectionRow = settingDataList1.count
        }
        
        if section == 2 {
            sectionRow = settingDataList2.count
        }
        
        if section == 3 {
            sectionRow = settingDataList3.count
        }
        
        return sectionRow
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat! = 42
        
        if indexPath.section == 0 {
            height = 65
        }
        
        return height
    }
}

extension GroupSettingController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let haederView = UIView()
        return haederView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        var object : [String : Any]!
        
        cell.textLabel?.textAlignment = .left
        
        //섹션별 설정
        
        //이름 변경 섹션
        if indexPath.section == 0 {
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            cell.accessoryType = .disclosureIndicator
            object["text"] = dataSource?.name ?? ""
        }
        
        //그룹매니징 섹션
        if indexPath.section == 1 {
            object = settingDataList1[indexPath.row]
            
        }
        
        //개인정보 수정
        if indexPath.section == 2 {
            object = settingDataList2[indexPath.row]
        }
        
        //그룹 삭제 혹은 탈퇴
        if indexPath.section == 3 {
            object = settingDataList3[indexPath.row]
            cell.textLabel?.textColor = .red
        }
        
        cell.textLabel?.text = object["text"] as? String
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        
        //타입에 따른 설정
        switch((object["type"] as! GroupSettingAccessary)){
        case .None:
            cell.accessoryType = .none
            break
        case .Switch:
            let switchItem = UISwitch()
            switchItem.tag = (indexPath.section * 100) + indexPath.row
            switchItem.addTarget(self, action: #selector(switchChangeEvent(_:) ), for: .editingChanged)
            cell.accessoryView = switchItem
            break
            
        case .Detail :
            cell.accessoryType = .disclosureIndicator
            break
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if authority != .member {
                let alertController = UIAlertController(title: "모임 이름 변경", message: "변경하실 모임 이름을 입력하세요.", preferredStyle: .alert)
                
                alertController.addTextField(configurationHandler: { (UITextField) in
                    UITextField.text = self.dataSource?.name ?? ""
                    
                })
                
                
                let confirmAction = UIAlertAction(title: "변경", style: .default, handler: { (action) in
                    //TO-DO : 이름 변경 로직
                })
                
                let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                
                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        if indexPath.section == 1 {
            
        }
        
        if indexPath.section == 2 {
            
        }
        
        if indexPath.section == 3 {
            
        }
    }
}

