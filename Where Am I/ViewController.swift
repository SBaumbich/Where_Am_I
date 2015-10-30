//
//  ViewController.swift
//  Where Am I
//
//  Created by Scott Baumbich on 10/29/15.
//  Copyright © 2015 Scott Baumbich. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    
    var locationManager = CLLocationManager()
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var course: UILabel!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var Altitude: UILabel!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let userLocation: CLLocation = locations[0]
        let lat = userLocation.coordinate.latitude
        let lon = userLocation.coordinate.longitude
        let latDelta: CLLocationDegrees = 0.008//Zoom width level
        let lonDelta: CLLocationDegrees = 0.008 // Zoom Height level
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "My Location"
        map.addAnnotation(annotation)
        
        latitude.text = String(userLocation.coordinate.latitude)
        longitude.text = String(userLocation.coordinate.longitude)
        course.text = String(userLocation.course)
        speed.text = String(userLocation.speed)
        Altitude.text = String(userLocation.altitude)
        CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarks, error) -> Void in
            
            if error != nil {
                print(error)
            } else {
                let p = placemarks?.first
                let subThoroughfare = p?.subThoroughfare != nil ? p?.subThoroughfare : ""
                let thoroughfare = p?.thoroughfare != nil ? p?.thoroughfare : ""
                let country = p?.country != nil ? p?.country : ""
                let postal = p?.postalCode != nil ? p?.postalCode : ""
                let city = p?.locality != nil ? p?.locality : ""
                let state = p?.administrativeArea != nil ? p?.administrativeArea : ""
                
                self.location.text = "\(subThoroughfare!) \(thoroughfare!) \n \(city!), \(state!) \n \(country!) \(postal!)"
            }
        }
    }
}




