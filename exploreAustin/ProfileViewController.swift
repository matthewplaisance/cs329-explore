//
//  ProfileViewController.swift
//  exploreAustin
//
//  Created by Robert Binning on 10/25/22.
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
    
    var currUserID = Auth.auth().currentUser?.email
    var friends = [String]()
    // Outlet Variables
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var darkModeToggle: UISwitch!
    @IBOutlet weak var soundToggle: UISwitch!
    @IBOutlet weak var friendsButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // get CoreData settings
        print("curruser: \(currUserID)")
        let userCD = retrieveUserCD(user: currUserID!)
        print("core data: ")
        viewCoreData()
        
    
        if let darkMode = userCD.value(forKey: "darkMode"){
            DarkMode.darkModeIsEnabled = darkMode as! Bool
        }
        if let loadedName = userCD.value(forKey: "name"){
            nameField.text = loadedName as? String
        }
        if let loadedEmail = userCD.value(forKey: "email"){
            emailField.text = loadedEmail as? String
        }
        if let loadedSound = userCD.value(forKey: "soundOn"){
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
    
    
    func checkFriendRequests() {
        
    }
    
    func sendFriendRequest() {
        let data = retrieveCoreData()
        let userData = retrieveUserCD(user: currUserID!)
        
        var users = [String]()
        for user in data {
            let email = user.value(forKey: "email") as? String
            if (currUserID != email){
                let name = user.value(forKey: "name") as? String
                let otherUser = "Name: \(name) email: \(email)"
                users.append(otherUser)
            }
        }
        print(users)
        let controller = UIAlertController(title: "Users:", message: "Click to send friend request:", preferredStyle: .actionSheet)
        for i in users {
            let friendAction = UIAlertAction(
                title: i,
                style: .default,
                handler: {
                    (action) in
                }
            )
        }
        
    }
    
    func addFriendRequest(othUser:String) {
        let currUser = retrieveUserCD(user: currUserID!)
        
    }
    
    @IBAction func friendsClicked(_ sender: Any) {
        
    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if (newPasswordField.text != "") && (confirmPasswordField.text == newPasswordField.text){
            changePassword(password: confirmPasswordField.text!)
            print("Password changed") // change to alert
        }
        else if (newPasswordField.text != "") && (confirmPasswordField.text != newPasswordField.text){
            errorMessage.text = "New passwords do not match!"
        }
        updateUserData(user: currUserID!)
        
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
    
   
    func retrieveUserCD(user:String) -> NSManagedObject {
        let data = retrieveCoreData()
        
        var userLookedUp = data[0]
        
        for i in data {
            let email = i.value(forKey: "email")
            if (user == email as? String){
                print("Found CD for current user: \(user)")
                userLookedUp = i
            }
        }
        print("currUserData: \(userLookedUp)")
        return userLookedUp
    }
    
    
    
    func updateUserData(user:String) {
        let data = retrieveCoreData()
        
        let darkMode = darkModeToggle.isOn
        let soundMode = soundToggle.isOn
        let name = nameField.text!
        let email = emailField.text!
        let userData = [email,name,darkMode,soundMode] as [Any]
        let entry = ["email","name","darkMode","soundOn"]
        
        for i in data {
            let email = i.value(forKey: "email")
            if user == email as? String {
                for (el,id) in zip(userData,entry){
                    i.setValue(el, forKey: id)
                }
            }
        }
        appDelegate.saveContext()
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
    
    
    func viewCoreData () {
        let data = retrieveCoreData()
        var cnt = 0
        for user in data{
            cnt += 1
            
            let darkMode = user.value(forKey: "darkMode")
            let email = user.value(forKey: "email")
            let name = user.value(forKey: "name")
            let soundOn = user.value(forKey: "soundOn")

            print("user #\(cnt):\n email: \(email) name: \(name)  darkMode: \(darkMode) soundOn: \(soundOn)")
            
        }
        
    }
    
    
    
    
    

}

