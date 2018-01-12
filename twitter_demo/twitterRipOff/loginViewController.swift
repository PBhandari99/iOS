//
//  loginViewController.swift
//  twitterDemo
//
//  Created by Prashant Bhandari on 2/26/17.
//  Copyright © 2017 Prashant Bhandari. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class loginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        twitterClient.sharedClient?.login(success: {() -> () in
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            print("Logged in")
        }, error: { (error: Error) in
            print("error: \(error.localizedDescription)")
        })
    }
}
