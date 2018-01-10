//
//  HelperViewController.swift
//  On the Map
//
//  Created by Fai Wu on 11/15/17.
//  Copyright © 2017 Fai Wu. All rights reserved.
//

import UIKit

class HelperViewController: UIViewController {
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    // MARK: SetLoadingScreen
    func setLoadingScreen() {
        // configure the loading view and activity indicator
        self.view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.black
        let horizontalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        self.view.addConstraint(horizontalConstraint)
        let verticalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        self.view.addConstraint(verticalConstraint)
        activityIndicator.startAnimating()
    }
    
    // MARK: StopLoading
    func stopLoading() {
        // stop loading
        activityIndicator.stopAnimating()
    }
    
    // MARK: displayError
    func displayError(_ title: String,_ error: String){
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .`default`, handler: nil))
        let messageFont = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue", size: 15.0)!]
        let messageAttrString = NSMutableAttributedString(string: error, attributes: messageFont)
        alert.setValue(messageAttrString, forKey: "attributedMessage")
        self.present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
