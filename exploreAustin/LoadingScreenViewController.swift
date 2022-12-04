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
struct SoundPlaying{
    static var isPlaying: Bool = false
}

import UIKit
import FirebaseAuth
import CoreData



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

