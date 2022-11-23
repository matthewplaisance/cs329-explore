//
//  FeedViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/22/22.
//

import UIKit
import FirebaseAuth

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var homeBtn: UIBarButtonItem!
    
    @IBOutlet weak var feedTable: UITableView!

    @IBOutlet weak var profBtn: UIBarButtonItem!
    
    var currUid = Auth.auth().currentUser?.email
    
    var dataTst : [String] = ["ZilkerPark","MountBonnell","asapRocky"]
    
    var data = [Dictionary<String, Any>]()
    
    var userPage:String = "all"
    
    var scrollTo: Int?//clicked post from collection view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTable.register(FeedTableViewCell.nib(), forCellReuseIdentifier: FeedTableViewCell.id)
        feedTable.delegate = self
        feedTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.homeBtn.image = UIImage(systemName: "house.fill")
        self.profBtn.image = UIImage(systemName: "person")
        
        self.contentToDisplay()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedTable.dequeueReusableCell(withIdentifier: FeedTableViewCell.id, for: indexPath) as! FeedTableViewCell
        let row = indexPath.row
        
        let currLikes = data[row]["hearts"] as! String
        //let date = NSDate(timeIntervalSince1970: cell.postKey )
        //let bio = data[row]["bio"] as! String
        
        cell.usernameLabel.text = (data[row]["username"] as! String)
        cell.postImageView.image = (data[row]["content"] as! UIImage)
        //cell.profilePhoto.image = (data[row]["profPic"] as! UIImage)
        cell.numLikes.text = currLikes
        cell.postKey = data[row]["date"] as! Double
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let scrollTo = scrollTo {
            let indexPath = NSIndexPath(row: scrollTo, section: 0)
            feedTable.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
            }
        scrollTo = nil//allows free scrolling once on feed
    }
    

    @IBAction func profileToolbarHit(_ sender: Any) {
        let pageVC = storyBoard.instantiateViewController(withIdentifier: "pageVC") as! PageViewController
        pageVC.isModalInPresentation = true
        pageVC.modalPresentationStyle = .fullScreen
        pageVC.userPage = currUid!
        print(type(of: currUid!))
        self.present(pageVC, animated: true,completion: nil)
    }
    
    func contentToDisplay() {
        if self.userPage != "all"{//clicked photo from user page view, data is already passed, dont re-fetch
            
        }else{
            let posts = fetchUserCoreData(user: self.userPage, entity: "Post")
            
            data.removeAll()
            for post in posts {
                var temp = Dictionary<String, Any>()
                let postImageData = post.value(forKey: "content") as! Data
                let postImage = UIImage(data: postImageData)
                
                temp["date"] = post.value(forKey: "date")
                temp["bio"] = post.value(forKey: "bio")
                temp["hearts"] = post.value(forKey: "hearts")
                temp["content"] = postImage
                temp["username"] = post.value(forKey: "uid")
                
                data.append(temp)
            }
        }
        
    }
}


