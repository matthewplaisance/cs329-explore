//
//  ProfileViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 10/25/22.
//

import UIKit
import FirebaseAuth
import CoreData

struct DarkMode{
    static var darkModeIsEnabled: Bool = false
    
}
struct SoundOn{
    static var soundOn: Bool = true
}

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext


class ProfileViewController: UIViewController {
    
    var currUID = Auth.auth().currentUser?.email
    // Outlet Variables
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var darkModeToggle: UISwitch!
    @IBOutlet weak var soundToggle: UISwitch!
    
    
    override func viewWillAppear(_ animated: Bool) {
        // get CoreData settings
        print("curruser: \(String(describing: currUID))\n user cd:")
        //let userSettings = fetchUserCoreData(user: currUserID!, entity: "User")
        //let userFriends = fetchUserCoreData(user: currUserID!, entity: "Friends")
        var currUserData = fetchUserCoreData(user: currUID!, entity: "User")[0]
        
        
        if let darkMode = currUserData.value(forKey: "darkMode"){
            DarkMode.darkModeIsEnabled = darkMode as! Bool
        }
        if let loadedName = currUserData.value(forKey: "name"){
            nameField.text = loadedName as? String
        }
        if let loadedEmail = currUserData.value(forKey: "email"){
            emailField.text = loadedEmail as? String
        }
        if let loadedSound = currUserData.value(forKey: "soundOn"){
            SoundOn.soundOn = loadedSound as! Bool
        }
        
        // check for dark mode
        if DarkMode.darkModeIsEnabled == true{
            overrideUserInterfaceStyle = .dark
            darkModeToggle.isOn = true
        }else{
            overrideUserInterfaceStyle = .light
            darkModeToggle.isOn = false
        }
        // set error message label to blank
        errorMessage.text = ""
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func DarkModeToggle(_ sender: Any) {
        if darkModeToggle.isOn{
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
        
    }
    
    @IBAction func SoundToggled(_ sender: Any) {
        
    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if (newPasswordField.text != "") && (confirmPasswordField.text == newPasswordField.text){
            changePassword(password: confirmPasswordField.text!)
            print("Password changed") // change to alert
        }
        else if (newPasswordField.text != "") && (confirmPasswordField.text != newPasswordField.text){
            errorMessage.text = "New passwords do not match!"
        }
        updateUserData(user: currUID!)
        
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        let auth = Auth.auth()
        do{
            try auth.signOut()
            performSegue(withIdentifier: "logoutSegue", sender: self)
        }
        catch let signOutError{
            print(signOutError)
        }
    }
    
    func saveEmail(email: String){
        Auth.auth().currentUser?.updateEmail(to: emailField.text!){
            (error) in self.errorMessage.text = error.debugDescription
        }
    }
    
    func changePassword(password: String){
        Auth.auth().currentUser?.updatePassword(to: password){
            (error) in self.errorMessage.text = error.debugDescription
        }
    }
    
    func updateUserData(user:String) {
        var currUserData = fetchUserCoreData(user: currUID!, entity: "User")[0]
        
        let darkMode = darkModeToggle.isOn
        let soundMode = soundToggle.isOn
        let name = nameField.text!
        let email = emailField.text!
        let userData = [email,name,darkMode,soundMode] as [Any]
        let entry = ["email","name","darkMode","soundOn"]
        
        for (el,id) in zip(userData,entry){
            currUserData.setValue(el, forKey: id)
        }
        
        appDelegate.saveContext()
        
    }
}


