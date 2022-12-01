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
    
    @IBOutlet weak var privateSwitch: UISwitch!
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
        if DarkMode.darkModeIsEnabled == true{
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
        self.data = friendsInvited
        if self.data.isEmpty == true{
            var defualt = Dictionary<String,Any>()
            defualt["username"] = "Click to invite friends!"
            defualt["email"] = ""
            self.data.append(defualt)
        }
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
        let key = Date().timeIntervalSince1970
        self.sendInvites(users: self.data, eventKey: key)
        let date = customDataFormat(date: self.eventDate, long: true)
        
        var privateEvent = false
        if privateSwitch.isOn {
            privateEvent = true
        }
        
        var invitedStr = ""
        for i in self.data {
            invitedStr += "\(i["email"] ?? "")//"
        }
        
        let eventEntity = NSEntityDescription.insertNewObject(forEntityName: "Event", into: context)
        
        eventEntity.setValue(currUid, forKey: "owner")
        eventEntity.setValue(invitedStr, forKey: "participants")
        eventEntity.setValue(self.eventLocation, forKey: "location")
        eventEntity.setValue(date, forKey: "date")
        eventEntity.setValue(key, forKey: "key")
        eventEntity.setValue(privateEvent, forKey: "privateEvent")
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
    
    func sendInvites(users:[Dictionary<String,Any>],eventKey:Double){
        print("invites: \(users)")
        
        for user in users {
            let userEmail = user["email"] as! String
            let userCd = fetchUserCoreData(user: userEmail, entity: "User")[0]
            var invites = userCd.value(forKey: "invitations") as! String//string of doubles sep by //
            let strKey:String = String(format: "%f", eventKey) + "//"
            invites += strKey
            userCd.setValue(invites, forKey: "invitations")
            appDelegate.saveContext()
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "friendsSearch", sender: self)
    }
    
    
}




