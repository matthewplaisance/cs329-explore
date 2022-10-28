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

    @IBOutlet weak var loginSegCtrl: UISegmentedControl!
    @IBOutlet weak var userId: UITextField!
    @IBOutlet weak var userKey: UITextField!
    @IBOutlet weak var repearUserKeyField: UITextField!
    @IBOutlet weak var confirmPassword: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        let loadedSettings = retrieveSettings()
        for i in loadedSettings{
            if let darkMode = i.value(forKey: "darkMode"){
                DarkMode.darkModeIsEnabled = darkMode as! Bool
            }
        }
        if DarkMode.darkModeIsEnabled == true{
            overrideUserInterfaceStyle = .dark
        }
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
        var id = userId.text!
        let pass = userKey.text!
        let idx = loginSegCtrl.selectedSegmentIndex
        if idx == 1{//sign up
            //print("res:\(authCreateUser(id: id, pass: pass))")
            let passConfirm = repearUserKeyField.text!
            if (pass == passConfirm){
                Auth.auth().createUser(withEmail: id, password: pass){
                    authResult, error in //params from createUser method
                    if let error = error as NSError? {
                    
                            self.statusLabel.text = "\(error.localizedDescription)"
                    }else{
                        print("signed up")
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
    
    func retrieveSettings() -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ProfileSettings")
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
