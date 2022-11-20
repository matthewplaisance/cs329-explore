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
        for data in result {
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

func fetchUserCoreData(user:String,entity:String) -> [NSManagedObject]{
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
    
    if user != "all"{
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
