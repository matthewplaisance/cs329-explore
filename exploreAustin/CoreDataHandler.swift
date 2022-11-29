//
//  CoreDataHandler.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/19/22.
//
import Foundation
import CoreData
import UIKit


func saveUIImage(image:UIImage,uid:String) {
    let imageData = image.jpegData(compressionQuality: 1)!
    
    //let entityName =  NSEntityDescription.entity(forEntityName: "User", in: context)!
    //let content = NSManagedObject(entity: entityName, insertInto: context)
    let userData = fetchUserCoreData(user: uid, entity: "User")[0]
    userData.setValue(imageData, forKey: "profilePhoto")
    
    do {
      try context.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
}

func fetchUIImage(uid:String) -> UIImage? {
    let request = NSFetchRequest<NSManagedObject>(entityName: "User")
    request.predicate = NSPredicate(format: "email CONTAINS %@",uid)
    
    var storedImageData = [Data]()
    
    do {
      let res = try context.fetch(request)
        for data in res {
        storedImageData.append(data.value(forKey: "profilePhoto") as! Data)
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    
    var resImage: UIImage?
    
    if let image = UIImage(data: storedImageData[0]) {
        resImage = image
    }else{
        print("no profilephoto")
    }
    return resImage
}

func fetchUserPosts(uid:String) -> [UIImage] {
    let request = NSFetchRequest<NSManagedObject>(entityName: "Post")
    request.predicate = NSPredicate(format: "email CONTAINS %@",uid)
    
    var fetchedImages = [Data]()
    var fetchedImagesData = [Data]()
    
    do {
      let result = try context.fetch(request)
        for data in result {
            fetchedImages.append(data.value(forKey: "content") as! Data)
      }
    } catch let error as NSError {
      print("\(error), \(error.userInfo)")
    }

    
    fetchedImages.forEach { (imageData) in
        var dataArray = [Data]()
        do {
            dataArray = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: imageData) as! [Data]
            fetchedImagesData.append(contentsOf: dataArray)
        } catch {
            print("Error: \(error)")
        }
    }
    
    var fetchedUIImages = convertDataToImages(imageDataArray: fetchedImagesData)
    
    return fetchedUIImages
}

func convertImagesToData(myImagesArray: [UIImage]) -> [Data]{
  var myImagesDataArray = [Data]()
  myImagesArray.forEach({ (image) in
      myImagesDataArray.append(image.jpegData(compressionQuality: 1)!)
  })
  return myImagesDataArray
}

func saveUIImages(imagesData:[Data]) {
    let entityName =  NSEntityDescription.entity(forEntityName: "Photo", in: context)!
    let image = NSManagedObject(entity: entityName, insertInto: context)

    var images: Data?
    do {
        images = try NSKeyedArchiver.archivedData(withRootObject: imagesData, requiringSecureCoding: true)
    } catch {
        print("error")
    }
    image.setValue(images, forKeyPath: "content")

    appDelegate.saveContext()
}

func fetchUIimages() -> Array<Data>{
    var imageDataArray = [Data]()
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Photo")
    do {
      let result = try context.fetch(fetchRequest)
        for data in result {
         imageDataArray.append(data.value(forKey: "content") as! Data)
      }
    } catch let error as NSError {
      print("\(error), \(error.userInfo)")
    }
    
    var myImagesdataArray = [Data]()
    //get binaryData of images
    imageDataArray.forEach { (imageData) in
        var dataArray = [Data]()
        do {
            dataArray = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: imageData) as! [Data]
            myImagesdataArray.append(contentsOf: dataArray)
        } catch {
            print("Error: \(error)")
        }
    }
    return myImagesdataArray
}

func convertDataToImages(imageDataArray: [Data]) -> [UIImage] {
  var myImagesArray = [UIImage]()
  imageDataArray.forEach { (imageData) in
      myImagesArray.append(UIImage(data: imageData)!)
  }
  return myImagesArray
}

func fetchUserCoreData(user:String,entity:String) -> [NSManagedObject]{
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
    
    if user == "all"{
        
    }else if user == "otherUsers"{
        request.predicate = NSPredicate(format: "email != %@",currUid)
    }else{//passed specif user id
        request.predicate = NSPredicate(format: "email CONTAINS %@",user)
    }
    
    
    var fetchedResults:[NSManagedObject]? = nil
    
    do{
        try fetchedResults = context.fetch(request) as? [NSManagedObject]
    } catch {
        let nserror = error as NSError
        print("errorhere:")
        print(nserror)
    }
    return fetchedResults!//if filtered for specifc user, call res with [0]
}

func createPost(image:UIImage,profImage:UIImage,bio:String,username:String,email:String) {
    let postEntity = NSEntityDescription.insertNewObject(forEntityName: "Post", into: context)
    let date = Date().timeIntervalSince1970//unix time
    let imageData = image.jpegData(compressionQuality: 1)!
    let profImageData = profImage.jpegData(compressionQuality: 1)!
    
    postEntity.setValue(email, forKey: "email")//used as key
    postEntity.setValue(username, forKey: "username")
    postEntity.setValue(imageData, forKey: "content")
    postEntity.setValue(profImageData, forKey: "profilePhoto")
    postEntity.setValue(bio, forKey: "bio")
    postEntity.setValue(date, forKey: "date")
    postEntity.setValue("0", forKey: "hearts")
    
    appDelegate.saveContext()
}

//request.predicate = NSPredicate(format: "date CONTAINS %lf",postKey) gives error after calling function twice in same build(works first time called), so implementing myself:
func filterPosts(posts:[NSManagedObject],key:Double) -> NSManagedObject{
    var res:NSManagedObject? = nil
    
    posts.forEach{(post) in
        if post.value(forKey: "date") as! Double == key {
            res = post
        }
    }
    return res!
}

func fetchUserCdAsArray(user:String) -> Dictionary<String, Any> {
    let userCD = fetchUserCoreData(user: user, entity: "User")[0]
    var userData = Dictionary<String, Any>()
    
    userData["profPhotoData"] = userCD.value(forKey: "profilePhoto")
    
    return userData
}

func fetchOtherUsers() -> [Dictionary<String,Any>]{
    let otherUserData = fetchUserCoreData(user: "otherUsers", entity: "User")
    //no performance enhances for using forEach here(and almsot all the other times i used it) unlike say js
    var res = [Dictionary<String, Any>]()
    
    for user in otherUserData{
        var temp = Dictionary<String, Any>()
        temp["username"] = user.value(forKey: "username") as! String
        temp["email"] = user.value(forKey: "email") as! String
        temp["profilePhoto"] = user.value(forKey: "profilePhoto") as! Data
        res.append(temp)
    }
    return res
}

func fetchPostCdAsArray(user:String) -> ([Dictionary<String, Any>],[Dictionary<String, Any>]) {
    let userPostCD = fetchUserCoreData(user: user, entity: "Post")
    let allPostsCd = fetchUserCoreData(user: "all", entity: "Post")
    
    let userPostData = nsPostObjToDict(postCd: userPostCD)
    let allPostsData = nsPostObjToDict(postCd: allPostsCd)
    
    return (userPostData, allPostsData)
}

func nsPostObjToDict(postCd:[NSManagedObject]) -> [Dictionary<String, Any>] {
    var postData = [Dictionary<String, Any>]()
    
    for post in postCd {
        var temp = Dictionary<String, Any>()
        let postImageData = post.value(forKey: "content") as! Data
        let profImageData = post.value(forKey: "profilePhoto") as! Data
        let profImage = UIImage(data: profImageData)
        let postImage = UIImage(data: postImageData)
        
        temp["content"] = postImage
        temp["profilePhoto"] = profImage
        temp["comments"] = post.value(forKey: "comments")
        temp["date"] = post.value(forKey: "date")
        temp["bio"] = post.value(forKey: "bio")
        temp["hearts"] = post.value(forKey: "hearts")
        temp["username"] = post.value(forKey: "username")
        temp["email"] = post.value(forKey: "email")
        
        postData.append(temp)
    }
    return postData
}


