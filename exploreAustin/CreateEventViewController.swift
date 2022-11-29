//
//  CreateEventViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/27/22.
//

import UIKit
import MapKit
import CoreData
import CoreLocation

var locFromSearch = ""

class CreateEventViewController: UIViewController,MKMapViewDelegate,UISearchBarDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventData: UIDatePicker!
    
    let locationManager = CLLocationManager()
    var eventLocation:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        let userLocation = mapView.userLocation
        let c = userLocation.location?.coordinate
        print("user location: \(c)")
        let center = CLLocationCoordinate2D(latitude: 30.2672, longitude: -97.7431)
        
        let NSdist = 10000.0
        let EWdist = 6000.0
        
        let region = MKCoordinateRegion(
            center: center,
            latitudinalMeters: NSdist,
            longitudinalMeters: EWdist)
        self.mapView.setRegion(region, animated: true)
        if locFromSearch != "" {
            //self.locatinSearchField.text = locFromSearch
        }
    }
    
    
    @IBAction func searchBtnHit(_ sender: Any) {
        let searchContr = UISearchController(searchResultsController: nil)
        searchContr.searchBar.delegate = self
        present(searchContr,animated: true,completion: nil)
    
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.mapView.isUserInteractionEnabled = false
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.mapView.addSubview(activityIndicator)
        
        //hide
        searchBar.resignFirstResponder()
        dismiss(animated: true)
        
        //search request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { res, err in
            if let response = res{
                let lat = response.boundingRegion.center.latitude
                let long = response.boundingRegion.center.longitude
                
                //remove pervious searchs
                let annots = self.mapView.annotations
                self.mapView.removeAnnotations(annots)
                
                //res annotation
                let pin = MKPointAnnotation()
                pin.title = searchBar.text
                pin.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                self.mapView.addAnnotation(pin)
                self.eventLocation = searchBar.text
                //zoom into pin
                self.mapView.zoomToRegion(lat: lat, long: long, NSdist: 3000.0, EWdist: 2000.0)
                
            }else{
                print("error: \(err!)")
            }
        }
        
        self.mapView.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
    }
    
    @IBAction func zoomOutHit(_ sender: Any) {//wrong names
        self.mapView.setZoomByDelta(delta: 0.5, animated: true)
    }
    
    
    @IBAction func zoomInHit(_ sender: Any) {
        self.mapView.setZoomByDelta(delta: 2.0, animated: true)
    }
    
    @IBAction func createEventBtnHit(_ sender: Any) {
        print(self.eventData.date)
        let date = customDataFormat(date: self.eventData.date, long: true)
        let key = Date().timeIntervalSince1970
        var privateEvent = false
        
        print("d: \(date)")
        
        let eventEntity = NSEntityDescription.insertNewObject(forEntityName: "Event", into: context)
        
        eventEntity.setValue(currUid, forKey: "owner")
        //eventEntity.setValue(self.locatinSearchField.text, forKey: "location")
        eventEntity.setValue(date, forKey: "date")
        eventEntity.setValue(key, forKey: "key")
        eventEntity.setValue(privateEvent, forKey: "privateEvent")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? SearchUsersViewController, segue.identifier == "searchEventLocation"{
            dest.searchId = "locations"
            dest.searchName = "Austin Locations:"
            dest.searchData = austinLocatins
        }
    }
}

extension MKMapView {

    // delta is the zoom factor
    // 2 will zoom out x2
    // .5 will zoom in by x2

    func setZoomByDelta(delta: Double, animated: Bool) {
        var _region = region;
        var _span = region.span;
        _span.latitudeDelta *= delta;
        _span.longitudeDelta *= delta;
        _region.span = _span;

        setRegion(_region, animated: animated)
    }
    
    func zoomToRegion(lat:Double,long:Double,NSdist:Double,EWdist:Double){
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: lat, longitude: long),
            latitudinalMeters: NSdist,
            longitudinalMeters: EWdist)
        
        setRegion(region, animated: true)
    }
}
