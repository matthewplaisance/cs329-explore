//
//  FeedViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/22/22.
//

import UIKit
import FirebaseAuth
import CoreData
import AVFoundation

var currUserUid = Auth.auth().currentUser?.email

var currUid = Auth.auth().currentUser?.email!
//current user data, used across app until user posts/updates their data
var currPosts = [Dictionary<String, Any>]()
var currUserPosts = [Dictionary<String, Any>]()
var currUsrData = NSManagedObject()
var currUserFriends = [Dictionary<String, Any>]()
var otherUsers = [Dictionary<String, Any>]()
var userEvents = [NSManagedObject]()

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,FeedCellDelegator {
    
    @IBOutlet weak var statusLabel: UILabel!
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
        self.feedTable.register(FeedTableViewCell.nib(), forCellReuseIdentifier: FeedTableViewCell.id)
        self.feedTable.delegate = self
        self.feedTable.dataSource = self
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        self.feedTable.addGestureRecognizer(leftSwipe)
        self.feedTable.addGestureRecognizer(rightSwipe)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let darkMode = currUsrData.value(forKey: "darkMode"){
                    DarkMode.darkModeIsEnabled = darkMode as! Bool
        }
        if let soundOn = currUsrData.value(forKey: "soundOn"){
                    SoundOn.soundOn = soundOn as! Bool
        }
        if DarkMode.darkModeIsEnabled == true{
            overrideUserInterfaceStyle = .dark
        }else{
            self.view.backgroundColor = .systemGray3
        }
        if SoundOn.soundOn == true && SoundOn.isPlaying == false{
            playSound()
        }
        self.homeBtn.image = UIImage(systemName: "house.fill")
        self.profBtn.image = UIImage(systemName: "person")
        
        if  userPage == "all" {
            print("posts:")
            self.data = currPosts
            if self.data.isEmpty {
                statusLabel.alpha = 1
            }
            else{
                statusLabel.alpha = 0
            }
            for post in self.data{
                print("user:")
                print(post["email"])
            }
        }else if userPage == currUid {//clicked post from own page
            self.data = currUserPosts
        }else{//clicked post from another user's page
            
        }
        //sort posts by recent
        self.data.sort{
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
    
        cell.postDate.text = " \(date)"
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
    
    func segToPage(postedUser: String) {
        if postedUser == currUid{
            let userPage = storyboard?.instantiateViewController(withIdentifier: "pageVC") as! PageViewController
            self.present(userPage, animated: true)
            
        }else{
            let userPage = storyboard?.instantiateViewController(withIdentifier: "othUserPage") as! OthUserPageViewController
            userPage.pageFor = postedUser
            self.present(userPage, animated: true)
        }
        
    }

    @IBAction func profBtnHit(_ sender: Any) {
        let pageVC = storyBoard.instantiateViewController(withIdentifier: "pageVC") as! PageViewController
        pageVC.isModalInPresentation = true
        pageVC.modalPresentationStyle = .fullScreen
        pageVC.userPage = currUid!
        self.present(pageVC, animated: false,completion: nil)
    }
    
    @IBAction func eventsBtnHit(_ sender: Any) {
        let eventsVC = storyBoard.instantiateViewController(withIdentifier: "eventsNavController") as! UINavigationController
        eventsVC.isModalInPresentation = true
        eventsVC.modalPresentationStyle = .fullScreen
        self.present(eventsVC, animated:true, completion:nil)
    }
    
    @IBAction func searchBtnHit(_ sender: Any) {
        self.performSegue(withIdentifier: "searchVcSeg", sender: self)
        
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer)
    {
        if sender.direction == .left
        {
           //
        }

        if sender.direction == .right
        {
           print("RIGHT")
        }
    }
    
    func playSound() {
        if let asset = NSDataAsset(name:"TexasFightSong"){
           do {
               // Use NSDataAsset's data property to access the audio file stored in Sound.
               player = try AVAudioPlayer(data:asset.data, fileTypeHint:"caf")
               // Play the above sound file.
               player?.volume = 1
               player?.numberOfLoops = -1
               player?.play()
           } catch let error as NSError {
               print(error.localizedDescription)
           }
        }
    }
}







