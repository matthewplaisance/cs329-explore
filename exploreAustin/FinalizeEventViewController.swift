//
//  FinalizeEventViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/29/22.
//

import UIKit
import CoreData

var friendsInvited = [Dictionary<String,Any>]()

class FinalizeEventViewController: UIViewController, UITextViewDelegate{

    var eventDate:Date!
    var eventLocation:String!
    var data = [Dictionary<String,Any>]()
    
    @IBOutlet weak var publicSwitch: UISwitch!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.descriptionTextView.delegate = self
        
        self.tableView.register(FriendsTableViewCell.nib(), forCellReuseIdentifier: FriendsTableViewCell.id)
        
        self.descriptionTextView.text = "Event Description ..."
        self.descriptionTextView.textColor = UIColor.lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.data = friendsInvited
        print("data: \(self.data)")
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? SearchUsersViewController, segue.identifier == "friendsSearch"{
            dest.data = currUserFriends
            dest.searchId = "friends"
        }
    }
    
    @IBAction func createBtnHit(_ sender: Any) {
        print("date1: \(self.eventDate)")
        let date = customDataFormat(date: self.eventDate, long: true)
        print("date2: \(date)")
        let key = Date().timeIntervalSince1970
        var publicEvent = false
        if publicSwitch.isOn {
            publicEvent = true
        }
        var invitedStr = ""
        
        for i in self.data {
            invitedStr += "\(i["email"] as! String)\\"
        }
        
        let eventEntity = NSEntityDescription.insertNewObject(forEntityName: "Event", into: context)
        
        eventEntity.setValue(currUid, forKey: "owner")
        eventEntity.setValue(invitedStr, forKey: "participants")
        eventEntity.setValue(self.eventLocation, forKey: "location")
        eventEntity.setValue(date, forKey: "date")
        eventEntity.setValue(key, forKey: "key")
        eventEntity.setValue(publicEvent, forKey: "privateEvent")
        appDelegate.saveContext()
        navigationController?.popToRootViewController(animated: true)
    }
    

    @IBAction func friendsBtnHit(_ sender: Any) {
        self.performSegue(withIdentifier: "friendsSearch", sender: self)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.descriptionTextView.textColor == UIColor.lightGray {
            self.descriptionTextView.text = nil
            self.descriptionTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.descriptionTextView.text.isEmpty {
            self.descriptionTextView.text = "Placeholder"
            self.descriptionTextView.textColor = UIColor.lightGray
        }
    }
}

extension FinalizeEventViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendsTableViewCell.id, for: indexPath) as! FriendsTableViewCell
        let row = indexPath.row
        
        cell.usernameLabel.text = self.data[row]["username"] as? String
        cell.friendProfImageView.image = nil
        cell.checkImageView.image = nil
        return cell
    }
    
    
}




