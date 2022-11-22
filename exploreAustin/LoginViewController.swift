//
//  LoginViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 10/25/22.
//

import UIKit
import FirebaseAuth
import CoreData

class LoginViewController: UIViewController {
    
    var currUser = Auth.auth().currentUser?.email
    
    @IBOutlet weak var loginSegCtrl: UISegmentedControl!
    @IBOutlet weak var userId: UITextField!
    @IBOutlet weak var userKey: UITextField!
    @IBOutlet weak var repearUserKeyField: UITextField!
    @IBOutlet weak var confirmPassword: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let user = currUser {
            print("curr user: \(user)")
        }
        
        print("Loading Core Data...")
        self.viewCoreData()
        self.viewPosts()
        //clearCoreData(entity: "Post")
        //clearCoreData(entity: "User")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmPassword.alpha = 0
        repearUserKeyField.alpha = 0
        userKey.isSecureTextEntry = true
        repearUserKeyField.isSecureTextEntry = true
        statusLabel.lineBreakMode = .byWordWrapping
        statusLabel.numberOfLines = 0
    }
    
    
    @IBAction func loginSegChange(_ sender: Any) {
        let idx = loginSegCtrl.selectedSegmentIndex
        if idx == 0{//logging in
            repearUserKeyField.alpha = 0
            confirmPassword.alpha = 0
            loginButton.setTitle("Sign In", for: .normal)
        }
        if idx == 1{
            repearUserKeyField.alpha = 1
            confirmPassword.alpha = 1
            loginButton.setTitle("Sign Up", for: .normal)
        }
    }
    
    
    @IBAction func loginHit(_ sender: Any) {
        let devId = "matt@tst.com"
        let devPass = "qazxsw"
        //fix below returning nil causing crash
        let id = userId.text!
        let pass = userKey.text!
        let idx = loginSegCtrl.selectedSegmentIndex
        if idx == 1{//sign up
            let passConfirm = repearUserKeyField.text!
            if (pass == passConfirm){
                Auth.auth().createUser(withEmail: id, password: pass){
                    authResult, error in //params from createUser method
                    if let error = error as NSError? {
                        self.statusLabel.text = "\(error.localizedDescription)"
                    }else{
                        self.createUserCD(user: id)
                        self.statusLabel.text = "Signed up!"
                    }
                }
            }else{
                self.statusLabel.text = "Passwords do not match."
            }
        }
        if idx == 0{//login
            Auth.auth().signIn(withEmail: id, password: pass){
                authResult, error in
                if let error = error as NSError? {
                    self.statusLabel.text = "\(error.localizedDescription)"
                }else{//no error
                    self.performSegue(withIdentifier: "loginSeg", sender: nil)
                    self.userKey = nil
                    self.userId = nil
                }
                
            }
        }
    }
    
    func createUserCD(user:String){
        let userEntity = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        //let userFreindsEntity = NSEntityDescription.insertNewObject(forEntityName: "Friends", into: context)
        let defualtPhoto = UIImage(systemName: "person")
        let photoData = defualtPhoto!.jpegData(compressionQuality: 1)!
        
        userEntity.setValue(user, forKey: "email")
        userEntity.setValue(" ", forKey: "friends")
        userEntity.setValue(photoData, forKey: "profilePhoto")
        
        appDelegate.saveContext()
    }
    
    
    func viewCoreData () {
        let data = fetchUserCoreData(user: "all", entity: "User")
        var cnt = 0
        for user in data{
            cnt += 1
            
            let darkMode = user.value(forKey: "darkMode")
            let email = user.value(forKey: "email")
            let name = user.value(forKey: "name")
            let friends = user.value(forKey: "friends")
            let soundOn = user.value(forKey: "soundOn")

            print("user #\(cnt):\n email: \(String(describing: email)) name: \(String(describing: name)) darkMode: \(String(describing: darkMode)) soundOn: \(String(describing: soundOn))\n friends: \(friends)")
            
        }
    }
    
    func viewPosts(){
        let posts = fetchUserCoreData(user: "all", entity: "Post")
        print("posts: ")
        for post in posts{
            let uid = post.value(forKey: "uid")
            let bio = post.value(forKey: "bio")
            let date = post.value(forKey: "date")
            
            print("user: \(uid) date: \(date)\n bio: \(bio)")
            
        }
    }
    
    func clearCoreData (entity:String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        var fetchedResults:[NSManagedObject]
        do{
            try fetchedResults = context.fetch(request) as! [NSManagedObject]
            
            if fetchedResults.count > 0 {
                for result:AnyObject in fetchedResults {
                    context.delete(result as! NSManagedObject)
                    //print("user w/ email:\(result.value(forKey: "email")) was deleted.")
                    print("deleted.")
                }
            }
            appDelegate.saveContext()
        }catch {
            let nserror = error as NSError
            print(nserror)
        }
    }
}
