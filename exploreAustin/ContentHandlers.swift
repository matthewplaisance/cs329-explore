//
//  ContentHandlers.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/25/22.
//

import Foundation
import UIKit
import CoreData
import SwiftUI






func mainFetchUserData() {
    print("CURRENT USER :: \(currUid!)")
    let postData = fetchPostCdAsArray(user: currUid!)
    currPosts = postData.1
    currUserPosts = postData.0
    currUsrData = fetchUserCoreData(user: currUid!, entity: "User")[0]
    currUserFriends = userFriends(key: "friends")
    otherUsers = getOtherUser()
    userEvents = fetchUserCoreData(user: currUid!, entity: "Event")
    print("user events: \(userEvents)")
}

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

func sendFriendRequest(othUser:String) -> Int {
    print("current user: \(currUid!)")
    print("oth user: \(othUser)")
    let othUserData = fetchUserCoreData(user: othUser, entity: "User")[0]
    let othUserReqsStr = othUserData.value(forKey: "recievedReqsF") as! Substring
    
    var othUserReqs = othUserReqsStr.split(separator: "//")
    
    print("otUser curr reqs arr \(othUserReqs)")
    if othUserReqs.contains("\(currUid!)"){
        print("???")
        return 0
    }
    
    othUserReqs.append("\(currUid!)")
    print("otUser after reqs arr \(othUserReqs)")
    let res = othUserReqs.joined(separator: "//")
    print("res sent: \(res)")
    othUserData.setValue(res, forKey: "recievedReqsF")
    
    appDelegate.saveContext()
    return 1
}

//friend handlers
func userFriends(key:String) -> [Dictionary<String,Any>]{
    //key either friends to get users friends or recievedReqsF for requests
    
    let friendsStr = currUsrData.value(forKey: key) as! Substring
    let friends = friendsStr.split(separator: "//")
    
    var data = [Dictionary<String,Any>]()
    friends.forEach {(user) in
            var temp = Dictionary<String, Any>()
            
            let friendData = fetchUserCoreData(user: String(user), entity: "User")[0]
            let username = friendData.value(forKey: "username")
            let email = friendData.value(forKey: "email")
            let profPhotoData = friendData.value(forKey: "profilePhoto") as! Data
            let profPhoto = UIImage(data: profPhotoData)
            
            temp["email"] = email
            temp["username"] = username
            temp["profilePhoto"] = profPhoto
            
            data.append(temp)
    }
    return data
}

func acceptFriendReq(othUser:String){
    let othUserData = fetchUserCoreData(user: othUser, entity: "User")[0]
    
    let of = othUserData.value(forKey: "friends") as! Substring
    let cf = currUsrData.value(forKey: "friends") as! Substring
    let cReqs = currUsrData.value(forKey: "recievedReqsF") as! Substring
    
    var othFriends = of.split(separator: "//")
    var currFriends = cf.split(separator: "//")
    var currReqs = cReqs.split(separator: "//")
    
    othFriends.append("\(currUid!)")
    currFriends.append("\(othUser)")
    
    currReqs.removeAll { user in
        user == othUser
    }
    
    let resOF = othFriends.joined(separator: "//")
    let resCF = currFriends.joined(separator: "//")
    let resCR = currReqs.joined(separator: "//")
    
    othUserData.setValue(resOF, forKey: "friends")
    currUsrData.setValue(resCF, forKey: "friends")
    currUsrData.setValue(resCR, forKey: "recievedReqsF")
    appDelegate.saveContext()
}

func rejectFriendReq(othUser:String){
    let cReqs = currUsrData.value(forKey: "recievedReqsF") as! String
    var currReqs = cReqs.split(separator: "//") as! [String]
    
    currReqs.removeAll { user in
        user == othUser
    }
    let resCR = currReqs.joined(separator: "//")
    
    currUsrData.setValue("recievedReqsF", forKey: resCR)
    appDelegate.saveContext()
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

extension UIImageView {

    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2) //instead of let radius = CGRectGetWidth(self.frame) / 2
        self.layer.masksToBounds = true
    }
}

extension UIFont {
    class func menloCustom() -> UIFont {
        return UIFont(name: "Menlo-Regular", size: 13)!
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


func handleFriendRequest(othUser:String,act:String) {
    let currUserData = fetchUserCoreData(user: currUid!, entity: "User")[0]
    let othUserData = fetchUserCoreData(user: othUser, entity: "User")[0]
    
    let cf = currUserData.value(forKey: "friends") as! String
    let of = othUserData.value(forKey: "friends") as! String
    
    let othUserFriends = customSep(str: of,sepBy: "//")
    let currUserFriends = customSep(str: cf,sepBy: "//")
    
    var currRes = [String]()
    var othRes = [String]()
    
    for (i,j) in zip(currUserFriends,othUserFriends){
        var ii = i //i and j are immutatble
        ii.remove(at: ii.index(before: ii.endIndex))
        
        if ii == othUser {
            if act == "a"{
                currRes.append("\(othUser)3//")
                othRes.append("\(currUid)3//")
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


