//
//  FriendsViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/19/22.
//

import UIKit
import FirebaseAuth
import CoreData


class FriendsViewController: UIViewController {
    
    var currUID = Auth.auth().currentUser?.email

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var currUserData = fetchUserCoreData(user: currUID!, entity: "User")[0]
        print("userData: ")
        let userData = fetchUserCoreData(user: currUID!, entity: "User")
        print(userData)
        
        print("friends: \(currUserData.value(forKey: "friends"))")
        self.checkFriendRequests()
        
    }
    
    @IBAction func plusHit(_ sender: Any) {
        self.showOtherUsers()
    }
    
    func handleFriendRequest(othUser:String,act:String) {
        let currUserData = fetchUserCoreData(user: currUID!, entity: "User")[0]
        let othUserData = fetchUserCoreData(user: othUser, entity: "User")[0]
        
        let cf = currUserData.value(forKey: "friends") as! String
        let of = othUserData.value(forKey: "friends") as! String
        
        var othUserFriends = customSep(str: of)
        var currUserFriends = customSep(str: cf)
        
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
        
        print(currRes)
        print(othRes)
        
        var othResStr = ""
        var currResStr = ""
        
        //back to strs
        for (f1,f2) in zip(currRes,othRes){
            currResStr += f1
            othResStr += f2
        }
        
        othUserData.setValue(othResStr, forKey: "friends")
        currUserData.setValue(currResStr, forKey: "friends")
        
        appDelegate.saveContext()
        
    }
    
    func checkFriendRequests() {
        var currUserData = fetchUserCoreData(user: currUID!, entity: "User")[0]
        let cf = currUserData.value(forKey: "friends") as! String
        var currUserFriends = customSep(str: cf)
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
                let name = user.value(forKey: "name") as? String
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
        
        var othUserFriends = customSep(str: othFriends)
        var currUserFriends = customSep(str: currFriends)
        
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
    
    //removes nil string from seperating at ","
    func customSep (str:String) -> Array<String>{
        var res = str.components(separatedBy: ",")
        for (idx,el) in res.enumerated() {
            if el.count == 0 {
                res.remove(at: idx)
            }
        }
        return res
    }

}
