//
//  MileStoneDetailViewController.swift
//  SwiftStudio
//
//  Created by 홍대호 on 2017. 
//  Copyright © 2017년 swift. All rights reserved.


import Foundation
import UIKit

class MileStoneDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let  mile_detail_list = ["참석", "참석", "불참"]
    
    @IBOutlet weak var mainlabel: UILabel!
    
    @IBOutlet weak var acceptlabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.mainlabel.text = "MileDetail List"
        self.acceptlabel.text = "참석인원"
        
        
        navigationItem.title = "MileDetail List"
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(back))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        
        
        NSLog("detail printing")
        
    }
    
    let test_image = ["user", "user", "user"]
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (mile_detail_list.count)
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomMileStoneDetailViewTableViewCell
        
        
        cell.detailImage.image = UIImage(named: test_image[indexPath.row]+".png")
        
        cell.detailLabel1.text = mile_detail_list[indexPath.row]
        
        return (cell)
    }
    
    
    
    
    @IBAction func back(_ sender: Any) {
        
        
        //self.topMostController()
        
        //let vc = UIStoryboard(name: "MileStone", bundle: nil).instantiateInitialViewController() as! MileStoneViewController
       
        self.dismiss(animated: true, completion: nil)
    
 
       //  navigationController?.pushViewController(vc, animated: true)
        
        
      
        
        
        // 시작
      //  showViewController(vc, true, nil)
        
    }
    func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
    
    
    
    func showViewController(_ viewController: UIViewController,_ animated : Bool,_ completion :(() -> Swift.Void)? = nil){
        var activateController = UIApplication.shared.keyWindow?.rootViewController
        
        if(activateController?.isKind(of: UINavigationController.self))!{
            activateController = (activateController as! UINavigationController).visibleViewController
        }else if((activateController?.presentedViewController) != nil){
            activateController = activateController?.presentedViewController
        }
        
        activateController?.present(viewController, animated: animated, completion: completion)
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
