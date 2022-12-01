//
//  EventsViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/19/22.
//

import UIKit
import MapKit
import CoreData
import CoreLocation

class EventsViewController: UIViewController{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    var data = [Dictionary<String,Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(EventsTableViewCell.nib(), forCellReuseIdentifier: EventsTableViewCell.id)
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventsTableViewCell.id, for: indexPath) as! EventsTableViewCell
        let row = indexPath.row
        
        
        return cell
    }

    @IBAction func addEventBtnHit(_ sender: Any) {
        self.performSegue(withIdentifier: "createEventSeg", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? CreateEventViewController, segue.identifier == "createEventSeg"{
            print("seg")
        }
    }
    
}

extension EventsViewController: MKMapViewDelegate {
    
}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    
}
