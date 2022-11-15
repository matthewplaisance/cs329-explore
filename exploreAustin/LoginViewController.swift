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
        
        if (currUser != nil) {
            print("currently logged in as: \(currUser)")
        }
        
        print("Loading Core Data...")
        viewCoreData()
        //clearCoreData(entity: "User")
        //clearCoreData(entity: "Friends")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmPassword.alpha = 0
        repearUserKeyField.alpha = 0
        userKey.isSecureTextEntry = true
        repearUserKeyField.isSecureTextEntry = true
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
    
    func retrieveCoreData(entity:String) -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        var fetchedResults:[NSManagedObject]? = nil
        do{
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            let nserror = error as NSError
            print(nserror)
        }
        return (fetchedResults)!
    }
    
    func createUserCD(user:String){
        let userEntity = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        let userFreindsEntity = NSEntityDescription.insertNewObject(forEntityName: "Friends", into: context)
        
        userEntity.setValue(user, forKey: "email")
        userFreindsEntity.setValue(user, forKey: "email")
        
        appDelegate.saveContext()
    }
    
    
    func viewCoreData () {
        let data = retrieveCoreData(entity: "User")
        let friends = retrieveCoreData(entity: "Friends")
        var cnt = 0
        for user in data{
            cnt += 1
            
            let darkMode = user.value(forKey: "darkMode")
            let email = user.value(forKey: "email")
            let name = user.value(forKey: "name")
            let friends = user.value(forKey: "friends")
            let soundOn = user.value(forKey: "soundOn")

            print("user #\(cnt):\n email: \(String(describing: email)) name: \(String(describing: name)) darkMode: \(String(describing: darkMode)) soundOn: \(String(describing: soundOn))")
            
        }
        
        for i in friends {
            
            let userID = i.value(forKey: "email")
            let f1 = i.value(forKey: "f1")
            let f2 = i.value(forKey: "f2")
            let f3 = i.value(forKey: "f3")
            
            print("user: \(userID), friend1: \(f1) , friend2: \(f2)")
            
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
                    print("user w/ email:\(result.value(forKey: "email")) was deleted.")
                }
            }
            appDelegate.saveContext()
        }catch {
            let nserror = error as NSError
            print(nserror)
        }
    }
}
