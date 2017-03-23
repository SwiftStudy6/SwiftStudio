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

class GroupCreateViewController: UIViewController {
//    private let groupRef
    
    @IBOutlet var groupName: UITextField!
    @IBOutlet var groupPurpose: UIPickerView!
    @IBOutlet var groupVisible: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelToCreate(_ sender: Any) {
        
    }
    
    @IBAction func groupCreate(_ sender: Any) {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
