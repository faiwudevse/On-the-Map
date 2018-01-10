//
//  PostLocationViewController.swift
//  On the Map
//
//  Created by Fai Wu on 11/10/17.
//  Copyright © 2017 Fai Wu. All rights reserved.
//

import UIKit
import CoreLocation
class AddLocationViewController: HelperViewController {
    
    // MARK: Outlets
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var urlLink: UITextField!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // set navigation title and bar button
        self.navigationController?.visibleViewController?.title = "Add Location"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancel))
        
        // assign textfield delegat to itself
        address.delegate = self
        urlLink.delegate = self
    }
    
    // MARK: Cancel
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: findLocation
    // use the address string geocdoing to the mape
    @IBAction func findLocation(_ sender: Any) {
        if address.text!.isEmpty {
            self.displayError("Location Not Found", "Must Enter a Location.")
            return
        }
        setLoadingScreen()
        let location = address.text!
        let url = urlLink.text!
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location){ (placemarks, error) in
            self.stopLoading()
            if(error != nil ) {
                self.displayError("Location Not Found", "Could Not Geocode the String.")
            }
            else{
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "SubmitLocationViewController") as! SubmitLocationViewController
                controller.placemark = placemarks?[0]
                controller.location = location
                controller.url = url
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
        
    }
    
}

extension AddLocationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        address.resignFirstResponder()
        urlLink.resignFirstResponder()
        return true
    }
}
