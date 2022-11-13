//
//  LoadingScreenViewController.swift
//  exploreAustin
//
//  Created by Robert Binning on 10/29/22.
//

import UIKit
import CoreData
import FirebaseAuth

struct DarkMode{
    static var darkModeIsEnabled: Bool = false
    
}
struct SoundOn{
    static var soundOn: Bool = true
}

class LoadingScreenViewController: UIViewController {
    var userID = Auth.auth().currentUser?.email

    @IBOutlet weak var loadingImage: UIImageView!
    override func viewWillAppear(_ animated: Bool) {
        let userCD = retrieveUserCD()
        if let darkMode = userCD.value(forKey: "darkMode"){
            DarkMode.darkModeIsEnabled = darkMode as! Bool
        }
        if let loadedName = userCD.value(forKey: "name"){
        }
        if let loadedEmail = userCD.value(forKey: "email"){
        }
        if let loadedSound = userCD.value(forKey: "soundOn"){
            SoundOn.soundOn = loadedSound as! Bool
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(
            withDuration: 2.0,
               animations: {
                   self.loadingImage.alpha = 1.0
               },
               completion: { finished in
                   UIView.animate(withDuration: 2.0, animations: {
                       self.loadingImage.alpha = 0.0
                   }, completion: {finished in
                       self.performSegue(withIdentifier: "LoadingScreenSegue", sender: self)
                   })
               }
        )
        
    }
    
    func retrieveUserCD() -> NSManagedObject {
        let data = retrieveCoreData()
        
        var currUser = data[0]
        
        for user in data {
            let email = user.value(forKey: "email")
            if (userID == email as? String){
                print("Found CD for current user: \(userID!)")
                currUser = user
            }
        }
        print("currUserData: \(currUser)")
        return currUser
    }
    
    func retrieveCoreData() -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        var fetchedResults:[NSManagedObject]? = nil
        do{
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            let nserror = error as NSError
            print(nserror)
        }
        return (fetchedResults)!
    }
        
}
    
