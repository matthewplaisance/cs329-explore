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
    var profImage: UIImage?
    
    // Outlet Variables
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var darkModeToggle: UISwitch!
    @IBOutlet weak var soundToggle: UISwitch!
    @IBOutlet weak var profImageView: UIImageView!
    
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
        
        let profPhoto = fetchUIImage(uid: currUID!)
        profImageView.image = profPhoto
        
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
            (error) in self.errorMessage.text = error?.localizedDescription
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
    
    
    @IBAction func changeProfPhotoHit(_ sender: Any) {
        self.performSegue(withIdentifier: "changeProfPhotoSeg", sender: self)
    }
    
    
    
    @IBAction func changePasswordHit(_ sender: Any) {
        let passwordAlert = UIAlertController(title: "Change Password: ", message: "", preferredStyle: .alert)

        for i in 1...2 {
            passwordAlert.addTextField { (textField) in
                if i == 1 {
                    textField.placeholder = "New password"
                }else{
                    textField.placeholder = "Repeat password"
                }
                
            }
        }

        passwordAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak passwordAlert] (action) in
            let pass = passwordAlert?.textFields![0].text!
            let passRepeat = passwordAlert?.textFields![1].text!
            
            if pass  == "" || passRepeat == "" {
                passwordAlert?.dismiss(animated: true)
            }
            if pass == passRepeat {
                self.changePassword(password: pass!)
            }else{
                passwordAlert?.message = "Passwords do not match"
            }
        }))
        
        passwordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak passwordAlert] (action) in
            return
        }))

        self.present(passwordAlert, animated: true, completion: nil)
    }
    
}


