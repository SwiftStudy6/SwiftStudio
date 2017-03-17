//
//  GroupViewController.swift
//  SwiftStudio
//
//  Created by David June Kang on 2017. 2. 1..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit
import Firebase

class GroupObject : NSObject {
    let key: String! = nil      //Group Unique Key
    let name : String! = nil    //Group Name
    var owner : String! = nil   //Group Owner uid
    var manager : Array<String>! = nil //Group ManagerList
    var createTime : Double! = 0.0
    var editTime   : Double! = 0.0
}


class GroupCell : UICollectionViewCell {
    var groupObject : GroupObject!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AddCell : UICollectionViewCell {}

class GroupHeaderView: UICollectionReusableView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private let reuseIdentifier = "GroupCell"
private let reuseIdentifier2 = "AddCell"

private let groupPosts = "Group"

class GroupViewController: UICollectionViewController {
    
    var groupRef : FIRDatabaseReference! = FIRDatabase.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(AddCell.self, forCellWithReuseIdentifier: reuseIdentifier2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
