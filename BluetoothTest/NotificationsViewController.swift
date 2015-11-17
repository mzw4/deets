//
//  NotificationsViewController.swift
//  BluetoothTest
//
//  Created by Mike Wang on 10/26/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import UIKit

class NotificationsViewController: UIPageViewController, UITableViewDelegate, UITableViewDataSource {

    var sampleConnectionRequests = [
        ["name": "Jaime Lanister", "profilePic": "jaime.png", "date": "5/5/15", "location": "King's Landing Pregame"],
        ["name": "Little Finger", "profilePic": "littlefinger.png", "date": "1/2/34", "location": "King's Landing Pregame"],
        ["name": "Daenerys Targaryen", "profilePic": "daenerys.png", "date": "7/7/15", "location": "King's Landing Pregame"]]
    
    var connectionsTable = UITableView()
    var cellToHide: Int?
    var numCells = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        
//        let uid = NSUserDefaults.standardUserDefaults().stringForKey("userId")!
//        DataHandler.getConnectionRequests(uid, completion: { (snapshot) in
//            print(snapshot)
//        })
        
        // Style navigation bar
        navigationItem.title = "Notifications"
        navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        // Set back button with no text
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
//        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
//        tabBarController?.tabBar.barStyle = UIBarStyle.Black
//        tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        
        self.automaticallyAdjustsScrollViewInsets = true
    }
    
    func handleAccept(sender: UIButton) {
        connectionsTable.beginUpdates()
        sampleConnectionRequests.removeAtIndex(sender.tag)
        connectionsTable.deleteRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: .Right)
        connectionsTable.endUpdates()
    }
    
    func handleReject(sender: UIButton) {
        connectionsTable.beginUpdates()
        sampleConnectionRequests.removeAtIndex(sender.tag)
        connectionsTable.deleteRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: .Left)
        connectionsTable.endUpdates()
    }
    
    func createView() {
        view.addSubview(connectionsTable)
        
        connectionsTable.backgroundColor = UIColor.blackColor()
        connectionsTable.separatorColor = UIColor(white: 1.0, alpha: 0.2)
//                eventTable.separatorInset = UIEdgeInsetsZero
//                eventTable.layoutMargins = UIEdgeInsetsZero
//                eventTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        connectionsTable.dataSource = self
        connectionsTable.delegate = self
        
        // Register reusable cell
        connectionsTable.registerClass(NotificationViewCell.self, forCellReuseIdentifier: "cell")
        
        connectionsTable.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(view.snp_center)
            make.size.equalTo(view.snp_size)
        }
        connectionsTable.rowHeight = UITableViewAutomaticDimension
        connectionsTable.estimatedRowHeight = 100
    }
    
    // --------------------- Table delegate functions ---------------------
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: NotificationViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! NotificationViewCell
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero

        // Retrieve info
        let info = sampleConnectionRequests[indexPath.row]
        let name = info["name"]!
        let date = info["date"]!
        let location = info["location"]!
        
        // Format the view
        cell.backgroundImage.image = UIImage(named: info["profilePic"]!)
        cell.profilePicView.image = UIImage(named: info["profilePic"]!)
        cell.nameLabel.text = name
        cell.dateLabel.text = date
        cell.locationLabel.text = location
        cell.rejectButton.tag = indexPath.row
        cell.rejectButton.addTarget(self, action: "handleReject:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.acceptButton.tag = indexPath.row
        cell.acceptButton.addTarget(self, action: "handleAccept:", forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        navigationController?.pushViewController(ProfileViewController(), animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleConnectionRequests.count
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        connectionsTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    static func pollForConnections() -> [NSDictionary] {
        return []
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
