//
//  EventViewController.swift
//  BluetoothTest
//
//  Created by Julian Ferdman on 10/1/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import Firebase

class EventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var eventIcon: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventSegment: UISegmentedControl!

    //let FirebaseRef = Firebase(url:"https://fiery-heat-4470.firebaseio.com/")
    //let eventsRef = Firebase(url:"https://fiery-heat-4470.firebaseio.com/events")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventIcon.layer.cornerRadius = self.eventIcon.frame.size.width / 2;
        self.eventIcon.clipsToBounds = true;
        self.eventIcon.layer.borderWidth = 3.0;
        self.eventIcon.layer.borderColor = UIColor.whiteColor().CGColor;
        
        
        /* PROGRAMATICALLY
        eventSegment = UISegmentedControl (items: ["Program","Activity","Network"])
        eventSegment.frame = CGRectMake(60, 250,200, 30)
        eventSegment.selectedSegmentIndex = 0
        eventSegment.addTarget(self, action: "seventSegmentAction:", forControlEvents: .ValueChanged)
        self.view.addSubview(eventSegment)
        */

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0

    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let myCell = tableView.dequeueReusableCellWithIdentifier("calendar");
        return myCell!;
    }
    
    @IBAction func registerButton(sender: AnyObject) {
        
    }
    
    @IBAction func eventSegmentAction(sender: AnyObject) {
        if(eventSegment.selectedSegmentIndex == 0)
        {
            retrieveEventData()
        }
            
        else
            
            if(eventSegment.selectedSegmentIndex == 1)
            {
               
            }
                
            else
                
                if(eventSegment.selectedSegmentIndex == 2)
                {
                    
                }
    }

    func retrieveEventData() -> Array<AnyObject>{
        
        return ["0"] //Pull data from Firebase
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
