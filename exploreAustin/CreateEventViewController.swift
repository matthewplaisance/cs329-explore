//
//  CreateEventViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/27/22.
//

import UIKit
import CoreData

var locFromSearch = ""

class CreateEventViewController: UIViewController {
    
    @IBOutlet weak var locatinSearchField: UITextField!
    @IBOutlet weak var eventDate: UIDatePicker!
    @IBOutlet weak var eventNameField: UITextField!
    @IBOutlet weak var privateSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if locFromSearch != "" {
            self.locatinSearchField.text = locFromSearch
        }
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
        eventEntity.setValue(self.locatinSearchField.text, forKey: "location")
        eventEntity.setValue(date, forKey: "date")
        eventEntity.setValue(key, forKey: "key")
        eventEntity.setValue(privateEvent, forKey: "privateEvent")
    }
    
    @IBAction func searchBtnHit(_ sender: Any) {
        self.performSegue(withIdentifier: "searchEventLocation", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? SearchViewController, segue.identifier == "searchEventLocation"{
            dest.searchId = "locations"
            dest.searchName = "Austin Locations:"
            dest.tstData = austinLocatins
        }
    }
}
