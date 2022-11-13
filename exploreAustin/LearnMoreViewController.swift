//
//  LearnMoreViewController.swift
//  exploreAustin
//
//  Created by Robert Binning on 11/3/22.
//

import UIKit
import MapKit

class LearnMoreViewController: UIViewController {
    var delegate: UIViewController!
    var learnMoreTitle : String!
    var descriptionTextString: String = ""
    var coordinatePairs : (Double, Double)!
    

    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var descriptionText: UITextView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        mapSetup()
        if DarkMode.darkModeIsEnabled == true{
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    func mapSetup(){
        let (lat, long) = coordinatePairs
        let coordinates = CLLocationCoordinate2D.init(latitude: lat, longitude: long)
        let annotation = MKPointAnnotation()
        annotation.title = learnMoreTitle
        annotation.coordinate = coordinates
        titleLabel.text = learnMoreTitle
        descriptionText.text = descriptionTextString
        mapView.isZoomEnabled = true
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.isScrollEnabled = true
        mapView.addAnnotation(annotation)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
