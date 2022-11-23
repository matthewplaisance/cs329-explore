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
    request.predicate = NSPredicate(format: "uid CONTAINS %@",uid)
    
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
    
    if user != "all"{
        if entity == "User"{
            request.predicate = NSPredicate(format: "email CONTAINS %@",user)
        }else if entity == "Post"{
            request.predicate = NSPredicate(format: "uid CONTAINS %@",user)
        }
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

func createPost(image:UIImage,bio:String,uid:String) {
    let postEntity = NSEntityDescription.insertNewObject(forEntityName: "Post", into: context)
    let date = Date().timeIntervalSince1970//unix time
    let imageData = image.jpegData(compressionQuality: 1)!
    
    postEntity.setValue(uid, forKey: "uid")
    postEntity.setValue(imageData, forKey: "content")
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
