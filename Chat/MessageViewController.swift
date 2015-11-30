//
//  MessageViewController.swift
//  Chat
//
//  Created by Salyards, Adey on 11/29/15.
//  Copyright © 2015 Salyards, Adey. All rights reserved.
//

import UIKit
import Parse

class MessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageField: UITextField!
    
    var messages: [PFObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages = []
        
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "fetchMessages", userInfo: nil, repeats: true)
        fetchMessages()
        // Do any additional setup after loading the view.
    }
    
    func fetchMessages() {
        let query = PFQuery(className: "Message")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            print(objects)
            
            self.messages = objects
            self.tableView.reloadData()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressSendButton(sender: AnyObject) {
        let message = PFObject(className: "Message")
        
        message["text"] = messageField.text
        
        message.saveInBackgroundWithBlock { (result: Bool, error: NSError?) -> Void in
            print ("Message saved!")
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell") as! MessageCell
        
        let message = messages[indexPath.row]
        
        cell.messageLabel.text = message["text"] as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
        
        return messages.count
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
