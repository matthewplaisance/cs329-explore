//
//  FriendsViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/19/22.
//

import UIKit
import FirebaseAuth
import CoreData

//will change how requests show up, sholuldnt be an alert 
class FriendsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    var currUID = Auth.auth().currentUser?.email
    
    var friendsData = [Dictionary<String,Any>]()

    override func viewDidLoad() {
        super.viewDidLoad()
        friendsTableView.register(FriendsTableViewCell.nib(), forCellReuseIdentifier: FriendsTableViewCell.id)
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.checkFriendRequests()
        self.displayFriends()
        friendsTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendsTableViewCell.id, for: indexPath) as! FriendsTableViewCell
        let row = indexPath.row
        
        cell.usernameLabel.text = friendsData[row]["username"] as? String
        cell.friendProfImageView.image = friendsData[row]["profilePhoto"] as? UIImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        let pageVC = storyboard?.instantiateViewController(withIdentifier: "pageVC") as! PageViewController
        let userEmail = friendsData[row]["email"] as! String//clicked email key
        pageVC.userPage = userEmail
        pageVC.othProfPhoto = friendsData[row]["profilePhoto"] as? UIImage
        //pageVC.usernameLabel.text = userEmail
        //pageVC.profileImage.image = friendsData[row]["content"] as? UIImage
        self.present(pageVC, animated: true)
    }
    
    @IBAction func plusHit(_ sender: Any) {
        self.showOtherUsers()
    }
    
    func handleFriendRequest(othUser:String,act:String) {
        let currUserData = fetchUserCoreData(user: currUID!, entity: "User")[0]
        let othUserData = fetchUserCoreData(user: othUser, entity: "User")[0]
        
        let cf = currUserData.value(forKey: "friends") as! String
        let of = othUserData.value(forKey: "friends") as! String
        
        let othUserFriends = customSep(str: of,sepBy: ",")
        let currUserFriends = customSep(str: cf,sepBy: ",")
        
        var currRes = [String]()
        var othRes = [String]()
        
        for (i,j) in zip(currUserFriends,othUserFriends){
            var ii = i //i and j are immutatble
            ii.remove(at: ii.index(before: ii.endIndex))
            
            if ii == othUser {
                if act == "a"{
                    currRes.append("\(othUser)3,")
                    othRes.append("\(currUID!)3,")
                    continue
                }
                if act == "d"{
                    continue
                }
            }else{
                currRes.append(i)
                othRes.append(j)
            }
        }
        
        if currRes.count == 0 {
            currRes.append(" ")
        }
        if othRes.count == 0 {
            othRes.append(" ")
        }
        
        //print(currRes)
        //print(othRes)
        
        var othResStr = ""
        var currResStr = ""
        
        //back to strs for cd
        for (f1,f2) in zip(currRes,othRes){
            currResStr += f1
            othResStr += f2
        }
        
        othUserData.setValue(othResStr, forKey: "friends")
        currUserData.setValue(currResStr, forKey: "friends")
        
        appDelegate.saveContext()
        
    }
    
    func displayFriends() {
        let friendsStr = currUsrData.value(forKey: "friends") as! String
        let friends = customSep(str: friendsStr,sepBy: ",")
        
        friends.forEach {(f) in
            if f.last! == "3"{
                var user = f
                var temp = Dictionary<String, Any>()
                user.remove(at: user.index(before: user.endIndex))
                
                let friendData = fetchUserCoreData(user: user, entity: "User")[0]
                let username = friendData.value(forKey: "username")
                let email = friendData.value(forKey: "email")
                let profPhotoData = friendData.value(forKey: "profilePhoto") as! Data
                let profPhoto = UIImage(data: profPhotoData)
                
                temp["email"] = email
                temp["username"] = username
                temp["profilePhoto"] = profPhoto
                
                self.friendsData.append(temp)
            }
        }
    }
    
    func checkFriendRequests() {
        var currUserData = fetchUserCoreData(user: currUID!, entity: "User")[0]
        let cf = currUserData.value(forKey: "friends") as! String
        var currUserFriends = customSep(str: cf,sepBy: ",")
        var requestingUsers = [String]()
        for f in currUserFriends{
            if f.last! == "1"{
                var user = f
                user.remove(at: user.index(before: user.endIndex))
                requestingUsers.append(user)
            }
        }
        print("reqs: \(requestingUsers)")
        if requestingUsers.count != 0 {
            
            for i in requestingUsers {
                let controller = UIAlertController(title: "Friend request from:", message: "\(i)", preferredStyle: .alert)
                
                let acceptAct = UIAlertAction(
                    title: "Accept",
                    style: .default,
                    handler: {
                        (action) in
                        self.handleFriendRequest(othUser: i, act: "a")
                    }
                )
                let declineAct = UIAlertAction(
                    title: "Decline",
                    style: .cancel,
                    handler: {
                        (action) in
                        self.handleFriendRequest(othUser: i, act: "")
                    }
                )
                controller.addAction(acceptAct)
                controller.addAction(declineAct)
                present(controller, animated: true)
            }
            
        }
        
    }


    func showOtherUsers() {
        let userEntity = fetchUserCoreData(user: "all", entity: "User")
        
        var users = [String]()
        for user in userEntity {
            let email = user.value(forKey: "email") as? String
            if (currUID != email){
                let username = user.value(forKey: "username") as? String
                users.append(email!)
            }
        }
        
        let controller = UIAlertController(title: "Users:", message: "Click to send friend request:", preferredStyle: .actionSheet)
        for i in users {
            let friendAction = UIAlertAction(
                title: i,
                style: .default,
                handler: {
                    (action) in
                    self.sendFriendRequest(othUser: i)
                }
            )
            controller.addAction(friendAction)
        }
        present(controller,animated: true)
    }


    func sendFriendRequest(othUser:String) {
        let currUserData = fetchUserCoreData(user: currUID!, entity: "User")[0]
        let othUserData = fetchUserCoreData(user: othUser, entity: "User")[0]
        
        let othFriends = othUserData.value(forKey: "friends") as! String
        let currFriends = currUserData.value(forKey: "friends") as! String
        
        var othUserFriends = customSep(str: othFriends,sepBy: ",")
        var currUserFriends = customSep(str: currFriends,sepBy: ",")
        
        if othUserFriends[0] == " " {
            othUserFriends.removeFirst()
        }
        if currUserFriends[0] == " " {
            currUserFriends.removeFirst()
        }
        
        othUserFriends.append("\(currUID!)1,")
        currUserFriends.append("\(othUser)2,")
        
        var othRes = ""
        var currRes = ""
        
        //back to strs
        for (f1,f2) in zip(currUserFriends,othUserFriends){
            currRes += f1
            othRes += f2
        }
        
        othUserData.setValue(othRes, forKey: "friends")
        currUserData.setValue(currRes, forKey: "friends")
        
        appDelegate.saveContext()
    }
}
