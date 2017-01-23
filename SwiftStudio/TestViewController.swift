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
    func deleteClick(sender:UIButton, cell:TestCell)
}

class TestCell: UITableViewCell {
 
    var key : String! = nil
    var time : String! = nil
    
    var delegate : TestCellDelegate? = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let deleteButton = UIButton()
        deleteButton.setTitle("삭제", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.setTitleColor(.gray, for: .highlighted)
        deleteButton.layer.cornerRadius = 5.0
        deleteButton.layer.borderColor = UIColor.red.cgColor
        deleteButton.layer.borderWidth = 2
        
        deleteButton.addTarget(self, action: #selector(buttonTouchUpInside(sender:)), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
    
        self.contentView.addSubview(deleteButton)
        
        self.textLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        deleteButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        deleteButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.textLabel?.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 5).isActive = true
        self.textLabel?.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.textLabel?.rightAnchor.constraint(equalTo: deleteButton.leftAnchor, constant: -5).isActive = true
        self.textLabel?.heightAnchor.constraint(equalTo: self.contentView.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //삭제버튼 이벤트
    func buttonTouchUpInside(sender:UIButton){
        print("press")
        self.delegate?.deleteClick(sender: sender,  cell:self)
    }

}


class TestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TestCellDelegate{
    
    var ref : FIRDatabaseReference! = FIRDatabase.database().reference()
    let cellId = "cell"
    var dataList : Array<Any>? = []
    
    var tableView : UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        eventTestDatas()

        
        //User 가 인증되지 않았을경우 처음으로 돌아간다. ( 테스트를 위해 삭제 )
//        guard (FIRAuth.auth()?.currentUser) != nil else{
//            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
//            return
//        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        //기본뷰 생성을 위한것
        createView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //파이어베이스 이벤트 모음
    func eventTestDatas() {
        
        reloadTestData()
        
        //삭제시호출
        ref.child("TestDatas").observe(.childRemoved, with: {(snapshot) in
            guard snapshot.value != nil else {
                return
            }
            print(snapshot.value)
            self.reloadTestData()

        })
        
        //추가시 호출
        ref.child("TestDatas").observe(.childAdded, with: {(snapshot) in
            guard snapshot.value != nil else {
                return
            }
            
            self.reloadTestData()
        });

    }
    
    //데이터를 전체를 가져온다
    func reloadTestData(){
        ref.child("TestDatas").observe(.value, with: { (snapshot) in
            guard snapshot.value != nil else {
                return
            }
            
            //배열을 모두 삭제한다.
            self.dataList?.removeAll()
            
            //.value 옵션을 쓸경우 한번에 전체 다 들고 온다.
            let enumerate = snapshot.children
            while let rest = enumerate.nextObject()  as? FIRDataSnapshot {
                var dic : [String : Any] = rest.value as! [String : Any]
                dic["key"] = rest.key
                dic["time"] = NSDate(timeIntervalSince1970: dic["time"] as! Double / 1000.0).toString()
                self.dataList?.append(dic)
            }
            
            //제대로 추가가 됬는지 확인한다.
            if(self.dataList?.count == 0) {
                return
            }
            
            //백그라운드 스레드의 충돌로 인해서
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
            
        })

    }
    
    //뷰생성에 대한 정보를 담음
    func createView(){
        
        let buttonAdd = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(addClick))
        self.navigationItem.rightBarButtonItem = buttonAdd
        
        let buttonBack = UIBarButtonItem(title: "< 뒤로가기", style: .plain, target: self, action: #selector(backButton))
        self.navigationItem.leftBarButtonItem = buttonBack
        
        let tableView = UITableView(frame: CGRect(x: 5, y: 30, width: self.view.frame.size.width-10, height: 200))
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TestCell.self, forCellReuseIdentifier: cellId)
        
        self.tableView = tableView
        self.tableView.backgroundColor = .gray
        
        self.view.addSubview(self.tableView)
    }
    
    //등록버튼 이벤트
    func addClick(){
        
        
        let key = ref.child("TestDatas").childByAutoId().key
        
        let addControlelr = UIAlertController(title: "내용추가", message: "텍스트를 입력해주세요", preferredStyle: .alert)
        
        addControlelr.addTextField { (text) in
            //text setting
        }
        
        //전송버튼 이벤트
        let confrimAction = UIAlertAction(title: "전송", style: .default, handler: { (action) in
            //
            let test : UITextField! = addControlelr.textFields?[0]

            self.ref.child("TestDatas").child(key).setValue(["text":test.text!, "time":FIRServerValue.timestamp()])
            
        })
        
        //취소버튼 이벤트
        let cancelAction = UIAlertAction(title: "취소", style: .destructive) { (action) in
            print("취소되었습니다")

        }
        
        addControlelr.addAction(confrimAction)
        addControlelr.addAction(cancelAction)

        present(addControlelr, animated: true, completion: nil)
    
    }
    
    //뒤로가기 이벤트
    func backButton(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK - TableView DataSource
    
    //섹션
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    //로우
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  dataList!.count >= 2 ? 2 :  dataList!.count //무조건적으로 2개만 출력한다.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TestCell
        
        if((dataList?.count)! > 0){
            let dict = dataList![indexPath.row] as? [String : Any]
            cell.key = dict?["key"] as! String
            cell.textLabel?.text = dict?["text"] as? String
            cell.textLabel?.textColor = .black
            cell.time = dict?["time"] as! String
        }
        
        cell.delegate = self //델리게이트 연결
        return cell
    }
    
    //로우 선택시 해당 키를 보여준다.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TestCell
        Toast(text:cell.time).show()
    }
    
    //MARK - TestCell Delegate
    func deleteClick(sender:UIButton,  cell:TestCell){
        print("Delete : \(cell.key)")
        self.ref.child("TestDatas").child(cell.key).removeValue()
    
        //파이어베이스가 데이터가 없을경우 데이터를 읽어오지 않으므로 강제로 삭제 시켜준다.
        var index = 0
        for data in self.dataList! {
            let dd  = data as? [String : String]
            if dd?["key"] == cell.key {
                self.dataList?.remove(at: index)
                if((self.dataList?.count)! <= 1){
                    self.tableView.reloadData()
                }
                break
            }
            index = index + 1
        }
    }
}
