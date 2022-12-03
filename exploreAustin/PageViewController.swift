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
    
    @IBOutlet weak var notificationsBtn: UIButton!
    var data1 : [String] = ["ZilkerPark","MountBonnell"]
    //var currUid = Auth.auth().currentUser?.email
    var userPage: String = currUid!//user email
    var data = [Dictionary<String, Any>]()
    var othProfPhoto:UIImage?
    
    @IBOutlet weak var profileBtn: UIBarButtonItem!
    @IBOutlet weak var homeBtn: UIBarButtonItem!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var postBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageCollectionView.delegate = self
        self.pageCollectionView.dataSource = self
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if DarkMode.darkModeIsEnabled == true{
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
        print("displaying page for : \(userPage)")
        self.homeBtn.image = UIImage(systemName: "house")
        self.profileBtn.image = UIImage(systemName: "person.fill")
        
        self.data = currUserPosts
        usernameLabel.text = currUsrData.value(forKey: "username") as? String
        
        let profPhoto = fetchUIImage(uid: currUid!)
        profileImage.image = profPhoto
            
        pageCollectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.userPage = currUid!
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
        //let cell = collectionView.cellForItem(at: indexPath)
        let row = indexPath.row
        print("row: \(row)")
        //let postKey = data[row]["date"]
        
        let feedVC = storyBoard.instantiateViewController(withIdentifier: "feedVC") as! FeedViewController
        
        feedVC.data = self.data
        feedVC.userPage = self.userPage//implent later
        feedVC.scrollTo = row
        self.present(feedVC, animated:true, completion:nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let layout = UICollectionViewFlowLayout()
        let containerWidth = pageCollectionView.bounds.width
        let cellWidth = (containerWidth-18) / 3
        
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        
        pageCollectionView.collectionViewLayout = layout
    }

    @IBAction func friendsHit(_ sender: Any) {
        let friendsVC = storyBoard.instantiateViewController(withIdentifier: "friendsVC") as! FriendsViewController
        self.present(friendsVC, animated:true, completion:nil)
    }
    
    @IBAction func eventsHit(_ sender: Any) {
        print("event hit")
        let eventsVC = storyBoard.instantiateViewController(withIdentifier: "eventsNavController") as! UINavigationController
        eventsVC.isModalInPresentation = true
        eventsVC.modalPresentationStyle = .fullScreen
        self.present(eventsVC, animated:true, completion:nil)
    }
    
    @IBAction func postBtnHit(_ sender: Any) {
        if self.userPage == currUid {
            let postVC = storyBoard.instantiateViewController(withIdentifier: "postVC") as! PostViewController
            postVC.username = self.usernameLabel.text!
            postVC.profilePhoto = self.profileImage.image
            self.present(postVC, animated:true, completion:nil)
        }
    }
    
    @IBAction func notificationBtnHit(_ sender: Any) {
        let notVC = storyBoard.instantiateViewController(withIdentifier: "notificationsVC") as! NotificationsViewController
        
        self.present(notVC, animated:true, completion:nil)
    }
    
    func updatePage(user:String) {
        print("updating..")
        let posts = fetchUserCoreData(user: user, entity: "Post")
        let userData = fetchUserCoreData(user: user, entity: "User")[0]
        
        print("postrequest: \(posts)")
        let profPhotoData = userData.value(forKey: "profilePhoto") as! Data
        let profPhoto = UIImage(data: profPhotoData)
        profileImage.image = profPhoto
        usernameLabel.text = userData.value(forKey: "username") as? String
        
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
            print("temp: \(temp)")
            data.append(temp)
        }
        print("post data: \(data)")
    }
    
    
    @IBAction func eventBtnHit(_ sender: Any) {
        let eventsVC = storyBoard.instantiateViewController(withIdentifier: "eventsNavController") as! UINavigationController
        eventsVC.isModalInPresentation = true
        eventsVC.modalPresentationStyle = .fullScreen
        self.present(eventsVC, animated:true, completion:nil)
    }
    
    
    @IBAction func homeToolBarHit(_ sender: Any) {
        performSegue(withIdentifier: "homeSeg", sender: self)
    }
    
    @IBAction func settingBtnHit(_ sender: Any) {
        if self.userPage == currUid{
            performSegue(withIdentifier: "settingsSeg", sender: self)
        }
        
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer)
    {
        if sender.direction == .left
        {
            
        }

        if sender.direction == .right
        {
            //
        }
    }
}
