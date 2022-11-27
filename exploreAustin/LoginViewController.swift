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
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    var userIdtext:String? = nil
    var userKeytext:String? = nil
    
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
        username.alpha = 0
        usernameLabel.alpha = 0
        userKey.isSecureTextEntry = true
        repearUserKeyField.isSecureTextEntry = true
        statusLabel.lineBreakMode = .byWordWrapping
        statusLabel.numberOfLines = 0
    }
    
    
    @IBAction func loginSegChange(_ sender: Any) {
        let idx = loginSegCtrl.selectedSegmentIndex
        if idx == 0{//logging in
            username.alpha = 0
            usernameLabel.alpha = 0
            repearUserKeyField.alpha = 0
            confirmPassword.alpha = 0
            loginBtn.setTitle("Sign In", for: .normal)
        }
        if idx == 1{
            username.alpha = 1
            usernameLabel.alpha = 1
            repearUserKeyField.alpha = 1
            confirmPassword.alpha = 1
            loginBtn.setTitle("Sign Up", for: .normal)
        }
    }
    
    
    @IBAction func loginBtnHit(_ sender: Any) {
        //var devId = "matt@tst.com"
        //var devPass = "qazxsw"
        //fix below returning nil causing crash
        let idx = loginSegCtrl.selectedSegmentIndex
        
        if idx == 1{//sign up
            if let id = userId.text, let pass = userKey.text, let username = username.text {
                let passConfirm = repearUserKeyField.text!
                if (pass == passConfirm){
                    Auth.auth().createUser(withEmail: id, password: pass){
                        authResult, error in //params from createUser method
                        if let error = error as NSError? {
                            self.statusLabel.text = "\(error.localizedDescription)"
                        }else{
                            self.createUserCD(user: id, username: username)
                            self.statusLabel.text = "Signed up!"
                        }
                    }
                }else{
                    self.statusLabel.text = "Passwords do not match."
                }
            }else{
                self.statusLabel.text = "Please enter all fields."
            }
        }
        if idx == 0{//login
            print("login")
            let devId = userId.text!
            let devPass = userKey.text!
            Auth.auth().signIn(withEmail: devId, password: devPass){
                authResult, error in
                print("checking????")
                if let error = error as NSError? {
                    print("error")
                    self.statusLabel.text = "\(error.localizedDescription)"
                }else{//no error
                    print("logging in? ")
                    let loadingVC = storyBoard.instantiateViewController(withIdentifier: "loadingVC") as! LoadingScreenViewController
                    currUid = devId
                    print("devID \(devId)")
                    print("currId! \(currUid)")
                    //self.performSegue(withIdentifier: "loadingScreenSeg", sender: self)
                    loadingVC.isModalInPresentation = true
                    loadingVC.modalPresentationStyle = .fullScreen
                    self.present(loadingVC, animated: true,completion: nil)
                    self.userKey = nil
                    self.userId = nil
                }
            }
        }
    }
    
    
    
    func createUserCD(user:String,username:String){
        let userEntity = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        
        let defualtPhoto = UIImage(systemName: "person")
        let photoData = defualtPhoto!.jpegData(compressionQuality: 1)!
        
        userEntity.setValue(user, forKey: "email")
        userEntity.setValue(username, forKey: "username")
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
            let friends = user.value(forKey: "friends")
            let soundOn = user.value(forKey: "soundOn")
            let username = user.value(forKey: "username")
            print("user #\(cnt):\n email: \(String(describing: email)) username: \(String(describing: username)) darkMode: \(String(describing: darkMode)) soundOn: \(String(describing: soundOn))\n friends: \(friends)")
            
        }
    }
    
    func viewPosts(){
        let data = fetchUserCoreData(user: "all", entity: "Post")
        print("posts: ")
        for post in data{
            if let comm = post.value(forKey: "comments"){
                print("comments: \(comm)")
            }
           
            
            
            
            
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
