//
//  FriendsViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/18/22.
//

import UIKit

class FriendsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let dataVC = ProfileViewController()
        var currUser = dataVC.currUserID!
        let userData = dataVC.retrieveUserCD(user: currUser)
        print("user: \(currUser)\n data: \(userData)")
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
