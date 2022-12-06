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
    
    @IBOutlet weak var pageBtn: UIBarButtonItem!
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
        if DarkMode.darkModeIsEnabled == true{
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
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
        self.pageBtn.image = UIImage(systemName: "person.fill")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.pageBtn.image = UIImage(systemName: "person")
    }
    
    @IBAction func friendBtnHit(_ sender: Any) {
        if self.areFriends == false {
            self.friendBtn.setTitle("Request Sent", for: .normal)
            sendFriendRequest(othUser: self.pageFor)//0 if youve alr sent a req
        }else{
            //alert to remove friend
        }
    }
    
    @IBAction func eventsBtnHit(_ sender: Any) {
        let eventsVC = storyBoard.instantiateViewController(withIdentifier: "eventsNavController") as! UINavigationController
        eventsVC.isModalInPresentation = true
        eventsVC.modalPresentationStyle = .fullScreen
        self.present(eventsVC, animated:true, completion:nil)
    }
    
    @IBAction func homeBtnHit(_ sender: Any) {
        let feedVC = storyBoard.instantiateViewController(withIdentifier: "feedVC") as! FeedViewController
        
        feedVC.isModalInPresentation = true
        feedVC.modalPresentationStyle = .fullScreen
        self.present(feedVC, animated:true, completion:nil)
    }
    
    
    @IBAction func feedBtnHit(_ sender: Any) {
        let feedVC = storyBoard.instantiateViewController(withIdentifier: "feedVC") as! FeedViewController
        
        feedVC.isModalInPresentation = true
        feedVC.modalPresentationStyle = .fullScreen
        self.present(feedVC, animated:true, completion:nil)
    }
    
    
    @IBAction func pageBtnHit(_ sender: Any) {
        let pageVC = storyBoard.instantiateViewController(withIdentifier: "pageVC") as! PageViewController
        
        pageVC.isModalInPresentation = true
        pageVC.modalPresentationStyle = .fullScreen
        self.present(pageVC, animated:true, completion:nil)
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
        feedVC.data = nsPostObjToDict(postCd: self.data)
        feedVC.userPage = self.pageFor
        feedVC.scrollTo = row
        self.present(feedVC, animated:true, completion:nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let layout = UICollectionViewFlowLayout()
        let containerWidth = collectionView.bounds.width
        let cellWidth = (containerWidth-18) / 3
        
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        
        collectionView.collectionViewLayout = layout
    }
    
    
}
