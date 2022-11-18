//
//  PageViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/17/22.
//

import UIKit

let collectionCellID = "pageCollectionCell"

class PageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var pageCollectionView: UICollectionView!
    
    
    var data : [String] = ["ZilkerPark","MountBonnell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageCollectionView.delegate = self
        pageCollectionView.dataSource = self
        
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
        //cell.textLabel?.numberOfLines = 0
        //cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.pageImageView.image = UIImage(named: data[row])
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(50, 414)
    }
    

   
    @IBAction func friendsClicked(_ sender: Any) {
        
    }
    
    

   

}
