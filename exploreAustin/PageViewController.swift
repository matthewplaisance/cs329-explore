//
//  PageViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/17/22.
//

import UIKit

let collectionCellID = "pageCollectionCell"
let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

class PageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var pageCollectionView: UICollectionView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    var data : [String] = ["ZilkerPark","MountBonnell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageCollectionView.delegate = self
        pageCollectionView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        var storyboardId: String {
               return value(forKey: "storyboardIdentifier") as? String ?? "none"
           }
        if storyboardId == "PageVC"{
            let homeIcon = UIImage(systemName: "house")
            self.navigationController?.navigationBar.backIndicatorImage = homeIcon
            self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = homeIcon
            self.navigationController?.navigationBar.backItem?.title = ""
        }
        var myImages = [UIImage(named: "ZilkerPark")!,UIImage(named: "MountBonnell")!]
        
        var imageData = convertImagesToData(myImagesArray: myImages)
        
        saveUIImages(imagesData: imageData)
        
        var fetchedImageData = fetchUIimages()
        
        var fetchedImages = convertDataToImages(imageDataArray: fetchedImageData)
        
        profileImage.image = fetchedImages[0]
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellID, for: indexPath) as! PagePhotoCell//new reuseable cell for table
        let row = indexPath.row
        
        cell.pageImageView.image = UIImage(named: data[row])
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(50, 414)
    }
    

    @IBAction func friendsHit(_ sender: Any) {
        let friendsVC = storyBoard.instantiateViewController(withIdentifier: "friendsVC") as! FriendsViewController
        self.present(friendsVC, animated:true, completion:nil)
    }
    
    
    @IBAction func eventsHit(_ sender: Any) {
        let eventsVC = storyBoard.instantiateViewController(withIdentifier: "eventsVC") as! EventsViewController
        self.present(eventsVC, animated:true, completion:nil)
    }
}
