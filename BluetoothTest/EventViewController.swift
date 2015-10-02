//
//  EventViewController.swift
//  BluetoothTest
//
//  Created by Julian Ferdman on 10/1/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    @IBOutlet weak var eventRegister: UIButton!
    @IBOutlet weak var eventIcon: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventSegment: UISegmentedControl!
    
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
    
    
    @IBAction func eventSegmentAction(sender: AnyObject) {
        if(eventSegment.selectedSegmentIndex == 0)
        {
             //PUT A LIST OF TIMES AND EVENTS/SPEAKERS HERE
        }
            
        else
            
            if(eventSegment.selectedSegmentIndex == 1)
                
            {
               
                //PUT A TWITTER FEED using the EVENT HASHTAG
            }
                
            else
                
                if(eventSegment.selectedSegmentIndex == 2)
                    
                {
                   
                    //LIST OF USERS FRIENDS WHO ARE ATTENDING (LinkedIn?)
        }
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
