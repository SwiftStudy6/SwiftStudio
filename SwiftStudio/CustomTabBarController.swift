//
//  CustomTabBarController.swift
//  SwiftStudio
//
//  Created by David June Kang on 2016. 12. 30..
//  Copyright © 2016년 ven2s.soft. All rights reserved.
//

import UIKit

class CustomTabBarController: UIViewController {

    var currentViewController : UIViewController? = nil
    @IBOutlet weak var placeholderView  : UIView? = nil
    @IBOutlet var bottomView: UIView!
    
    //TabBar Button
    @IBOutlet var boardButton: CustomButton!
    @IBOutlet var chatButton: CustomButton!
    @IBOutlet var milestoneButton: CustomButton!
    @IBOutlet var userListButton: CustomButton!
    @IBOutlet var settingButton: CustomButton!
    
    var availableIdentifiers : [String]!
    @IBOutlet var tabBarButtons : [CustomButton] = []
    var targetIdentifier : CustomButton! = nil
    
    var titleStr: String! = nil
    
    private let pinkshRed = UIColor(red: 233/255, green: 29/255, blue: 41/255, alpha: 1.0);
    
    
    enum TargetIdentifier : Int {
        case TargetIdentifierBoard = 0
        case TargetIdentifierChat
        case TargetIdentifierMileStone
        case TargetIdentifierUserList
        case TargetIdentifierSetting
    }
    
    

    
    func targetIdentifierName(_ identifier: TargetIdentifier) -> String{
        var result : String = ""
        
        switch identifier {
        case .TargetIdentifierBoard:
            result = "Board"
        case .TargetIdentifierChat:
            result = "Chat"
        case .TargetIdentifierMileStone:
            result = "MileStone"
        case .TargetIdentifierUserList:
            result = "UserList"
        case .TargetIdentifierSetting:
            result = "Setting"
        }
        
        return result
    }

    func setSelectedIndex(_ idx : Int){
        if(self.tabBarButtons.count <= idx) { return }
        
        self.performSegue(withIdentifier: self.availableIdentifiers[idx] , sender: self.tabBarButtons[idx])
    }
   
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(self.availableIdentifiers.contains(where: {$0 == segue.identifier})){
            for button in self.tabBarButtons {
                if sender != nil && !(button.isEqual(sender)) {
                    button.isSelected = false
                } else {
                    button.isSelected = true
                    self.targetIdentifier = sender as! CustomButton
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        availableIdentifiers = ["Board", "Chat", "MileStone", "UserList", "Setting"]
        tabBarButtons = [self.boardButton, self.chatButton, self.milestoneButton, self.userListButton, self.settingButton]
        
        //메인타이틀을 올려
        if(self.titleStr == nil){
            self.titleStr = "Swift Study"
        }
            
        navigationItem.title = self.titleStr
        
        tabbarSetting()
        
        self.performSegue(withIdentifier: "Board", sender: tabBarButtons[0])
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabbarSetting(){
        
        self.bottomView.backgroundColor = .white
        
        let lineView = UIView(frame: CGRect(x: 0, y: 1, width: self.view.frame.width, height: 1))
        lineView.backgroundColor = .gray
        
        self.bottomView.addSubview(lineView)
        
        self.boardButton = {
            let _button = self.boardButton
            
            let _image = _button!.resizeImage(image: UIImage.init(named: "List")!, targetSize: CGSize(width: 27 , height: 27))
            
            _button!.setImage(_image, for: .normal)
            _button!.setImage(_image, for: .selected)
            _button!.setTitle("게시판", for: .normal)
            _button!.setTitleColor(.black, for: .normal)
            _button!.setTitleColor(pinkshRed, for: .selected)
            _button!.alignContentVerticallyByCenter(offset: 18)
            _button!.titleLabel!.font = UIFont.systemFont(ofSize: 10)
            _button!.contentHorizontalAlignment = .left
            _button!.contentVerticalAlignment = .center
            _button!.titleLabel?.tintColor = .clear
                        
            return _button!
        }()

        self.chatButton = {
            let _button = self.chatButton
            
            let _image = _button!.resizeImage(image: UIImage.init(named: "Chat")!, targetSize: CGSize(width: 27 , height: 27))
            
            _button!.setImage(_image, for: .normal)
            _button!.setImage(_image, for: .selected)
            _button!.setTitle("대화방", for: .normal)
            _button!.setTitleColor(.black, for: .normal)
            _button!.setTitleColor(pinkshRed, for: .selected)
            _button!.alignContentVerticallyByCenter(offset: 18)
            _button!.titleLabel!.font = UIFont.systemFont(ofSize: 10)
            _button!.contentHorizontalAlignment = .left
            _button!.contentVerticalAlignment = .center
            _button!.titleLabel?.tintColor = .clear

           return _button!
        }()
        
        self.milestoneButton = {
            let _button = self.milestoneButton
            let _image = _button!.resizeImage(image: UIImage.init(named: "CheckMark")!, targetSize: CGSize(width: 27 , height: 27))
            
            _button!.setImage(_image, for: .normal)
            _button!.setImage(_image, for: .selected)
            _button!.setTitle("마일스톤", for: .normal)
            _button!.setTitleColor(.black, for: .normal)
            _button!.setTitleColor(pinkshRed, for: .selected)
            _button!.alignContentVerticallyByCenter(offset: 18)
            _button!.titleLabel!.font = UIFont.systemFont(ofSize: 10)
            _button!.contentHorizontalAlignment = .left
            _button!.contentVerticalAlignment = .center
            _button!.titleLabel?.tintColor = .clear
            
            return _button!
        }()
        
        self.userListButton = {
            let _button = self.userListButton
            
            let _image = _button!.resizeImage(image: UIImage.init(named: "User")!, targetSize: CGSize(width: 27 , height: 27))
            
            _button!.setImage(_image, for: .normal)
            _button!.setImage(_image, for: .selected)
            _button!.setTitle("사용자목록", for: .normal)
            _button!.setTitleColor(.black, for: .normal)
            _button!.setTitleColor(pinkshRed, for: .selected)
            _button!.alignContentVerticallyByCenter(offset: 18)
            _button!.titleLabel!.font = UIFont.systemFont(ofSize: 10)
            _button!.contentHorizontalAlignment = .left
            _button!.contentVerticalAlignment = .center
            _button!.titleLabel?.tintColor = .clear
            
            return _button!
        }()
        
        self.settingButton = {
            let _button = self.settingButton
            
            let _image = _button!.resizeImage(image: UIImage.init(named: "Setting")!, targetSize: CGSize(width: 27 , height: 27))
            
            _button!.setImage(_image, for: .normal)
            _button!.setImage(_image, for: .selected)
            _button!.setTitle("설정", for: .normal)
            _button!.setTitleColor(.black, for: .normal)
            _button!.setTitleColor(pinkshRed, for: .selected)
            _button!.alignContentVerticallyByCenter(offset: 18)
            _button!.titleLabel!.font = UIFont.systemFont(ofSize: 10)
            _button!.contentHorizontalAlignment = .left
            _button!.contentVerticalAlignment = .center
            _button!.titleLabel?.tintColor = .clear
            
            return _button!
        }()
        
    }
   

}
