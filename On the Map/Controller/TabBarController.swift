//
//  TabBarController.swift
//  On the Map
//
//  Created by Fai Wu on 11/1/17.
//  Copyright © 2017 Fai Wu. All rights reserved.
//

import UIKit
// MAKR: TabBarController: UITabBarController
class TabBarController: UITabBarController {
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // set up the navigation title
        self.navigationController?.visibleViewController?.title = "On the Map"
        
        // set up the left bar buttonItem
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logout))
        
        // set up the right bar buttonItem
        let refreshImg = UIImage(named: "icon_refresh")
        let refreshButton = UIBarButtonItem(image: refreshImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector(refreshLocation))
        let postImg = UIImage(named: "icon_addpin")
        let postButton = UIBarButtonItem(image: postImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector(postLocation))
        self.navigationItem.rightBarButtonItems = [postButton, refreshButton]
    }
    
    // MARK: Logout
    @objc func logout() {
        Client.sharedInstance().userLogout() { (success, error) in
            performUIUpdatesOnMain {
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.displayError(error!)
                }
            }
        }
    }
    
    // MARK: Refresh
    @objc func refreshLocation(){
        self.selectedViewController?.viewWillAppear(true)
    }
    
    // MARK: Post A new Location
    @objc func postLocation(){
        let controller = storyboard!.instantiateViewController(withIdentifier: "AddLocationNavigationController")
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(controller, animated: false, completion: nil)
    }
    
    // MARK: DisplayError
    private func displayError(_ error: String){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .`default`, handler: nil))
        let messageFont = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue", size: 15.0)!]
        let messageAttrString = NSMutableAttributedString(string: error, attributes: messageFont)
        alert.setValue(messageAttrString, forKey: "attributedMessage")
        self.present(alert, animated: true, completion: nil)
    }
    
}
