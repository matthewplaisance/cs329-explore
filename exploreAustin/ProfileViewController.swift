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
        }
        if DarkMode.darkModeIsEnabled == true{
            overrideUserInterfaceStyle = .dark
            darkModeToggle.isOn = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func DarkModeToggle(_ sender: Any) {
        if darkModeToggle.isOn{
            overrideUserInterfaceStyle = .dark
            DarkMode.darkModeIsEnabled = true
            storeSettings(darkMode: DarkMode.darkModeIsEnabled)
        }
        else{
            overrideUserInterfaceStyle = .light
            DarkMode.darkModeIsEnabled = false
            storeSettings(darkMode: DarkMode.darkModeIsEnabled)
        }
    }
    @IBAction func SoundToggled(_ sender: Any) {
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {

        performSegue(withIdentifier: "settingsSaveSegue", sender: self)
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
    func storeSettings(darkMode:Bool) {
        let dataToStore = NSEntityDescription.insertNewObject(forEntityName: "ProfileSettings", into: context)
        dataToStore.setValue(darkMode, forKey: "darkMode")
        saveContext()
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
