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
    
    var data = [Dictionary<String,Any>]()
    var otherUsers = [Dictionary<String,Any>]()
    var segEmail:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsTableView.register(FriendsTableViewCell.nib(), forCellReuseIdentifier: FriendsTableViewCell.id)
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.checkFriendRequests()
        self.data = currUserFriends
        friendsTableView.reloadData()
        if DarkMode.darkModeIsEnabled == true{
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? SearchUsersViewController, segue.identifier == "usersSearch"{
            dest.data = self.otherUsers
            dest.searchId = "users"
            dest.searchName = "Users:"
        }
        if let dest = segue.destination as? OthUserPageViewController, segue.identifier == "friendsPage"{
            dest.pageFor = self.segEmail
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
    
    
   
}

extension FriendsViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendsTableViewCell.id, for: indexPath) as! FriendsTableViewCell
        let row = indexPath.row
        
        cell.usernameLabel.text = data[row]["username"] as? String
        cell.friendProfImageView.image = data[row]["profilePhoto"] as? UIImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.segEmail = self.data[indexPath.row]["email"] as! String
        self.performSegue(withIdentifier: "friendsPage", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
