//
//  ContentHandlers.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/25/22.
//

import Foundation
import UIKit
import CoreData


//removes nil string from seperating 
func customSep (str:String,sepBy:String) -> Array<String>{
    var res = str.components(separatedBy: sepBy)
    for (idx,el) in res.enumerated() {
        if el.count == 0 || el == "nil" {
            res.remove(at: idx)
        }
    }
    return res
}

func customDataFormat(date:Date,long:Bool) -> String{
    let formatter = DateFormatter()
    if long == true {
        formatter.dateFormat = "E, d MMM h:mm a"
    }else{
        formatter.dateFormat = "MMM d"
    }
    
    return formatter.string(from: date)
}

func sendFriendRequest(othUser:String) {
    let currUserData = fetchUserCoreData(user: currUid, entity: "User")[0]
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
    
    othUserFriends.append("\(currUid)1,")
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

func userFriends() -> [Dictionary<String,Any>]{
    let friendsStr = currUsrData.value(forKey: "friends") as! String
    let friends = customSep(str: friendsStr,sepBy: ",")
    
    var data = [Dictionary<String,Any>]()
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
            
            data.append(temp)
        }
    }
    return data
}

func getOtherUser() -> [Dictionary<String,Any>]{
    let othUsers = fetchUserCoreData(user: "otherUsers", entity: "User")
    var res = [Dictionary<String,Any>]()
    for user in othUsers {
        var temp = Dictionary<String,Any>()
        
        let photoData = user.value(forKey: "profilePhoto") as! Data
        let photo = UIImage(data: photoData)
        temp["username"] = user.value(forKey: "username") as! String
        temp["email"] = user.value(forKey: "email") as! String
        temp["profilePhoto"] = photo
        res.append(temp)
    }
    return res
}

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

//no longer using, most likely
func contentToDisplay(userPage:String) {
    var res = [Dictionary<String,Any>]()
    
    if userPage != "all"{//clicked photo from user page view, data is already passed to var data, dont re-fetch
        //pass
    }else{
        let posts = fetchUserCoreData(user: userPage, entity: "Post")
        
    
        for post in posts {
            var temp = Dictionary<String, Any>()
            let postImageData = post.value(forKey: "content") as! Data
            let postImage = UIImage(data: postImageData)
            
            temp["date"] = post.value(forKey: "date")
            temp["bio"] = post.value(forKey: "bio")
            temp["hearts"] = post.value(forKey: "hearts")
            temp["content"] = postImage
            temp["username"] = post.value(forKey: "username")
            temp["email"] = post.value(forKey: "email")
            
            res.append(temp)
        }
    }
}


