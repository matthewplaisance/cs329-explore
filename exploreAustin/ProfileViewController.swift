//
//  ProfileViewController.swift
//  exploreAustin
//
//  Created by Robert Binning on 10/25/22.
//

import UIKit
import FirebaseAuth

struct DarkMode{
    static var darkModeIsEnabled: Bool = false
}

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var darkModeToggle: UISwitch!
    @IBOutlet weak var soundToggle: UISwitch!
    
    override func viewWillAppear(_ animated: Bool) {
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
        }
        else{
            overrideUserInterfaceStyle = .light
            DarkMode.darkModeIsEnabled = false
        }
    }
    @IBAction func SoundToggled(_ sender: Any) {
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        //self.performSegue(withIdentifier: "settingsSaveSegue", sender: self)
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            //self.performSegue(withIdentifier: "logoutSegue", sender: nil)
        }
        catch{
            print("error")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsSaveSegue",
            let nextVC = segue.destination as? HomeViewController {
            if darkModeToggle.isOn{
                nextVC.overrideUserInterfaceStyle = .dark
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
