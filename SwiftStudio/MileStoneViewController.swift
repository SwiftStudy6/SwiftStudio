//
//  MileStoneViewController.swift
//  SwiftStudio
//
//  Created by 홍대호 on 2017. 1. 12..
//  Copyright © 2017년 swift. All rights reserved.
//

import Foundation
import Firebase

class MildStoneViewController: UIViewController {
  
    @IBOutlet weak var mainlabel: UILabel!
    
    @IBOutlet weak var InputFiled: UITextField!
   

   
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
         createView()
    
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
        
        // Dispose of any resources that can be recreated.
    }
    
    
    func createView(){
     /*
        let pinkshRed = UIColor(red: 233/255, green: 29/255, blue: 41/255, alpha: 1.0)
        
        //Label
        let label1 : UILabel = {
            let _label = UILabel(/*frame: CGRect(x: 28, y: 90, width: view.frame.width-(28*2), height: 65)*/)
            _label.text = "MileStone"
            _label.textColor = pinkshRed
            _label.font = UIFont.boldSystemFont(ofSize: 48)
            _label.textAlignment = NSTextAlignment.center
            _label.translatesAutoresizingMaskIntoConstraints = false
            
            return _label
        }()
        
      */
             self.mainlabel.text = "MildStone "
        self.view.addSubview(self.mainlabel)
        
        
        self.InputFiled = {
            let _textField = UITextField(/*frame: CGRect(x: 28, y: 222, width: view.frame.width-(28*2), height: 50)*/)
            let padding = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 16))
            _textField.leftView = padding
            _textField.leftViewMode = UITextFieldViewMode.always
            _textField.placeholder = "INPUT"
            _textField.font = UIFont.systemFont(ofSize: 14)
            _textField.borderStyle = UITextBorderStyle.line
           // _textField.delegate = self
            _textField.keyboardType = .emailAddress
            _textField.tag = 1
            _textField.translatesAutoresizingMaskIntoConstraints = false
            _textField.keyboardType = .emailAddress
            _textField.returnKeyType = .next
            
            return _textField
        }()
        
        
        
        
        
        
 
    }
    
    
   
}
