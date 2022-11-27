//
//  CommentsViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/25/22.
//

import UIKit

class CommentsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var postedBioLabel: UILabel!
    @IBOutlet weak var addCommentField: UITextField!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postedDateLabel: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    
    
    var commentsStr:String!
    var bio:String!
    var postedUser:String!
    var postedImage:UIImage!
    var postKey:Double!
    
    var data = [Dictionary<String,Any>]()
    let bold = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.postImageView.image = postedImage
        self.parseComments(commentsStr: self.commentsStr)
        let commentingUser = currUid
        if let hasBio = self.bio {
            let userStr:String = "\(self.postedUser ?? "User"): "
            let user = NSMutableAttributedString(string:userStr, attributes:self.bold)
            let bioAttr = NSMutableAttributedString(string:hasBio)
            user.append(bioAttr)
            postedBioLabel.attributedText = user
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentsTableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        let row = indexPath.row
        
        let userStr:String = "\(self.data[row]["username"] ?? "User"): "
        let user = NSMutableAttributedString(string:userStr, attributes:self.bold)
        let comment = NSMutableAttributedString(string:self.data[row]["comment"] as! String)
        user.append(comment)
        
        cell.textLabel?.attributedText = user
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        return cell
    }
    
    
    @IBAction func postBtnHit(_ sender: Any) {
        let comm = self.addCommentField.text!
        if comm != ""{
            print("comment : \(comm)")
            //display comment for user, look how fast we store your data!
            self.displayComment(comment: comm)
            self.addCommentField.text = nil
            self.addCommentField.placeholder = "Add a comment ..."
            //get post from cd
            self.storeComment(comm: comm)
        }
    }
    
    func parseComments(commentsStr:String) {
        let sepOne = customSep(str: commentsStr, sepBy: "///")
        var res = [Dictionary<String,Any>]()
        print("sepone: \(sepOne)")
        sepOne.forEach{(str) in
            var temp = Dictionary<String,Any>()
            let arr = customSep(str: str, sepBy: "//")
            print("comment arr: \(arr)")
            temp["comment"] = arr[0]
            temp["username"] = arr[1]
            res.append(temp)
        }
        self.data = res
    }
    
    func displayComment(comment:String){
        var temp = Dictionary<String,Any>()
        temp["comment"] = comment
        temp["username"] = currUid
        self.data.insert(temp, at: 0)
        self.commentsTableView.reloadData()
    }
    
    func storeComment(comm:String){
        let posts = fetchUserCoreData(user: "all", entity: "Post")
        let post = filterPosts(posts: posts, key: self.postKey)
        var comments:String?
        if let currComments = post.value(forKey: "comments") as? String{
            comments = "\(comm)//\(currUid)///\(currComments)"
        }else{
            comments = "\(comm)//\(currUid)"
        }
        
        post.setValue(comments, forKey: "comments")
        appDelegate.saveContext()
        //update current data struct
        let postData = fetchPostCdAsArray(user: currUid)
        currPosts = postData.1
    }
}
