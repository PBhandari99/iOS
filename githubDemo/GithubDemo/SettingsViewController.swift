//
//  SettingsViewController.swift
//  GithubDemo
//
//  Created by Prashant Bhandari on 3/3/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var numberOfStarLabel: UILabel!
    
    weak var delegate: SettingsPresentingViewControllerDelegate?
    
    var minSettings: GithubRepoSearchSettings?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingSlider.minimumValue = 0.0
        ratingSlider.maximumValue = 10000.0
        ratingSlider.value = Float((minSettings?.minStars)!)
        numberOfStarLabel.text = "\((minSettings?.minStars)!)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func ratingSliderAction(_ sender: Any) {
        minSettings?.minStars = Int(ratingSlider.value)
        numberOfStarLabel.text = "\(Int(ratingSlider.value))"
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        let setting = minSettings
        self.delegate?.didSaveSettings(settings: setting!)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.delegate?.didCancelSettings()
        dismiss(animated: true, completion: nil)
    }
}

// To communicate the settings from the SearchSettingsViewController back to the RepoResultsViewController, we'll use the delegate pattern and create a protocol:
protocol SettingsPresentingViewControllerDelegate: class {
    func didSaveSettings(settings: GithubRepoSearchSettings)
    func didCancelSettings()
}

