//
//  ProfileViewController.swift
//  exploreAustin
//
//  Created by Robert Binning on 10/25/22.
//

import UIKit
import FirebaseAuth
import CoreData
import ZLPhotoBrowser



struct DarkMode{
    static var darkModeIsEnabled: Bool = false
    
}
struct SoundOn{
    static var soundOn: Bool = true
}

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext


class ProfileViewController: UIViewController {
    
    var userID = Auth.auth().currentUser?.email
    // Outlet Variables
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var darkModeToggle: UISwitch!
    @IBOutlet weak var soundToggle: UISwitch!
    
    @IBOutlet weak var photoBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        
        // get CoreData settings
        print("curruser: \(userID)")
        let userCD = retrieveUserCD()
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
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if (newPasswordField.text != "") && (confirmPasswordField.text == newPasswordField.text){
            changePassword(password: confirmPasswordField.text!)
            print("Password changed") // change to alert
        }
        else if (newPasswordField.text != "") && (confirmPasswordField.text != newPasswordField.text){
            errorMessage.text = "New passwords do not match!"
        }
        updateUserData()
        
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
    
    
    @IBAction func photoClick(_ sender: Any) {
       let ps = ZLPhotoPreviewSheet()
        let config = ZLPhotoConfiguration.default()
        config.maxSelectCount = 1
        ps.selectImageBlock = { [weak self] results, isOriginal in
            guard let self = self else {return}
            guard let img = results.first?.image else { return  }
            self.photoBtn.setBackgroundImage(img, for: .normal)
            self.photoBtn.setTitle("", for: .normal)
        }
        ps.showPreview(animate: true, sender: self)
        
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
    
    
    
    func updateUserData() {
        let data = retrieveCoreData()
        
        let darkMode = darkModeToggle.isOn
        let soundMode = soundToggle.isOn
        let name = nameField.text!
        let email = emailField.text!
        let userData = [email,name,darkMode,soundMode] as [Any]
        let entry = ["email","name","darkMode","soundOn"]
        
        for user in data {
            let email = user.value(forKey: "email")
            if userID == email as? String {
                for (el,id) in zip(userData,entry){
                    user.setValue(el, forKey: id)
                }
            }
        }
        appDelegate.saveContext()
        retrieveUserCD()
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

