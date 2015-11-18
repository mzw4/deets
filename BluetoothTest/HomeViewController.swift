//
//  HomeViewController.swift
//  BluetoothTest
//
//  Created by Vivek Sudarsan on 10/12/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import UIKit
import SnapKit
import Firebase



class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var eventTable = UITableView()
    let dragOffset: CGFloat = 180.0
    var topRow = 0
    var expanded = true
    var rowToSelect = 0
    var rowTapped = 0
    var eventSelected: String = ""
    
//    var sampleEvents = ["Entrepreneurs Meetup", "Hilton Networking Event", "VC Meet & Greet", "Cornell Tech Meetup", "Comic Con: San Diego","Cornell Career Fair"]
//    var eventImages = ["event.jpg","event2.jpg","event3.jpg","event4.jpg","event5.png","event.jpg"]
//    var dates = ["10/25/2015","11/04/2015","11/11/2015","12/14/2015","12/16/2015","01/12/2015"]
//    var locations = ["Javits Center","New York Hilton Midtown","W. Hotel Midtown West","Cornell Tech NYC","San Diego Convention Center","Cornell Tech NYC"]

    var dateFormatter = NSDateFormatter()
    var firstLaunch = true
    var initialLoadFinished = false
    
    // Retrieve data for all events
    func populateEventInfo() {
        DataHandler.getAllEvents({ snapshot in
            let eventInfo: [String: AnyObject] = snapshot.value as! [String : AnyObject]
            
            let event = Event()
            event.name = String(eventInfo["name"]!)
            event.location = String(eventInfo["location"]!)
            event.startDate = NSDate(timeIntervalSince1970: eventInfo["startDate"] as! Double)
            event.endDate = NSDate(timeIntervalSince1970: eventInfo["endDate"] as! Double)
            event.company = String(eventInfo["company"]!)
            event.description = String(eventInfo["description"]!)
            event.eventPhoto = String(eventInfo["eventPhoto"]!)
            
            EventManager.events.append(event)
            EventManager.eventsDict[snapshot.key] = event
            self.eventTable.reloadData()
            print(event.name)
        })

    }
    
    func getConnectionRequests() {
        DataHandler.getConnectionRequests(User.currentUser.userId, completion: { connections in
            print("got connection requests \(connections.count)")
            ConnectionRequestManager.connectionRequests = connections
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()

        // TEMP, CREATE DB ENTRIES
//        makeEvents()
//        DBScripts.makeUsers()
//        DBScripts.makeConnectionRequests()
        // END TEMP
        
        populateEventInfo()
        getConnectionRequests()
        styleView()

        
        // Set date formatter
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        // Style navigation bar
        navigationItem.title = "My Events"
        navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "Modal")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "user.png"), landscapeImagePhone: UIImage(named: "user.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "presentProfile:")
        
        // Set back button with no text
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)

        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        tabBarController?.tabBar.barStyle = UIBarStyle.Black
        tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        
        self.automaticallyAdjustsScrollViewInsets = true
    }
    
    func presentProfile(sender: UIBarButtonItem!) {
        ProfileViewController.userIdShow = User.currentUser.userId
        navigationController?.pushViewController(ProfileViewController(), animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if BeaconStarted.beacon.started == false{
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "Modal")
        }else{
            let icon = UIImage(named: "Radar4")
            let iconSize = CGRect(origin: CGPointZero, size: icon!.size)
            let iconButton = UIButton(frame: iconSize)
            iconButton.setBackgroundImage(icon, forState: .Normal)
            navigationItem.rightBarButtonItem!.customView = iconButton
            navigationItem.rightBarButtonItem!.customView!.rotate360Degrees()
            iconButton.addTarget(self, action: "Modal", forControlEvents: .TouchUpInside)
        }
    }
    
    
    func styleView() {
        view.addSubview(eventTable)
        eventTable.backgroundColor = UIColor.clearColor()
        eventTable.separatorColor = UIColor(white: 1.0, alpha: 0.2)
        eventTable.separatorInset = UIEdgeInsetsZero
        eventTable.layoutMargins = UIEdgeInsetsZero
        eventTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        eventTable.dataSource = self
        eventTable.delegate = self
        eventTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
        eventTable.snp_makeConstraints { (make) -> Void in
                make.centerX.equalTo(view.snp_centerX)
                make.centerY.equalTo(view.snp_centerY)
                make.width.equalTo(view.snp_width)
                make.height.equalTo(view.snp_height)
        }
    
        eventTable.rowHeight = UITableViewAutomaticDimension
        eventTable.estimatedRowHeight = 100
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel!.text = EventManager.events[indexPath.row].name
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont.systemFontOfSize(20, weight: UIFontWeightLight)
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero

        let dateLabel = UILabel(frame: CGRectMake(16, 170, view.frame.width/2, 30))
        let locationIcon = UIImageView(frame: CGRectMake(13, 137, 20, 20))
        let imageView = UIImageView(frame: CGRectMake(0, -20, view.frame.width, 245))
        let shadowView = UIImageView(frame: CGRectMake(0, 0, view.frame.width, 225))
        let locationLabel = UILabel(frame: CGRectMake(40, 134, view.frame.width-50, 30))

        imageView.image = UIImage(named: EventManager.events[indexPath.row].eventPhoto)
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        shadowView.image = UIImage(named: "shadow.png")
        shadowView.contentMode = UIViewContentMode.ScaleAspectFill
        shadowView.clipsToBounds = true
        dateLabel.textColor = UIColor.whiteColor()
        dateLabel.font = UIFont.systemFontOfSize(15, weight: UIFontWeightLight)
        
        dateLabel.text = dateFormatter.stringFromDate(EventManager.events[indexPath.row].startDate)
        locationIcon.image = UIImage(named: "location.png")
        locationIcon.contentMode = UIViewContentMode.ScaleAspectFit
        locationLabel.text = EventManager.events[indexPath.row].location
        locationLabel.font = UIFont.systemFontOfSize(17, weight: UIFontWeightRegular)
        locationLabel.textColor = UIColor.whiteColor()
        
        cell.clipsToBounds = true
        cell.backgroundView = UIView()
        cell.backgroundView!.alpha = 0.13
        cell.textLabel?.alpha = 0.5
        cell.backgroundView!.addSubview(imageView)
        cell.backgroundView!.addSubview(shadowView)
        cell.backgroundView!.addSubview(dateLabel)
        cell.backgroundView!.addSubview(locationIcon)
        cell.backgroundView!.addSubview(locationLabel)
        cell.backgroundView?.clipsToBounds = true
        
        var alreadyCompleted = 0
        
        if indexPath.row == 0 && firstLaunch == true{
            if alreadyCompleted == 0{
                cell.backgroundView?.alpha = 0.7
                cell.textLabel?.font = UIFont.systemFontOfSize(25, weight: UIFontWeightRegular)
                cell.textLabel?.alpha = 1.0
                cell.selected = true
                firstLaunch = false
                alreadyCompleted = 1
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        rowToSelect = indexPath.row
        rowTapped += 1
        print(rowTapped)
        if rowTapped == 2{
            EventChosen.events.eventSelected = EventManager.events[indexPath.row].name
            EventChosen.events.eventImage = EventManager.events[indexPath.row].eventPhoto
            EventChosen.events.eventAddress = EventManager.events[indexPath.row].location
            loadEvent()

            rowTapped = 0
        }
        
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.backgroundView!.alpha = 0.7
        selectedCell.textLabel?.font = UIFont.systemFontOfSize(25, weight: UIFontWeightRegular)
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            selectedCell.textLabel?.alpha = 1.0
            }, completion: nil)
        
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: rowToSelect, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.None)
        
        if indexPath.row != 0{
            self.tableView(self.eventTable, didDeselectRowAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))
            rowTapped = 1
        }
        
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let deselectedCell:UITableViewCell? = tableView.cellForRowAtIndexPath(indexPath)
        
        deselectedCell?.backgroundView!.alpha = 0.13
        deselectedCell?.textLabel?.font = UIFont.systemFontOfSize(20, weight: UIFontWeightLight)
        deselectedCell?.textLabel?.alpha = 0.5
        
        rowTapped = 0
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        if indexPath.row == rowToSelect {
            return 225
        }else{
            return 100
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventManager.events.count
    }
    
    func loadEvent(){
        let destination = EventDetailsViewController()
        navigationController?.pushViewController(destination, animated: true)
    }
    
    func Modal(){
        presentViewController(ViewController(), animated: true, completion: nil)
    }

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }


}
