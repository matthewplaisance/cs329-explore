//
//  NotificationsViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/30/22.
//

import UIKit

class NotificationsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var data = [Dictionary<String,Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let reqs = userFriends(key: "recievedReqsF")
        self.data = reqs
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(NotificationTableViewCell.nib(), forCellReuseIdentifier: NotificationTableViewCell.id)

    }
    
}

extension NotificationsViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.id, for: indexPath) as! NotificationTableViewCell
        let row = indexPath.row
        print("row typr: \(type(of: row))")
        cell.usernameLabel.text = self.data[row]["username"] as? String
        cell.profilePhotoView.image = self.data[row]["profilePhoto"] as? UIImage
        cell.userEmail = self.data[row]["email"] as? String
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}



