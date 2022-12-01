//
//  LoadingScreenViewController.swift
//  exploreAustin
//
//  Created by Robert Binning on 10/29/22.
//

struct DarkMode{
    static var darkModeIsEnabled: Bool = false
    
}
struct SoundOn{
    static var soundOn: Bool = false
}

import UIKit
import FirebaseAuth
import CoreData

var currUid = Auth.auth().currentUser?.email!
//current user data, used across app until user posts/updates their data
var currPosts = [Dictionary<String, Any>]()
var currUserPosts = [Dictionary<String, Any>]()
var currUsrData = NSManagedObject()
var currUserFriends = [Dictionary<String, Any>]()
var otherUsers = [Dictionary<String, Any>]()
var userEvents = [NSManagedObject]()

class LoadingScreenViewController: UIViewController {

    @IBOutlet weak var loadingImage: UIImageView!
    
    var currUID = Auth.auth().currentUser?.email
    
    override func viewWillAppear(_ animated: Bool) {
        //load current user data
        Auth.auth().addStateDidChangeListener { auth, user in
          if let user = user {
              print("user for state: \(user)")
              print(user.email)
              currUid = user.email
              //currUid = user.email as! String
          } else {
            // No User is signed in. Show user the login screen
          }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(
            withDuration: 0.5,
               animations: {
                   self.loadingImage.alpha = 1.0
               },
               completion: { finished in
                   UIView.animate(withDuration: 0.5, animations: {
                       self.loadingImage.alpha = 0.0
                   }, completion: {finished in
                       self.performSegue(withIdentifier: "initialLoginSegue", sender: self)
                   })
               }
        )
        
    }
        
}
    
struct currentUserData {
    static var currUserData = Dictionary<String, Any>()
    static var currUserPosts = [Dictionary<String, Any>]()
    static var currPosts = [Dictionary<String, Any>]()
    static var updataPosts = false
}

extension UIImageView {

    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2) //instead of let radius = CGRectGetWidth(self.frame) / 2
        self.layer.masksToBounds = true
    }
}
