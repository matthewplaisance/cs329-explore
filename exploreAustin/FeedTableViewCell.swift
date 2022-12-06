//
//  FeedTableViewCell.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/22/22.
//
//quite embarassed I just found out tabVCs today... wouldve saved alot of segue code.

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    static let id = "FeedTableViewCell"
    
    //register cell
    static func nib() -> UINib {
        return UINib(nibName: "FeedTableViewCell", bundle: nil)
    }
    
    var delegate:FeedCellDelegator!
    var postKey: Double!
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var numLikes: UILabel!
    @IBOutlet weak var usernameBtn: UIButton!
    
    var userEmail:String = ""//used as user key
    var comments:String?
    var bio:String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func likeBtnHit(_ sender: Any) {
        likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        let likes = numLikes.text
        let currLikes = String(Int(likes!)! + 1)
        numLikes.text = currLikes
       
        let posts = fetchUserCoreData(user: "all", entity: "Post")
        let post = filterPosts(posts: posts, key: postKey)
        post.setValue(currLikes, forKey: "hearts")
        appDelegate.saveContext()
        
    }
    
    
    @IBAction func commentBtnHit(_ sender: Any) {
        var bio:String = ""
        var comments:String = ""
        if let hasBio = self.bio {
            bio = hasBio
        }
     
        if let hasComments = self.comments {
            comments = hasComments
        }
        
        if self.delegate != nil {
            self.delegate.segTocomments(postedUser: self.userEmail, postImage: self.postImageView.image!, bio: bio, comments: comments, postKey: self.postKey)
        }
    }
    
    
    @IBAction func usernameBtnHit(_ sender: Any) {
        self.delegate.segToPage(postedUser: self.userEmail)
    }
}

protocol FeedCellDelegator {
    func segTocomments(postedUser:String,postImage:UIImage,bio:String,comments:String,postKey:Double)
    func segToPage(postedUser:String)
}
