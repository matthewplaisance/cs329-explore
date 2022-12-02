//
//  RegisterViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 12/2/22.
//

import UIKit

class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerBtnHit(_ sender: Any) {
        let vc = storyBoard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        vc.state = "register"
        self.present(vc, animated: true)
    }
    
    @IBAction func loginBtnHit(_ sender: Any) {
        let vc = storyBoard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        vc.state = "login"
        self.present(vc, animated: true)
    }
    
    

}
