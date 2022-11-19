//
//  CoreDataHandler.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/19/22.
//
import Foundation
import CoreData
import UIKit

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
      for data in result as! [NSManagedObject] {
         imageDataArray.append(data.value(forKey: "content") as! Data)
      }
    } catch let error as NSError {
      print("\(error), \(error.userInfo)")
    }
    
    var myImagesdataArray = [Data]()
    //fetch image using decoding
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

func retrieveCoreData(entity:String) -> [NSManagedObject] {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
    var fetchedResults:[NSManagedObject]? = nil
    do{
        try fetchedResults = context.fetch(request) as? [NSManagedObject]
    } catch {
        let nserror = error as NSError
        print(nserror)
    }
    return (fetchedResults)!
}


func viewCoreData () {
    let data = retrieveCoreData(entity: "User")
    let friends = retrieveCoreData(entity: "Friends")
    var cnt = 0
    for user in data{
        cnt += 1
        
        let darkMode = user.value(forKey: "darkMode")
        let email = user.value(forKey: "email")
        let name = user.value(forKey: "name")
        let friends = user.value(forKey: "friends")
        let soundOn = user.value(forKey: "soundOn")

        print("user #\(cnt):\n email: \(String(describing: email)) name: \(String(describing: name)) darkMode: \(String(describing: darkMode)) soundOn: \(String(describing: soundOn))")
        
    }
    
    for i in friends {
        
        let userID = i.value(forKey: "email")
        let f1 = i.value(forKey: "f1")
        let f2 = i.value(forKey: "f2")
        let f3 = i.value(forKey: "f3")
        
        print("user: \(userID), friend1: \(f1) , friend2: \(f2)")
        
    }
    
}

func fetchUserCoreData(user:String,entity:String) -> [NSManagedObject]{
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
    
    request.predicate = NSPredicate(format: "email CONTAINS %@",user)
    
    var res:[NSManagedObject]? = nil
    
    do{
        try res = context.fetch(request) as? [NSManagedObject]
    } catch {
        let nserror = error as NSError
        print("errorhere:")
        print(nserror)
    }
    for user in res!{
        
        let darkMode = user.value(forKey: "darkMode")
        let email = user.value(forKey: "email")
        let name = user.value(forKey: "name")
        let soundOn = user.value(forKey: "soundOn")

        print("email: \(String(describing: email)) name: \(String(describing: name)) darkMode: \(String(describing: darkMode)) soundOn: \(String(describing: soundOn))")
        
    }
    return (res!)
}

func retrieveUserCD(user:String) -> [NSManagedObject] {
    let settingData = retrieveCoreData(entity: "User")
    let friendsData = retrieveCoreData(entity: "Friends")
    
    var userFriends = friendsData[0]
    var userSettings = settingData[0]
    
    for i in settingData {
        let email = i.value(forKey: "email")
        if (user == email as? String){
            print("Found CD for current user: \(user)")
            userSettings = i
        }
    }
    for i in friendsData {
        let email = i.value(forKey: "email")
        if (user == email as? String){
            userFriends = i
        }
    }
    
    
    print("currUserData: \(userSettings)")
    print("currUserFriends: \(userFriends)")
    
    
    return [userSettings,userFriends]
}
