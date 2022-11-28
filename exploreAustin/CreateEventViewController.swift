//
//  CreateEventViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/27/22.
//

import UIKit
import CoreData

class CreateEventViewController: UIViewController {

    let searchController = UISearchController()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var eventDate: UIDatePicker!// gives 7 pm as 00:00:00 for military time for some stupid reason
    @IBOutlet weak var eventNameField: UITextField!
    @IBOutlet weak var privateSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    @IBAction func inviteBtnHit(_ sender: Any) {
        
    }
    
    @IBAction func createEventBtnHit(_ sender: Any) {
        print(self.eventDate.date)
        let date = customDataFormat(date: self.eventDate.date, long: true)
        let key = Date().timeIntervalSince1970
        var privateEvent = false
        if privateSwitch.isOn{
            privateEvent = true
        }
        print("d: \(date)")
        let eventEntity = NSEntityDescription.insertNewObject(forEntityName: "Event", into: context)
        
        eventEntity.setValue(currUid, forKey: "owner")
        eventEntity.setValue(date, forKey: "date")
        eventEntity.setValue(key, forKey: "key")
        eventEntity.setValue(privateEvent, forKey: "privateEvent")
    }
    
}
