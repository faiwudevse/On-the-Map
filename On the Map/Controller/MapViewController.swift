//
//  MapViewController.swift
//  On the Map
//
//  Created by Fai Wu on 11/2/17.
//  Copyright © 2017 Fai Wu. All rights reserved.
//

import UIKit
import MapKit

// MARK: MapViewController: UIViewController, MKMapViewDelegate
class MapViewController: HelperViewController{
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadingView: UIView!
    
    // MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if animated {
            loadStudentsData()
        }
    }
    
    // MARK: LoadStudentsData
    // use client singleton to make get request to get 100 most recent location data
    func loadStudentsData() {
        if Reachability.isConnectedToNetwork(){
            self.setLoadingScreen()
            loadingView.isHidden = false
            Client.sharedInstance().getRecentStudentLocations(){(results, error) in
                if (error == nil) {
                    performUIUpdatesOnMain {
                        self.loadMapLocations(results!)
                        self.stopLoading()
                        self.loadingView.isHidden = true
                    }
                }
                else{
                    self.displayError("Error has occured for loaind the map data")
                }
            }
        }
        else{
            self.displayError("No Internet Connection")
        } 
    }
    private func displayError(_ error: String){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .`default`, handler: nil))
        let messageFont = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue", size: 15.0)!]
        let messageAttrString = NSMutableAttributedString(string: error, attributes: messageFont)
        alert.setValue(messageAttrString, forKey: "attributedMessage")
        self.present(alert, animated: true, completion: nil)
    }
}

extension MapViewController : MKMapViewDelegate{
    
    // MARK: loadMapLocations
    // load location data into mapview
    func loadMapLocations(_ studentLocations :[StudentLocation]) {
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        var annotations = [MKPointAnnotation]()
        
        for dict in studentLocations {
            let first = dict.firstName
            let last = dict.lastName
            let mediaURL = dict.mediaURL
            let lat = CLLocationDegrees(dict.latitude)
            let long = CLLocationDegrees(dict.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
    }
    
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
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!)
            }
        }
    }
}
