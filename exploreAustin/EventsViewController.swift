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
import SwiftUI

class EventsViewController: UIViewController{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var data = [NSManagedObject]()//cant really remember why I decided to use dictionaries for the dat on other pages... but dont fix what aint broke
    
    override func viewWillAppear(_ animated: Bool){
        print("DARK MODE \(DarkMode.darkModeIsEnabled)")
        if DarkMode.darkModeIsEnabled == true{
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
        
        print("USER EVENTS ::")
        self.data = userEvents
        for event in self.data {
            print("loc: \(event.value(forKey: "location"))")
        }
        self.addEventsToMapView()
        self.tableView.reloadData()
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        self.mapView.addGestureRecognizer(leftSwipe)
        self.tableView.addGestureRecognizer(leftSwipe)
        self.mapView.addGestureRecognizer(rightSwipe)
        self.tableView.addGestureRecognizer(rightSwipe)
        self.toolBar.addGestureRecognizer(rightSwipe)
        self.toolBar.addGestureRecognizer(leftSwipe)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(EventsTableViewCell.nib(), forCellReuseIdentifier: EventsTableViewCell.id)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
    }
    

    @IBAction func addEventBtnHit(_ sender: Any) {
        self.performSegue(withIdentifier: "createEventSeg", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = segue.destination as? CreateEventViewController, segue.identifier == "createEventSeg"{
            print("seg")
        }
    }
    
    
    @IBAction func profileBtnHit(_ sender: Any) {
        let pageVC = storyBoard.instantiateViewController(withIdentifier: "pageVC") as! PageViewController
        pageVC.isModalInPresentation = true
        pageVC.modalPresentationStyle = .fullScreen
        pageVC.userPage = currUid!
        self.present(pageVC, animated: false,completion: nil)
    }
    
    
    @IBAction func homeBtnHit(_ sender: Any) {
        let feedVC = storyBoard.instantiateViewController(withIdentifier: "feedVC") as! FeedViewController
        feedVC.isModalInPresentation = true
        feedVC.modalPresentationStyle = .fullScreen
        
        self.present(feedVC, animated:true, completion:nil)
    }
    
    func addEventsToMapView() {
        for event in self.data {
            let pin = MKPointAnnotation()
            let lat = event.value(forKey: "lat") as! Double
            let long = event.value(forKey: "long") as! Double
            
            pin.title = event.value(forKey: "location") as? String
            pin.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            self.mapView.addAnnotation(pin)
        }
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer)
    {
        if sender.direction == .left
        {
            print("right")
            let pageVC = storyBoard.instantiateViewController(withIdentifier: "pageVC") as! PageViewController
            
            pageVC.isModalInPresentation = true
            pageVC.modalPresentationStyle = .fullScreen
            pageVC.modalTransitionStyle = .crossDissolve
            self.present(pageVC, animated:true, completion:nil)
        }

        if sender.direction == .right//move left on toolbar
        {
            //
        }
    }
    
}

struct CustomPrimaryView: View {
    @Environment(\.colorScheme)
    var colorScheme
    var body: some View {
        colorScheme == .light ?
            Color(red: 0.1, green: 0.1, blue: 0.1) :
            Color(red: 0.95, green: 0.95, blue: 0.95)
    }
}

extension EventsViewController: MKMapViewDelegate {
    
}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventsTableViewCell.id, for: indexPath) as! EventsTableViewCell
        let row = indexPath.row
        
        let loc = self.data[row].value(forKey: "location") as! String
        let date = self.data[row].value(forKey: "date") as! String
        let names = self.data[row].value(forKey: "participantsNames") as? Substring
        let ownersNames = names?.split(separator: "//")[0]
        
        cell.loctionDateLabel.text = "\(loc) :: \(date)"
        cell.ownerLabel.text = "By: \(ownersNames!)"
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventDescriptVC = storyBoard.instantiateViewController(withIdentifier: "eventDescriptVC") as! EventDescriptionViewController
        
        if let presentationController = eventDescriptVC.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
        eventDescriptVC.data = self.data[indexPath.row]
        
        self.present(eventDescriptVC, animated: true)
    }
}
