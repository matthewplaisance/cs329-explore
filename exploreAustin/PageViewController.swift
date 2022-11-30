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
    //var currUid = Auth.auth().currentUser?.email
    var userPage: String = currUid//user email
    var data = [Dictionary<String, Any>]()
    var othProfPhoto:UIImage?
    
    @IBOutlet weak var homeBtn: UIBarButtonItem!
    @IBOutlet weak var profileBtn: UIBarButtonItem!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var postBtn: UIButton!
    private lazy var zzldfData: Array = {
        return [
            ["infokey": ["Over the years, people have come to this 1,000 foot long natural limestone pool, fed by several underground springs, for everything from fishing and swimming to baptisms and beauty pageants.","Beautiful park looming almost 800 feet over Austin.","Austin's original and iconic hotel features beautiful Romanesque architecture from the late 1800's. With a grand entrance into the opulent lobby, you will be transported to an historic era, with its marble floors, stained-glass dome, and corridors filled with museum-quality artwork. Head up the grand staircase to the most authentic Texas bar in downtown Austin, with daily live music and happy hour.","The Austin bridge is where nearly 1.5 million bats live.","The Lady Bird Johnson Wildflower Center in Austin, Texas, is dedicated to inspiring the conservation of native plants. Located a quick but quiet ten miles from downtown, we are a botanical garden open to the public year-round and have become a favored venue for everything from conservation-focused conventions to beautiful weddings. We carry out our mission to inspire the conservation and application of native plants through our gardens, campus, research, education and outreach programs. In doing so, we improve water quality, provide habitat for wildlife and enhance human health and happiness. Visit, learn and make a better world with us. The Wildflower Center was founded by Lady Bird Johnson and Helen Hayes in 1982 and became a part of The University of Texas at Austin in 2006","Street lined with lots of great restaurants.","The Lyndon Baines Johnson Library and Museum, also known as the LBJ Presidential Library, is the presidential library and museum of Lyndon Baines Johnson, the 36th President of the United States. It is one of fourteen presidential libraries administered by the National Archives and Records Administration (NARA) and located on the campus of The University of Texas at Austin. We are open daily (except for Thanksgiving, Christmas, and New Year's Day) from 9 a.m.-5 p.m., with the last admission at 4:00 p.m. Admission is $3-$13 per person, with free admission given to children 12 and under, active military, student groups, and UT Austin students, faculty, and staff with valid ID. Free parking is available in visitor lot #38. Learn more at lbjlibrary.org.","The Bullock Texas State History Museum is the state's official history museum and features three floors of exhibition galleries, IMAX® Theatre, Texas Spirit Theater, Story of Texas Cafe, and Bullock Museum Store.","If it's in Texas, it must be bigger and better. That is the motto that architects followed with the Capitol Building in Austin. At one time, it was the tallest capitol building in the nation. Others might be taller now, but this is still a beautiful building that shows off many of the natural resources which are so prevalent in Texas, such as limestone and the landscapes.","Scenic trail through lush green parks and peaceful lakes: a great place to bike, hike and run."],"timezone":"America/New_York  ","cityImg":["picture1","picture2","picture3","picture4","picture5","picture6","picture7","picture8","picture9","picture10"],"theme":["Photos of Barton Springs Pool","Photos of Mount Bonnell","Photos of The Driskill","Photos of Congress Avenue Bridge Bat Watching","Photos of Lady Bird Johnson Wildflower Center","Photos of South Congress Avenue","Photos of LBJ Presidential Library","Photos of Bullock Texas State History Museum","Photos of Texas State Capitol","Photos of Lady Bird Lake Hike-and-Bike Trail"]]
                ]
    }()
    lazy var clickBtnView:UIButton = {
        let buttonSelect = UIButton(type: .system)
        buttonSelect.setTitle("toScence", for: UIControl.State.normal)
//        buttonSelect.setImage(UIImage(named: "zl_filter"), for: UIControl.State.normal)
        buttonSelect.frame = CGRect(x:0, y:0, width: 30, height: 30)
        buttonSelect.addTarget(self, action: #selector(selectPicture), for: UIControl.Event.touchDown)
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: buttonSelect)
        return buttonSelect
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        pageCollectionView.delegate = self
        pageCollectionView.dataSource = self
        
//        self.view.addSubview(self.clickBtnView)
//        self.clickBtnView.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview().offset(70)
//            make.bottom.equalToSuperview().offset(0)
//            make.width.equalTo(200)
//            make.height.equalTo(50)
//        }
    }
    @objc func selectPicture(){
        let List = zzlList()
        self.navigationController?.pushViewController(List, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        print("displaying page for : \(userPage)")
        self.homeBtn.image = UIImage(systemName: "house")
        self.profileBtn.image = UIImage(systemName: "person.fill")
        
        if currentUserData.updataPosts == true {//user just posted photo
            
        }
        
        if userPage == currUid {
            print("grabbing data..")
            data = currUserPosts
            usernameLabel.text = currUsrData.value(forKey: "username") as? String
            
            let profPhoto = fetchUIImage(uid: currUid)
            print("image name \(profPhoto?.accessibilityIdentifier)")
            profileImage.image = profPhoto
            
        }else{//display different users page
            let othUserPosts = fetchPostCdAsArray(user: userPage).0
            self.usernameLabel.text = othUserPosts[0]["username"] as? String
            self.profileImage.image = othProfPhoto
            data = othUserPosts
        }
        
        //self.contentToDisplay()
        //self.profileImage.image!.setRounded()
        pageCollectionView.reloadData()
    }
    @IBAction func choosePic(_ sender: Any) {
        let zzlmiansu = zzlMIaoshuVC()
//        self.navigationController?.pushViewController(List, animated: true)
        let dicsdffgt: [String: Any] = zzldfData[0]
        zzlmiansu.infozklgdic = dicsdffgt
        zzlmiansu.cityImgData = (dicsdffgt["cityImg"] as! [String])
        zzlmiansu.dscTxtData = (dicsdffgt["infokey"] as! [String])
        zzlmiansu.themeTxtData = (dicsdffgt["theme"] as! [String])

        self.present(zzlmiansu, animated:true, completion:nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.userPage = currUid
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

    @IBAction func friendsHit(_ sender: Any) {
        let friendsVC = storyBoard.instantiateViewController(withIdentifier: "friendsVC") as! FriendsViewController
        self.present(friendsVC, animated:true, completion:nil)
    }
    
    @IBAction func eventsHit(_ sender: Any) {
        let eventsVC = storyBoard.instantiateViewController(withIdentifier: "eventsVC") as! EventsViewController
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
    
    @IBAction func homeToolBarHit(_ sender: Any) {
        performSegue(withIdentifier: "feedSeg", sender: self)
    }
    
    @IBAction func settingBtnHit(_ sender: Any) {
        if self.userPage == currUid{
            performSegue(withIdentifier: "settingsSeg", sender: self)
        }
        
    }
    
    
    func contentToDisplay() {
        if self.userPage == currUid{
            self.updatePage(user: currUid)
            settingsBtn.alpha = 1
            postBtn.alpha = 1
        }else{
            self.updatePage(user: self.userPage)
            settingsBtn.alpha = 0
            postBtn.alpha = 0
        }
    }
}
