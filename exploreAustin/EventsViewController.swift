//
//  EventsViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/19/22.
//

import UIKit

class EventsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var addEventBtn: UIButton!
    @IBOutlet weak var eventsTableView: UITableView!
    
    var data = [Dictionary<String,Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTableView.register(EventsTableViewCell.nib(), forCellReuseIdentifier: EventsTableViewCell.id)
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventsTableView.dequeueReusableCell(withIdentifier: EventsTableViewCell.id, for: indexPath) as! EventsTableViewCell
        let row = indexPath.row
        
        
        return cell
    }

    @IBAction func addEventHit(_ sender: Any) {
        let createVC = storyBoard.instantiateViewController(withIdentifier: "createEventVC") as! CreateEventViewController
        self.present(createVC, animated: true)
    }
}
