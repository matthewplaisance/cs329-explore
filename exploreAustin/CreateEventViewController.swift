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

class CreateEventViewController: UIViewController,MKMapViewDelegate,UISearchBarDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var eventDate: UIDatePicker!
    
    let locationManager = CLLocationManager()
    var eventLocation:String?
    var lat:Double?
    var long:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        
        //self.locationManager.delegate = self
        //self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //self.locationManager.requestWhenInUseAuthorization()
        //self.locationManager.requestLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if DarkMode.darkModeIsEnabled == true{
            overrideUserInterfaceStyle = .dark
        }else{
            
        }
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
                
                self.lat = lat
                self.long = long
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
    
    @IBAction func nextBtnHit(_ sender: Any) {
        self.performSegue(withIdentifier: "finalizeEventSeg", sender: self)
    }
    
    @IBAction func zoomInHit(_ sender: Any) {
        self.mapView.setZoomByDelta(delta: 2.0, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? FinalizeEventViewController, segue.identifier == "finalizeEventSeg"{
            dest.eventLocation = self.eventLocation
            dest.eventDate = self.eventDate.date
            dest.lat = self.lat
            dest.long = self.long
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
