//
//  FeedViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/22/22.
//

import UIKit

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var feedTable: UITableView!
    
    var data1 : [String] = ["ZilkerPark","MountBonnell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTable.register(FeedTableViewCell.nib(), forCellReuseIdentifier: FeedTableViewCell.id)
        feedTable.delegate = self
        feedTable.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedTable.dequeueReusableCell(withIdentifier: FeedTableViewCell.id, for: indexPath) as! FeedTableViewCell
        let row = indexPath.row
        
        reSize(imageView: cell.postImageView, container: cell.postImageContainer, image: data1[row])
        
        cell.postImageView.image = UIImage(named: data1[row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }

}

func reSize(imageView:UIImageView,container:UIView,image:String){
    if let myImage = UIImage(named: image) {
        let myImageWidth = myImage.size.width
        let myImageHeight = myImage.size.height
        let myViewWidth = container.frame.width
     
        let ratio = myViewWidth/myImageWidth
        let scaledHeight = myImageHeight * ratio

        imageView.frame.size = CGSize(width: myViewWidth, height: scaledHeight)
    }
}
