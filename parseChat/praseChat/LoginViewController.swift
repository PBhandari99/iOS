//
//  LoginViewController.swift
//  praseChat
//
//  Created by Prashant Bhandari on 2/23/17.
//  Copyright © 2017 Prashant Bhandari. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func userSignUp(_ sender: UIButton) {
        let newUser = PFUser()
        newUser.username = userNameLabel.text
        newUser.email = emailLabel.text
        newUser.password = passwordLabel.text
        
        newUser.signUpInBackground {(succeeded: Bool, error: Error?)-> Void in
            if let error = error {
                let errorMessage = error.localizedDescription
                let alertController = UIAlertController(title: "Oops!", message: "\(errorMessage)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else {
                print("success")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    @IBAction func userLogIn(_ sender: UIButton) {
        PFUser.logInWithUsername(inBackground: "\(userNameLabel.text!)", password: "\(passwordLabel.text!)") { (user: PFUser?, error: Error?) -> Void in
            if user != nil {
                 print ("successfully loged in.")
                 self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            else {
                print("Error: \(error?.localizedDescription)")
                let alertController = UIAlertController(title: "Login Failed", message: "Invalid Username/Password", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
