//
//  FeedViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/22/22.
//

import UIKit
import FirebaseAuth
import CoreData

var currUserUid = Auth.auth().currentUser?.email

//var currUserData = fetchUserCoreData(user: currUserUid!, entity: "User")[0]
//var currUserPosts = fetchUserCoreData(user: currUserUid!, entity: "Post")
//var displayForCurrUser = true

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,FeedCellDelegator {
    
    @IBOutlet weak var homeBtn: UIBarButtonItem!
    @IBOutlet weak var feedTable: UITableView!
    @IBOutlet weak var profBtn: UIBarButtonItem!
    
    var currUid = Auth.auth().currentUser?.email
    
    var dataTst : [String] = ["ZilkerPark","MountBonnell","asapRocky"]
    
    var data = [Dictionary<String, Any>]()
    //var data = [NSManagedObject]()
    
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
        
        //let currUID = Auth.auth().currentUser?.email
        print("curr usr loading: \(currUid)")
        let postData = fetchPostCdAsArray(user: currUid!)
        currPosts = postData.1
        currUserPosts = postData.0
        currUsrData = fetchUserCoreData(user: currUid!, entity: "User")[0]
        //currUid = currUID!
        //self.contentToDisplay()
        
        if  userPage == "all" {
            print("posts:")
            data = currPosts
        }else if userPage == currUid {//clicked post from own page
            data = currUserPosts
        }else{//clicked post from another user's page
            
        }
        //sort posts by recent
        data.sort{
            ((($0 as Dictionary<String, AnyObject>)["date"] as? Double)!) > ((($1 as Dictionary<String, AnyObject>)["date"] as? Double)!)
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedTable.dequeueReusableCell(withIdentifier: FeedTableViewCell.id, for: indexPath) as! FeedTableViewCell
        let row = indexPath.row
        
        cell.delegate = self//delegate from feedCell protocol
        cell.postKey = data[row]["date"] as? Double
        
        let currLikes = data[row]["hearts"] as! String
        let date = customDataFormat(date: Date(timeIntervalSince1970: cell.postKey),long: false)
        print("type; \(type(of: data[row]["date"]))")
        cell.postDate.text = date
        cell.profilePhoto.image = (data[row]["profilePhoto"] as! UIImage)
        cell.bio = data[row]["bio"] as? String
        cell.comments = data[row]["comments"] as? String
        cell.usernameBtn.setTitle(data[row]["username"] as? String, for: .normal)
        cell.postImageView.image = (data[row]["content"] as! UIImage)
        cell.userEmail = data[row]["email"] as! String
        cell.numLikes.text = currLikes
    
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 677
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let scrollTo = scrollTo {
            let indexPath = NSIndexPath(row: scrollTo, section: 0)
            feedTable.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
            }
        scrollTo = nil//allows free scrolling once on feed
    }
    
    func segTocomments(postedUser: String, postImage: UIImage, bio: String, comments: String, postKey:Double) {
        let commVC = storyboard?.instantiateViewController(withIdentifier: "commentsVC") as! CommentsViewController
        commVC.commentsStr = comments
        commVC.bio = bio
        commVC.postedImage = postImage
        commVC.postedUser = postedUser
        commVC.postKey = postKey
        self.present(commVC, animated: true)
    }

    @IBAction func profBtnHit(_ sender: Any) {
        let pageVC = storyBoard.instantiateViewController(withIdentifier: "pageVC") as! PageViewController
        pageVC.isModalInPresentation = true
        pageVC.modalPresentationStyle = .fullScreen
        pageVC.userPage = currUid!
        self.present(pageVC, animated: false,completion: nil)
    }
    
}







