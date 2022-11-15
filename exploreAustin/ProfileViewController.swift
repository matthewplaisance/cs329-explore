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
        print("curruser: \(String(describing: currUserID))\n user cd:")
        //let userSettings = fetchUserCoreData(user: currUserID!, entity: "User")
        //let userFriends = fetchUserCoreData(user: currUserID!, entity: "Friends")
        let userSettings = retrieveUserCD(user: currUserID!)[0]
        print("core data: ")
        viewCoreData()
        
    
        if let darkMode = userSettings.value(forKey: "darkMode"){
            DarkMode.darkModeIsEnabled = darkMode as! Bool
        }
        if let loadedName = userSettings.value(forKey: "name"){
            nameField.text = loadedName as? String
        }
        if let loadedEmail = userSettings.value(forKey: "email"){
            emailField.text = loadedEmail as? String
        }
        if let loadedSound = userSettings.value(forKey: "soundOn"){
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
    
    func retrieveUserCD(user:String) -> [NSManagedObject] {
        let settingData = retrieveCoreData(entity: "User")
        let friendsData = retrieveCoreData(entity: "Friends")
        
        var userFriends = friendsData[0]
        var userSettings = settingData[0]
        
        for i in settingData {
            let email = i.value(forKey: "email")
            if (user == email as? String){
                print("Found CD for current user: \(user)")
                userSettings = i
            }
        }
        for i in friendsData {
            let email = i.value(forKey: "email")
            if (user == email as? String){
                userFriends = i
            }
        }
        
        
        print("currUserData: \(userSettings)")
        print("currUserFriends: \(userFriends)")
        
        
        return [userSettings,userFriends]
    }
    
    
    
    func checkFriendRequests() {
        let currUserFriends = retrieveUserCD(user: currUserID!)[1]//friends
        let keys = ["f1","f2","f3","f4"]
        var requestingUsers = [String]()
        for i in keys {
            var f = currUserFriends.value(forKey: i) as? String
            if (f!.last! == "1"){//recieved friend req
                f!.remove(at: f!.index(before: f!.endIndex))
                requestingUsers.append(f!)
            }
        }
        if requestingUsers.count != 0 {
            
        }
        
        
    }
   
    
    func sendFriendRequest() {
        let userEntity = retrieveCoreData(entity: "User")
        
        
        let currUserData = retrieveUserCD(user: currUserID!)[0]//user settings
        
        var users = [String]()
        for user in userEntity {
            let email = user.value(forKey: "email") as? String
            if (currUserID != email){
                let name = user.value(forKey: "name") as? String
                users.append(email!)
            }
        }
        
        let controller = UIAlertController(title: "Users:", message: "Click to send friend request:", preferredStyle: .actionSheet)
        for i in users {
            let friendAction = UIAlertAction(
                title: i,
                style: .default,
                handler: {
                    (action) in
                    self.addFriendRequest(othUser: i)
                }
            )
            controller.addAction(friendAction)
        }
        present(controller,animated: true)
    }
    
    
    func addFriendRequest(othUser:String) {
        let currUserFriends = retrieveUserCD(user: currUserID!)[1]
        let othUserFriends = retrieveUserCD(user: othUser)[1]
        
        let slotOth = findOpenSlot(user: othUser)
        let slotCurr = findOpenSlot(user: currUserID!)
        if slotOth == "N/a" || slotCurr == "N/a" {
            
        }
        //1 : recievedFriendReq 2 : sentFriendReq  3: Friends
        let sentReq = "\(othUser)2"
        let recievedReq = "\(currUserID!)1"
        
        print("slotCurr: \(slotCurr) \n slotOth: \(slotOth) \n reqs: \(sentReq) \(recievedReq)")
        
        currUserFriends.setValue(sentReq, forKey: slotCurr)
        othUserFriends.setValue(recievedReq, forKey: slotOth)
        appDelegate.saveContext()
        
    }
    
    func findOpenSlot(user:String) -> String {
        let userFriends = retrieveUserCD(user: user)[1]
        let keys = ["f1","f2","f3","f4"]
        for i in keys{
            let f = userFriends.value(forKey: i)
            if f == nil {
                return i
            }
        }
        return "max friends"
    }
    
    @IBAction func friendsClicked(_ sender: Any) {
        sendFriendRequest()
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

    
    func updateUserData(user:String) {
        let data = retrieveCoreData(entity: "User")
        
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
    
    func fetchUserCoreData(user:String,entity:String) -> [NSManagedObject]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        request.predicate = NSPredicate(format: "email CONTAINS %@",user)
        
        var res:[NSManagedObject]? = nil
        
        do{
            try res = context.fetch(request) as? [NSManagedObject]
        } catch {
            let nserror = error as NSError
            print("errorhere:")
            print(nserror)
        }
        for user in res!{
            
            let darkMode = user.value(forKey: "darkMode")
            let email = user.value(forKey: "email")
            let name = user.value(forKey: "name")
            let soundOn = user.value(forKey: "soundOn")

            print("email: \(String(describing: email)) name: \(String(describing: name)) darkMode: \(String(describing: darkMode)) soundOn: \(String(describing: soundOn))")
            
        }
        return (res!)
    }
    
    
    
    

}


