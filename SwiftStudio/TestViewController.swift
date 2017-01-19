//
//  TestViewController.swift
//  SwiftStudio
//
//  Created by David June Kang on 2017. 1. 18..
//  Copyright © 2017년 swift. All rights reserved.
//
/*
  실시간 데이터 사용법을 위한 가이드
 
 */
import UIKit
import Firebase
import FirebaseAuth
import Toaster

protocol TestCellDelegate {
    func deleteClick(sender:UIButton)
}

class TestCell: UITableViewCell {
 
    var key : String! = nil
    
    var delegate : TestCellDelegate? = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let deleteButton = UIButton()
        deleteButton.titleLabel?.text = "삭제"
        deleteButton.titleLabel?.textColor = .red
        deleteButton.layer.cornerRadius = 5.0
        deleteButton.layer.borderColor = UIColor.red.cgColor
        deleteButton.layer.borderWidth = 2
        
        deleteButton.addTarget(self, action: #selector(buttonTouchUpInside(sender:)), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        deleteButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        deleteButton.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.contentView.addSubview(deleteButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buttonTouchUpInside(sender:UIButton){
        self.delegate?.deleteClick(sender: sender)
    }

}

class TestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref : FIRDatabaseReference!
    let cellId = "cell"
    var dataList : Array<Any>?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //User 가 인증되지 않았을경우 처음으로 돌아간다.
        guard (FIRAuth.auth()?.currentUser) != nil else{
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = FIRDatabase.database().reference()
        
        readTestData()
        
        createView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func readTestData() {
        ref.child("TestData").observe(.value, with: { (snapshot) in
            guard snapshot != nil else {
                return
            }
            
            self.dataList = snapshot.value as? [String, AnyObject]
        })
    }
    
    func createView(){
        
        let buttonAdd = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(addClick))
        self.navigationItem.rightBarButtonItem = buttonAdd
        
        let tableView = UITableView(frame: CGRect(x: 5, y: 30, width: self.view.frame.size.width-10, height: 200))
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TestCell.self, forCellReuseIdentifier: cellId)
        
    }
    
    func addClick(){
        
    }
    //MARK - TableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TestCell
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TestCell
        let key = cell.key
        Toast(text:key).show()
    }
    
    

}
