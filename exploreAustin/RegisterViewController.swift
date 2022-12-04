//
//  RegisterViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 12/2/22.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerBtn.layer.shadowRadius = 10
        self.loginBtn.titleLabel?.font = UIFont.menloCustom()
        self.registerBtn.titleLabel?.font = UIFont.menloCustom()
        
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
