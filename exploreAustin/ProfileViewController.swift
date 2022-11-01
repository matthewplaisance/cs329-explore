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

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

class ProfileViewController: UIViewController {
    
    let user = Auth.auth().currentUser
    
    
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var darkModeToggle: UISwitch!
    @IBOutlet weak var soundToggle: UISwitch!
    
    override func viewWillAppear(_ animated: Bool) {
        let loadedSettings = retrieveSettings()
        for i in loadedSettings{
            if let darkMode = i.value(forKey: "darkMode"){
                DarkMode.darkModeIsEnabled = darkMode as! Bool
            }
            if let loadedName = i.value(forKey: "name"){
                nameField.text = loadedName as? String
            }
            if let loadedEmail = i.value(forKey: "email"){
                emailField.text = loadedEmail as? String
            }
        }
        if DarkMode.darkModeIsEnabled == true{
            overrideUserInterfaceStyle = .dark
            darkModeToggle.isOn = true
        }
        errorMessage.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func DarkModeToggle(_ sender: Any) {
        if darkModeToggle.isOn{
            overrideUserInterfaceStyle = .dark
            DarkMode.darkModeIsEnabled = true
            saveDarkMode(darkMode: DarkMode.darkModeIsEnabled)
        }
        else{
            overrideUserInterfaceStyle = .light
            DarkMode.darkModeIsEnabled = false
            saveDarkMode(darkMode: DarkMode.darkModeIsEnabled)
        }
    }
    @IBAction func SoundToggled(_ sender: Any) {
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if newPasswordField.text != confirmPasswordField.text {
            errorMessage.text = "New password does not match!"
        }
        else{
            saveName(name: nameField.text!)
            saveEmail(email: emailField.text!)
            changePassword(password: confirmPasswordField.text!)
            performSegue(withIdentifier: "settingsSaveSegue", sender: self)
        }
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "logoutSegue", sender: self)
        }
        catch{
            print("error")
        }
    }
    func saveDarkMode(darkMode:Bool) {
        let dataToStore = NSEntityDescription.insertNewObject(forEntityName: "ProfileSettings", into: context)
        dataToStore.setValue(darkMode, forKey: "darkMode")
        saveContext()
    }
    
    func saveName(name: String){
        let dataToStore = NSEntityDescription.insertNewObject(forEntityName: "ProfileSettings", into: context)
        dataToStore.setValue(nameField.text, forKey: "name")
        saveContext()
    }
    
    func saveEmail(email: String){
        let dataToStore = NSEntityDescription.insertNewObject(forEntityName: "ProfileSettings", into: context)
        dataToStore.setValue(emailField.text, forKey: "email")
        Auth.auth().currentUser?.updateEmail(to: emailField.text!){
            (error) in self.errorMessage.text = error.debugDescription
        }
        saveContext()
    }
    
    func changePassword(password: String){
        Auth.auth().currentUser?.updatePassword(to: password){
            (error) in self.errorMessage.text = error.debugDescription
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
    
    func saveContext(){
        if context.hasChanges{
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
