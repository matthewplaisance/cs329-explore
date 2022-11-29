//
//  OthUserPageViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/29/22.
//

import UIKit
import CoreData

class OthUserPageViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePhotoView: UIImageView!
    
    @IBOutlet weak var friendBtn: UIButton!
    var data = [NSManagedObject]()
    var pageFor:String!
    var areFriends = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.data = fetchUserCoreData(user: self.pageFor, entity: "Post")
        let userData = fetchUserCoreData(user: self.pageFor, entity: "User")[0]
        let profPhotoData = userData.value(forKey: "profilePhoto") as! Data
        
        self.profilePhotoView.image = UIImage(data: profPhotoData)
        self.usernameLabel.text = userData.value(forKey: "username") as? String
        
        for i in currUserFriends {
            let user = i["email"] as! String
            if user == self.pageFor {
                self.friendBtn.setTitle("Friends", for: .normal)
                self.areFriends = true
            }
        }
    }
    
    @IBAction func friendBtnHit(_ sender: Any) {
        if self.areFriends == false {
            self.friendBtn.setTitle("Request Sent", for: .normal)
            sendFriendRequest(othUser: self.pageFor)
        }else{
            //alert to remove friend
        }
    }
    
    
    @IBAction func homeBtnHit(_ sender: Any) {
        performSegue(withIdentifier: "feedSeg", sender: nil)
    }
    
    @IBAction func pageBtnHit(_ sender: Any) {
    }
}

extension OthUserPageViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellID, for: indexPath) as! PagePhotoCell//new reuseable cell for table
        let row = indexPath.row
        
        let imageData = self.data[row].value(forKey: "content") as! Data
        cell.pageImageView.image = UIImage(data: imageData)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        print("row: \(row)")
        
        let feedVC = storyBoard.instantiateViewController(withIdentifier: "feedVC") as! FeedViewController
        let dataAsDict = nsPostObjToDict(postCd: self.data)
        
        feedVC.data = dataAsDict
        feedVC.userPage = self.pageFor
        feedVC.scrollTo = row
        self.present(feedVC, animated:true, completion:nil)
    }
    
    
}
