//
//  loginViewController.swift
//  InstagramDemo
//
//  Created by Prashant Bhandari on 3/14/17.
//  Copyright © 2017 Prashant Bhandari. All rights reserved.
//

import UIKit
import Parse

class loginViewController: UIViewController {
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func loginButton(_ sender: Any) {
        let userInfo: [String:String] = ["username" : userNameText.text!, "password" : passwordText.text!]
        let user = User(userInfo: userInfo as NSDictionary)
        User.currentUser = user
        PFUser.logInWithUsername(inBackground: "\(userNameText.text!)", password: "\(passwordText.text!)") { (User: PFUser?, error: Error?) in
            if User != nil {
                print("successfully logedin")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            else {
                print((error?.localizedDescription)!)
                let errorMessage = error?.localizedDescription
                let alertController = UIAlertController(title: "Oops!", message: "\(errorMessage)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        let newUser = PFUser()
        newUser.username = userNameText.text
        newUser.password = passwordText.text
        newUser.signUpInBackground { (success :Bool, error :Error?) in
            if let error = error {
                print(error.localizedDescription)
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
}
