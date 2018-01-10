//
//  ListTableTableViewController.swift
//  On the Map
//
//  Created by Fai Wu on 11/2/17.
//  Copyright © 2017 Fai Wu. All rights reserved.
//

import UIKit

class ListTableTableViewController: HelperViewController {
    @IBOutlet var tableView: UITableView!
    
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
            Client.sharedInstance().getRecentStudentLocations(){(results, error) in
                if (error == nil) {
                    performUIUpdatesOnMain {
                        self.tableView.reloadData()
                        self.stopLoading()
                    }
                }
                else{
                    self.displayError("", "Error has occured for loaind the map data")
                }
            }
        }
        else{
            self.displayError("", "No Internet Connection")
        }
    }
    
}

extension ListTableTableViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Client.sharedInstance().studentLocationsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let studentLocations = Client.sharedInstance().studentLocationsData
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        // Configure the cell...
        let studentLocation = studentLocations[(indexPath as NSIndexPath).row]
        
        let first = studentLocation.firstName
        let last = studentLocation.lastName
        let mediaURL = studentLocation.mediaURL
        
        cell.imageView?.image = UIImage(named: "icon_pin")
        cell.textLabel?.text = first + " " + last
        cell.detailTextLabel?.text = mediaURL
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocations = Client.sharedInstance().studentLocationsData
        let mediaURL = studentLocations[(indexPath as NSIndexPath).row].mediaURL
        
        if let url = URL(string: mediaURL){
            if UIApplication.shared.canOpenURL(url){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }else{
                displayError("","Invalid URL")
            }
        }
        
    }
}
