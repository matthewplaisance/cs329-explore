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
class FriendsViewController: UIViewController {
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    var currUID = Auth.auth().currentUser?.email
    
    var friendsData = [Dictionary<String,Any>]()
    var otherUsers = [Dictionary<String,Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsTableView.register(FriendsTableViewCell.nib(), forCellReuseIdentifier: FriendsTableViewCell.id)
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.checkFriendRequests()
        self.friendsData = userFriends()
        friendsTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? SearchUsersViewController, segue.identifier == "usersSearch"{
            dest.data = self.otherUsers
            dest.searchId = "users"
            dest.searchName = "Users:"
        }
    }
    
    @IBAction func plusHit(_ sender: Any) {
        let othUsers = fetchUserCoreData(user: "otherUsers", entity: "User")
        
        for user in othUsers {
            var temp = Dictionary<String,Any>()
            
            let photoData = user.value(forKey: "profilePhoto") as! Data
            let photo = UIImage(data: photoData)
            temp["username"] = user.value(forKey: "username") as! String
            temp["email"] = user.value(forKey: "email") as! String
            temp["profilePhoto"] = photo
            self.otherUsers.append(temp)
        }
        self.performSegue(withIdentifier: "usersSearch", sender: self)
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
}

extension FriendsViewController:UITableViewDelegate,UITableViewDataSource {
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
}
