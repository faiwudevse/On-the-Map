//
//  SubmitLocationViewController.swift
//  On the Map
//
//  Created by Fai Wu on 11/10/17.
//  Copyright © 2017 Fai Wu. All rights reserved.
//

import UIKit
import MapKit
class SubmitLocationViewController: HelperViewController {
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Properties
    var placemark: CLPlacemark?
    var location: String?
    var url: String?
    
    // MARK: Life cycle
    // Load the mape data
    override func viewDidLoad() {
        super.viewDidLoad()
        let coordinates:CLLocationCoordinate2D = placemark!.location!.coordinate
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinates, span)
        let pointAnnotation:MKPointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinates
        self.mapView.addAnnotation(pointAnnotation)
        self.mapView.centerCoordinate = coordinates
        self.mapView.setRegion(region, animated: true)
        self.mapView.selectAnnotation(pointAnnotation, animated: true)
    }
    
    // MARK: submitLocation
    // make a post request to post the user location
    @IBAction func submitLocation(_ sender: Any) {
        if Reachability.isConnectedToNetwork(){
            Client.sharedInstance().postAStudentLocation(location!, url!, (placemark?.location?.coordinate.latitude)!, (placemark?.location?.coordinate.longitude)!){(success, error) in
                if success{
                    self.dismiss(animated: true, completion: nil)
                }
                else{
                    self.displayError("Location Posting Fail", "Failed to Update Location.")
                }
            }
        }else{
            self.displayError("Location Not Found", "Failed to Update Location.")
        }
    }
}

extension SubmitLocationViewController : MKMapViewDelegate {
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}
