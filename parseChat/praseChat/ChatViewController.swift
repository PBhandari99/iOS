//
//  ChatViewController.swift
//  praseChat
//
//  Created by Prashant Bhandari on 2/23/17.
//  Copyright © 2017 Prashant Bhandari. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    var textArray: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // for the cell to autoresize
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // timer that calls the method that is assigned to it in certain interval
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ChatViewController.onTimer), userInfo: nil, repeats: true)
        onTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func sendButton(_ sender: Any) {
        let chatMessages = PFObject(className: "Message")
        chatMessages["text"] = messageTextField.text
        chatMessages["user"] = PFUser.current()
        chatMessages.saveInBackground(block: {(success: Bool?, error: Error?) in
            if success == true {
                self.onTimer()
                print ("Message saved:\(chatMessages["text"]!)")
            }
            else {
                print("Error: \(error)")
            }
        })
    }
    
    // called by the timer every 5 seconds
    func onTimer() {
        // Add code to be run periodically
        print("called")
        print ("*******************")
        print ("*******************")
        let queryObj = PFQuery(className: "Message")
        queryObj.whereKeyExists("text")
        queryObj.includeKey("user")
        queryObj.order(byDescending: "createdAt")
        queryObj.findObjectsInBackground { (respondArray: [PFObject]?, error: Error?) in
            if respondArray != nil {
                self.textArray = respondArray!
                self.tableView.reloadData()
                print("\(respondArray?[1].object(forKey: "user"))")
                let message = self.textArray?[3]
                let text = message?["text"] as! String
                print("\(text)")
                print ("\(self.textArray?[1])")
            }
            else {
                print ("Error occured while retriving message")
                print ("\(error)")
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let textArray = textArray {
            return textArray.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! chatCell
        cell.messageTextLabel.text = self.textArray?[indexPath.row].object(forKey: "text") as? String
        if let user = self.textArray?[indexPath.row].object(forKey: "user") as? PFUser {
            cell.userTextLabel.isHidden = false
            let username = user.username
            cell.userTextLabel.text = username
        }
        else {
            cell.userTextLabel.isHidden = true
        }
        return cell
    }

}
