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

class testMileController: UIViewController, UITextFieldDelegate {
    
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

      //  let vc = UIStoryboard(name: "MileStone", bundle: nil).instantiateInitialViewController() as! MileStoneViewController
    
        
        // 시작
     //   showViewController(vc, true, nil)
        
        
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
        loginButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 50).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
      
        
        
        
    }
    @IBAction func buttonTouchUpInside(_ sender:AnyObject){
        
        let vc = UIStoryboard(name: "MileStone", bundle: nil).instantiateInitialViewController() as! MileStoneViewController
        
        
        // 시작
        showViewController(vc, true, nil)
        
    }
    
    override func showViewController(_ viewController: UIViewController,_ animated : Bool,_ completion :(() -> Swift.Void)? = nil){
        var activateController = UIApplication.shared.keyWindow?.rootViewController
        
        if(activateController?.isKind(of: UINavigationController.self))!{
            activateController = (activateController as! UINavigationController).visibleViewController
        }else if((activateController?.presentedViewController) != nil){
            activateController = activateController?.presentedViewController
        }
        
        activateController?.present(viewController, animated: animated, completion: completion)
    }

}



