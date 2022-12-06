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

class CustomAnnot : MKPointAnnotation {
    var priv: Bool?
    var tag: Int?
}

class EventsViewController: UIViewController{

    @IBOutlet weak var lockBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolBar: UIToolbar!
    let locationManager = CLLocationManager()
    var data = [NSManagedObject]()
    var privateOnly:Bool = false
    
    override func viewWillAppear(_ animated: Bool){
        print("DARK MODE \(DarkMode.darkModeIsEnabled)")
        if DarkMode.darkModeIsEnabled == true{
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
        
        print("USER EVENTS ::")
        self.data = userEvents
        
        self.addEventsToMapView(privateOnly: false)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(EventsTableViewCell.nib(), forCellReuseIdentifier: EventsTableViewCell.id)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
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
    
    @IBAction func midBtnHit(_ sender: Any) {
        let mvc = storyBoard.instantiateViewController(withIdentifier: "middleVC") as! HomeViewController
        mvc.isModalInPresentation = true
        mvc.modalPresentationStyle = .fullScreen
        self.present(mvc, animated: false,completion: nil)
    }
    
    @IBAction func addEventBtnHit(_ sender: Any) {
        self.performSegue(withIdentifier: "createEventSeg", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = segue.destination as? CreateEventViewController, segue.identifier == "createEventSeg"{
            print("seg")
        }
    }
    
    @IBAction func lockBtnHit(_ sender: Any) {
        var temp = [NSManagedObject]()
       
        if self.privateOnly == false{
            self.lockBtn.setImage(UIImage(systemName: "person"), for: .normal)
            self.addEventsToMapView(privateOnly: true)
            for event in self.data {
                if event.value(forKey: "privateEvent") as! Bool == true {
                    temp.append(event)
                }
            }
            self.privateOnly = true
            self.data = temp
        }else{
            self.lockBtn.setImage(UIImage(systemName: "person.3"), for: .normal)
            self.data = userEvents
            self.addEventsToMapView(privateOnly: false)
            self.privateOnly = false
        }
        self.tableView.reloadData()
        self.mapView.reloadInputViews()
    }
    
    @IBAction func zoomInBtnHit(_ sender: Any) {
        self.mapView.setZoomByDelta(delta: 0.5, animated: true)
    }
    
    @IBAction func zoomOutBtnHit(_ sender: Any) {
        self.mapView.setZoomByDelta(delta: 2.0, animated: true)
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
    
    func addEventsToMapView(privateOnly:Bool) {
        self.mapView.removeAnnotations(self.mapView.annotations)
        var idx = 0
        for event in self.data {
            let priv = event.value(forKey: "privateEvent") as! Bool
            if privateOnly == true{
                if priv == false{
                    continue
                }
            }
            
            let pin = CustomAnnot()
            let lat = event.value(forKey: "lat") as! Double
            let long = event.value(forKey: "long") as! Double
            
            if priv == true{
                pin.priv = true
            }else{
                pin.priv = false
            }
            pin.tag = idx
            pin.title = event.value(forKey: "location") as? String
            pin.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            self.mapView.addAnnotation(pin)
            idx += 1
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

extension EventsViewController: MKMapViewDelegate,CLLocationManagerDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        var annotationView:MKAnnotationView?
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = true
            
        }else{
            annotationView?.annotation = annotation
        }
        
        var image:UIImage?
        if let annot = annotation as? CustomAnnot{
            if annot.priv == true {
                image = UIImage(systemName: "pin.fill")
            }else{
                image = UIImage(systemName: "pin")
            }
        }
        
        annotationView?.image = image!
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annot = view.annotation as? CustomAnnot {
            self.mapView.zoomToRegion(lat: annot.coordinate.latitude, long: annot.coordinate.longitude, NSdist: 10000.0, EWdist: 7000.0)
            
            let eventDescriptVC = storyBoard.instantiateViewController(withIdentifier: "eventDescriptVC") as! EventDescriptionViewController
            if let presentationController = eventDescriptVC.presentationController as? UISheetPresentationController {
                presentationController.detents = [.medium()]
            }
            eventDescriptVC.data = self.data[annot.tag!]
            self.present(eventDescriptVC, animated: true)
        }
    }
    
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
