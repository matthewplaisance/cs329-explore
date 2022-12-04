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
    var state:String!
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var userId: UITextField!
    @IBOutlet weak var userKey: UITextField!
    @IBOutlet weak var repearUserKeyField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var username: UITextField!
    
    
    var userIdtext:String? = nil
    var userKeytext:String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userKey.isSecureTextEntry = true
        repearUserKeyField.isSecureTextEntry = true
        statusLabel.lineBreakMode = .byWordWrapping
        statusLabel.numberOfLines = 0
        self.continueBtn.titleLabel?.font = UIFont.menloCustom()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let user = currUser {
            print("curr user: \(user)")
        }
        
        print("Loading Core Data...")
        self.viewCoreData()
        self.viewPosts()
        self.viewEvents()
        //clearCoreData(entity: "Event")
        //clearCoreData(entity: "Post")
        //clearCoreData(entity: "User")
        if self.state == "login"{
            self.repearUserKeyField.alpha = 0
            self.username.alpha = 0
            self.repearUserKeyField.isUserInteractionEnabled = false
            self.username.isUserInteractionEnabled = false
            self.continueBtn.setTitle("login",for: .normal)
            self.continueBtn.titleLabel?.font = UIFont.menloCustom()
        }else{
            self.repearUserKeyField.alpha = 1
            self.username.alpha = 1
            self.repearUserKeyField.isUserInteractionEnabled = true
            self.username.isUserInteractionEnabled = true
            self.continueBtn.setTitle("register & login", for: .normal)
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func backBtnHit(_ sender: Any) {
        let vc = storyBoard.instantiateViewController(withIdentifier: "openingVC") as! RegisterViewController
        vc.isModalInPresentation = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    //login or register
    @IBAction func continueBtnHit(_ sender: Any) {
        //let id = self.userId.text!
        //let pass = self.userKey.text!
        let id = "matt@tst.com"
        let pass = "qazxsw"
        let repPass = self.repearUserKeyField.text!
        let username = self.username.text!
        
        if self.state == "login"{
            Auth.auth().signIn(withEmail: id, password: pass){
                authResult, error in
                if let error = error as NSError? {
                    print("error")
                    self.statusLabel.text = "\(error.localizedDescription)"
                }else{//no error
                    self.userKey = nil
                    self.userId = nil
                    self.configureUserData()
                    self.performSegue(withIdentifier: "feedSeg", sender: self)
                }
            }
            
        }else if self.state == "register" {
            if (pass == repPass){
                Auth.auth().createUser(withEmail: id, password: pass){
                    authResult, error in //params from createUser method
                    if let error = error as NSError? {
                        self.statusLabel.text = "\(error.localizedDescription)"
                    }else{
                        createUserCD(user: id, username: username)
                        self.statusLabel.text = "Register!"
                        self.configureUserData()
                        self.performSegue(withIdentifier: "feedSeg", sender: self)
                    }
                }
            }else{
                self.statusLabel.text = "Passwords do not match."
            }
        }
    }
    
    func configureUserData() {
        self.loadingDataIndicator(done: false)
        mainFetchUserData()
        self.loadingDataIndicator(done: true)
    }
    
    func loadingDataIndicator(done:Bool) {
        let activityIndicator = UIActivityIndicatorView()
        
        if done == false{
            activityIndicator.style = .medium
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            self.view.addSubview(activityIndicator)
        }else{
            activityIndicator.stopAnimating()
        }
        
    }
    
    func viewCoreData () {
        let data = fetchUserCoreData(user: "all", entity: "User")
        var cnt = 0
        for user in data{
            cnt += 1
            
            let darkMode = user.value(forKey: "darkMode")
            let email = user.value(forKey: "email")
            let friends = user.value(forKey: "friends")
            let req = user.value(forKey: "recievedReqsF")
            let soundOn = user.value(forKey: "soundOn")
            let username = user.value(forKey: "username")
            print("user #\(cnt):\n email: \(String(describing: email)) username: \(String(describing: username)) darkMode: \(String(describing: darkMode)) soundOn: \(String(describing: soundOn))\n friends: \(friends ?? "")\n f reqs: \(req ?? "")")
            
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
    
    func viewEvents(){
        let data = fetchUserCoreData(user: "all", entity: "Event")
        let keys = ["ownerUid","invitedUid","location","date","privateEvent","key"]
        print("ALL EVENTS ::")
        for event in data {
            for key in keys{
                print("\(key): \(event.value(forKey: key) ?? "na")")
            }
        }
    }
}
