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
   
    private lazy var zzldfData: Array = {
        return [
            ["infokey": ["Over the years, people have come to this 1,000 foot long natural limestone pool, fed by several underground springs, for everything from fishing and swimming to baptisms and beauty pageants.","Beautiful park looming almost 800 feet over Austin.","Austin's original and iconic hotel features beautiful Romanesque architecture from the late 1800's. With a grand entrance into the opulent lobby, you will be transported to an historic era, with its marble floors, stained-glass dome, and corridors filled with museum-quality artwork. Head up the grand staircase to the most authentic Texas bar in downtown Austin, with daily live music and happy hour.","The Austin bridge is where nearly 1.5 million bats live.","The Lady Bird Johnson Wildflower Center in Austin, Texas, is dedicated to inspiring the conservation of native plants. Located a quick but quiet ten miles from downtown, we are a botanical garden open to the public year-round and have become a favored venue for everything from conservation-focused conventions to beautiful weddings. We carry out our mission to inspire the conservation and application of native plants through our gardens, campus, research, education and outreach programs. In doing so, we improve water quality, provide habitat for wildlife and enhance human health and happiness. Visit, learn and make a better world with us. The Wildflower Center was founded by Lady Bird Johnson and Helen Hayes in 1982 and became a part of The University of Texas at Austin in 2006","Street lined with lots of great restaurants.","The Lyndon Baines Johnson Library and Museum, also known as the LBJ Presidential Library, is the presidential library and museum of Lyndon Baines Johnson, the 36th President of the United States. It is one of fourteen presidential libraries administered by the National Archives and Records Administration (NARA) and located on the campus of The University of Texas at Austin. We are open daily (except for Thanksgiving, Christmas, and New Year's Day) from 9 a.m.-5 p.m., with the last admission at 4:00 p.m. Admission is $3-$13 per person, with free admission given to children 12 and under, active military, student groups, and UT Austin students, faculty, and staff with valid ID. Free parking is available in visitor lot #38. Learn more at lbjlibrary.org.","The Bullock Texas State History Museum is the state's official history museum and features three floors of exhibition galleries, IMAX® Theatre, Texas Spirit Theater, Story of Texas Cafe, and Bullock Museum Store.","If it's in Texas, it must be bigger and better. That is the motto that architects followed with the Capitol Building in Austin. At one time, it was the tallest capitol building in the nation. Others might be taller now, but this is still a beautiful building that shows off many of the natural resources which are so prevalent in Texas, such as limestone and the landscapes.","Scenic trail through lush green parks and peaceful lakes: a great place to bike, hike and run."],"timezone":"America/New_York  ","cityImg":["picture1","picture2","picture3","picture4","picture5","picture6","picture7","picture8","picture9","picture10"],"theme":["Photos of Barton Springs Pool","Photos of Mount Bonnell","Photos of The Driskill","Photos of Congress Avenue Bridge Bat Watching","Photos of Lady Bird Johnson Wildflower Center","Photos of South Congress Avenue","Photos of LBJ Presidential Library","Photos of Bullock Texas State History Museum","Photos of Texas State Capitol","Photos of Lady Bird Lake Hike-and-Bike Trail"]]
                ]
    }()

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
        if SoundOn.soundOn == true && SoundPlaying.isPlaying == false{
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
    
    @IBAction func topictureScence(_ sender: Any) {
        let picscenceVC = picscenceVC()
//        self.navigationController?.pushViewController(List, animated: true)
        let dicsdffgt: [String: Any] = zzldfData[0]
        picscenceVC.infozklgdic = dicsdffgt
        picscenceVC.cityImgData = (dicsdffgt["cityImg"] as! [String])
        picscenceVC.dscTxtData = (dicsdffgt["infokey"] as! [String])
        picscenceVC.themeTxtData = (dicsdffgt["theme"] as! [String])

        self.present(picscenceVC, animated:true, completion:nil)
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







