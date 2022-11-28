//
//  ContentHandlers.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/25/22.
//

import Foundation
import UIKit


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


