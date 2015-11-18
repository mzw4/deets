//
//  NotificationsViewController.swift
//  BluetoothTest
//
//  Created by Mike Wang on 10/26/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import UIKit

class NotificationsViewController: UIPageViewController, UITableViewDelegate, UITableViewDataSource {

    var connections: [ConnectionRequest] = [ConnectionRequest]()
    
    var connectionsTable = UITableView()
    var cellToHide: Int?
    var numCells = 0
    
    var dateFormatter = NSDateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        
        // Set date formatter
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        ConnectionRequestManager.getConnectionRequests(User.currentUser.userId, completion: { (connections: [String : ConnectionRequest]) in
            self.connections = Array(ConnectionRequestManager.connectionRequests.values)
            self.connectionsTable.reloadData()
        })

        connections = Array(ConnectionRequestManager.connectionRequests.values)
        
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
        // Submit accept request
        let conn = connections[sender.tag]
        let otherId = (conn.userId1 == User.currentUser.userId) ? conn.userId2 : conn.userId1
        DataHandler.userAcceptedConnection(User.currentUser.userId, otherUserId: otherId, connId: connections[sender.tag].connId)

        connectionsTable.beginUpdates()
        connections.removeAtIndex(sender.tag)
        connectionsTable.deleteRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: .Right)
        connectionsTable.endUpdates()
        print("done accepting")
    }
    
    func handleReject(sender: UIButton) {
        // Submit reject request
        DataHandler.userRejectedConnection(User.currentUser.userId, connId: connections[sender.tag].connId)
        
        connectionsTable.beginUpdates()
        connections.removeAtIndex(sender.tag)
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
        let info = connections[indexPath.row]
        if info.userId1 == User.currentUser.userId {
            cell.backgroundImage.image = UIImage(named: info.profilePic2)
            cell.profilePicView.image = UIImage(named: info.profilePic2)
            cell.nameLabel.text = info.name2
        } else {
            cell.backgroundImage.image = UIImage(named: info.profilePic1)
            cell.profilePicView.image = UIImage(named: info.profilePic1)
            cell.nameLabel.text = info.name1
        }
        
        // Format the view
        cell.dateLabel.text = dateFormatter.stringFromDate(info.date)
        cell.locationLabel.text = info.location
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
        return connections.count
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
