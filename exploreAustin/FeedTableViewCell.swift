//
//  FeedTableViewCell.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/22/22.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    static let id = "FeedTableViewCell"
    
    //register cell
    static func nib() -> UINib {
        return UINib(nibName: "FeedTableViewCell", bundle: nil)
    }
    
    var postKey: Double = 0
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var numLikes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func likeBtnHit(_ sender: Any) {
        likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        let likes = numLikes.text
        var currLikes = String(Int(likes!)! + 1)
        numLikes.text = currLikes
       
        let posts = fetchUserCoreData(user: "all", entity: "Post")
        let post = filterPosts(posts: posts, key: postKey)
        post.setValue(currLikes, forKey: "hearts")
        appDelegate.saveContext()
        
    }
    
    
    @IBAction func commentBtnHit(_ sender: Any) {
    }
}
