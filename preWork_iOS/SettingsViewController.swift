//
//  SettingsViewController.swift
//  myTIp
//
//  Created by Prashant Bhandari on 12/20/16.
//  Copyright © 2016 Prashant Bhandari. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tipControlDefault: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
// save the selected index of the segment control.
    @IBAction func defaultTipChanged(_ sender: Any) {
        let defaultTipPercentage = tipControlDefault.selectedSegmentIndex
        let defaults = UserDefaults.standard
        defaults.set(defaultTipPercentage, forKey: "Default")
        
        defaults.synchronize()
    }
}
