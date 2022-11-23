//
//  PageViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/17/22.
//

import UIKit
import FirebaseAuth

let collectionCellID = "pageCollectionCell"
let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

class PageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var pageCollectionView: UICollectionView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    var data1 : [String] = ["ZilkerPark","MountBonnell"]
    var currUid = Auth.auth().currentUser?.email
    var data = [Dictionary<String, Any>]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageCollectionView.delegate = self
        pageCollectionView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        var storyboardId: String {
               return value(forKey: "storyboardIdentifier") as? String ?? "none"
           }
        if storyboardId == "PageVC"{
            let homeIcon = UIImage(systemName: "house")
            self.navigationController?.navigationBar.backIndicatorImage = homeIcon
            self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = homeIcon
            self.navigationController?.navigationBar.backItem?.title = ""
        }
        let userData = fetchUserCoreData(user: currUid!, entity: "User")[0]
        let profPhotoData = userData.value(forKey: "profilePhoto") as! Data
        let profPhoto = UIImage(data: profPhotoData)
        profileImage.image = profPhoto
        usernameLabel.text = userData.value(forKey: "username") as! String
        
        updatePosts()
        pageCollectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellID, for: indexPath) as! PagePhotoCell//new reuseable cell for table
        let row = indexPath.row
        
        cell.pageImageView.image = (data[row]["content"] as! UIImage)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let row = indexPath.row
        print("row: \(row)")
        let postKey = data[row]["date"]
        
        let feedVC = storyBoard.instantiateViewController(withIdentifier: "feedVC") as! FeedViewController
        
        feedVC.data = self.data
        feedVC.scrollTo = row
        self.present(feedVC, animated:true, completion:nil)
        
    }
    
    
    

    @IBAction func friendsHit(_ sender: Any) {
        let friendsVC = storyBoard.instantiateViewController(withIdentifier: "friendsVC") as! FriendsViewController
        self.present(friendsVC, animated:true, completion:nil)
    }
    
    
    @IBAction func eventsHit(_ sender: Any) {
        let eventsVC = storyBoard.instantiateViewController(withIdentifier: "eventsVC") as! EventsViewController
        self.present(eventsVC, animated:true, completion:nil)
    }
    
    @IBAction func postBtnHit(_ sender: Any) {
        let postVC = storyBoard.instantiateViewController(withIdentifier: "postVC") as! PostViewController
        self.present(postVC, animated:true, completion:nil)
    }
    
    func updatePosts() {
        let posts = fetchUserCoreData(user: currUid!, entity: "Post")
        data.removeAll()
        
        for post in posts {
            var temp = Dictionary<String, Any>()
            let postImageData = post.value(forKey: "content") as! Data
            let postImage = UIImage(data: postImageData)
            
            temp["date"] = post.value(forKey: "date")
            temp["bio"] = post.value(forKey: "bio")
            temp["hearts"] = post.value(forKey: "hearts")
            temp["content"] = postImage
            temp["profPic"] = self.profileImage.image
            temp["username"] = self.usernameLabel.text
            
            data.append(temp)
        }
    }
    
}
