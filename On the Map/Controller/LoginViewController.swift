//
//  ViewController.swift
//  On the Map
//
//  Created by Fai Wu on 10/26/17.
//  Copyright © 2017 Fai Wu. All rights reserved.
//

import UIKit
// MARK: LoginViewController: UIViewController
class LoginViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: LoginPressd
    @IBAction func loginButton(_ sender: Any) {
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            self.displayError("Empty Email or Passsword")
        }
        else{
            if Reachability.isConnectedToNetwork(){
                Client.sharedInstance().authenticateUserLogin(emailTextField.text!, passwordTextField.text!) { (success, error) in
                    performUIUpdatesOnMain {
                        if success {
                            self.emailTextField.text = ""
                            self.passwordTextField.text = ""
                            self.completeLogin()
                        } else {
                            self.displayError("Wrong email or password")
                        }
                    }
                }
            }
            else{
                displayError("Internet connection Failed")
            }
        }
    }
    
    // MARK: Login
    private func completeLogin(){
        let controller = storyboard!.instantiateViewController(withIdentifier: "NavigationController") 
        present(controller, animated: true, completion: nil)
        
    }
    
    // MARK: SignUp
    @IBAction func signupButton(_ sender: Any) {
        if let url = URL(string: "https://www.udacity.com/account/auth#!/signup"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
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

extension LoginViewController: UITextFieldDelegate{
    // MARK: textFieldShouldReturn
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        return true
    }
}
