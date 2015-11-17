//
//  ViewController.swift
//  BluetoothTest
//
//  Created by Vivek Sudarsan on 9/10/15.
//  Copyright (c) 2015 Vivek Sudarsan. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import Firebase
import SnapKit
import Darwin


class ViewController: UIViewController, CLLocationManagerDelegate, CBPeripheralManagerDelegate {
    let locationManager = CLLocationManager()
    var beacon: CLBeaconRegion!
    var beaconData: NSDictionary!
    var peripheral: CBPeripheralManager!
    
    var label = UILabel()

    let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
    let requestHandler = RequestHandler() // for http requests

    var customActivity = UIImageView()
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    var contactView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
    var topConstraint: NSLayoutConstraint!
    var bg = UIImageView()
    var viewContacts = UIButton()
    
    let profilePicture = UIImageView()
    
    var phone = "555-555-5555"
    var email = "john.smith@gmail.com"
    var companyName = "Uber Gizmos Inc."
    var titleName = "Associate Director"
    var peopleMet:[String] = []
    var userNameText = "Sample User Name"

    // Create a reference to a Firebase location
    let firebaseRef = Firebase(url:"https://fiery-heat-4470.firebaseio.com")
    let userref = Firebase(url:"https://fiery-heat-4470.firebaseio.com/users")
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "9BF22DAD-2C5E-4F9A-89D0-EB375E069F46")!, identifier: "TEST")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* START BROADCASTING BEACON */
        
        let UUID = NSUUID(UUIDString: "9BF22DAD-2C5E-4F9A-89D0-EB375E069F46")!
        let major: CLBeaconMajorValue = 999
        let minor: CLBeaconMinorValue = 678
        
        let userID = User.currentUser.userId
        
        beacon = CLBeaconRegion(proximityUUID: UUID, major: major, minor: minor, identifier: userID)
        peripheral = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        beaconData = beacon.peripheralDataWithMeasuredPower(nil)

        
        /* START LISTENING FOR BEACON */
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        
        if BeaconStarted.beacon.started == false{
            locationManager.startRangingBeaconsInRegion(region)
        }
        
        createView()
        
        // Write data to Firebase
        // Add user data
//        userref.childByAppendingPath("999").updateChildValues(["email":"jonsnow@got.com", "name": "Jon Snow", "title":"Lord Commander of the Night's Watch", "profile_pic":"http://i.imgur.com/oAM2HAo.png", "phone":"222-222-2222"])

        // use ATS for security eventually
//        let params = ["client_id": "30e036d353d740b", "response_type": "token", "state": ""]
//        requestHandler.sendRequest("https://api.imgur.com/oauth2/authorize", method: "GET", params: params, completionHandler: responseHandler)

        firebaseRef.authUser("mzw4@cornell.edu", password: "123",
            withCompletionBlock: { error, authData in
                if error != nil {
                    // There was an error logging in to this account
                    print("Error logging in! \(error)")
                } else {
                    // We are now logged in
                    let email = authData.providerData["email"]
                    print("\(authData) logged in with email \(email) and id \(authData.uid)")
                }
        })
        
        view.layoutIfNeeded()
        NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "rotateImage", userInfo: nil, repeats: false)
    }
    
    func createUser(email: String, password: String, completion: (error: NSError!, result: [NSObject: AnyObject]!) -> Void) {
        firebaseRef.createUser(email, password: password,
            withValueCompletionBlock: completion)
    }
    
    func createUserCompletion(error: NSError!, result: [NSObject: AnyObject]!) {
        if error != nil {
            // There was an error creating the account
            print("error creating account: \(error)")
        } else {
            let uid = result["uid"] as? String
            print("Successfully created user account with uid: \(uid)")
        }
    }
    
    func responseHandler(response: NSURLResponse?, data: NSData?, error: NSError?) -> Void {
        print("Response")
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager){
        if BeaconStarted.beacon.started == false{
            if peripheral.state == .PoweredOn {
                print("test worked")
                peripheral.startAdvertising(beaconData as! [String: AnyObject]!)
                BeaconStarted.beacon.started = true
            }
        } else if peripheral.state == .PoweredOff {
            peripheral.stopAdvertising()
            BeaconStarted.beacon.started = false
        }
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        var beaconMajor = ""
        var rssi = 0
        
        for beacon in beacons{
            beaconMajor = "\(beacon.major)"
            rssi = beacon.rssi
            print(rssi)
        }
        
        if (rssi < -50 || beaconMajor.isEmpty) {
            print("No one in range")
            return
        }
        
        print(PeopleMet.people.peopleMet)
        /* Use beaconMajor as closes becaon - send that ID to firebase to retrieve contact information */
        if peopleMet.contains(beaconMajor){
            print("Person already met")
        }
        else{
                print(beaconMajor)
            
                // Attach a closure to read the data at our posts reference
                userref.childByAppendingPath(beaconMajor).observeEventType(.Value, withBlock: { snapshot in
                    print(snapshot.value)
                    self.populateUserInfo(snapshot.value as! NSDictionary)
                    self.peopleMet.append(beaconMajor)
                    PeopleMet.people.peopleMet.append(beaconMajor)
                    }, withCancelBlock: { error in
                        print(error.description)
                })
        }
    }
    
    func populateUserInfo(info: NSDictionary) {
        phone = info.objectForKey("phone") as! String
        email = info.objectForKey("email") as! String
        companyName = info.objectForKey("phone") as! String
        titleName = info.objectForKey("title") as! String
        userNameText = info.objectForKey("name") as! String
        
        let url = NSURL(string: info.objectForKey("profile_pic") as! String)
        let img_data = NSData(contentsOfURL: url!)
        profilePicture.image = UIImage(data: img_data!)
        
        // Load fields into the card view
        detailCardView()

        topConstraint.constant = 0.0
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func testCard(){
        topConstraint.constant = 0.0
        UIView.animateWithDuration(1.0, delay: 3.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        rotateImage()
    }
    
    func createView(){
        view.backgroundColor = UIColor.blackColor()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.translucent = true
        navigationController?.view.backgroundColor = UIColor.clearColor()
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        view.addSubview(bg)
        bg.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp_centerX)
            make.centerY.equalTo(view.snp_centerY)
            make.width.equalTo(view.snp_width)
            make.height.equalTo(view.snp_height)
        }
        bg.image = UIImage(named: EventChosen.events.eventImage)
        bg.alpha = 0.15
        bg.contentMode = UIViewContentMode.ScaleAspectFill
        

        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 120.0))
        
        label.text = EventChosen.events.eventSelected
        label.textColor = UIColor.whiteColor()
        label.font = UIFont(name: label.font.fontName, size: 21.0)
        
        rotateAnimation.delegate = rotateAnimation
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = 100000.0
        
        
        view.addSubview(customActivity)
        customActivity.translatesAutoresizingMaskIntoConstraints = false
        customActivity.image = UIImage(named: "Radar3.png")
//        customActivity.layer.addAnimation(rotateAnimation, forKey: "transform.rotation")
        customActivity.contentMode = UIViewContentMode.ScaleAspectFit
        customActivity.frame.size.width = view.frame.size.width/2
        view.addConstraint(NSLayoutConstraint(item: customActivity, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: customActivity, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: -100.0))
        view.addConstraint(NSLayoutConstraint(item: customActivity, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.75, constant: 0.0))
        

        view.addSubview(viewContacts)
        viewContacts.translatesAutoresizingMaskIntoConstraints = false
        viewContacts.layer.cornerRadius = 6.0
        viewContacts.backgroundColor = UIConstants.primaryColor
        viewContacts.setTitle("Stop Broadcasting", forState: .Normal)
        view.addConstraint(NSLayoutConstraint(item: viewContacts, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: viewContacts, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.7, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: viewContacts, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 50.0))
        view.addConstraint(NSLayoutConstraint(item: viewContacts, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -60.0))
        viewContacts.addTarget(self, action: "stopBeacon", forControlEvents: .TouchUpInside)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "swipeDown:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        view.addGestureRecognizer(swipeDown)
        
        view.addSubview(contactView)
        contactView.translatesAutoresizingMaskIntoConstraints = false
        contactView.layer.cornerRadius = 8.0
        contactView.layer.borderColor = UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.1).CGColor
        contactView.layer.borderWidth = 1.0
        contactView.clipsToBounds = true
        view.addConstraint(NSLayoutConstraint(item: contactView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: contactView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 300.0))
        view.addConstraint(NSLayoutConstraint(item: contactView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.9, constant: 0.0))
        topConstraint = NSLayoutConstraint(item: contactView, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 2000.0)
        view.addConstraint(topConstraint)
        

        
    }
    
    
    func rotateImage(){
        UIView.animateWithDuration(2.0, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.customActivity.transform = CGAffineTransformRotate(self.customActivity.transform, CGFloat(M_PI))
            }) { (Bool) -> Void in
                self.rotateImage()
                self.view.layoutIfNeeded()
        }
    }
    
    func detailCardView(){
        let phoneNumber = UILabel()
        let emailAddress = UILabel()
        let userName = UILabel()
        let company = UILabel()
        let title = UILabel()
        
        
        /* UPDATE FROM FIREBASE */

        let allContactViews = [profilePicture,userName,phoneNumber,emailAddress,company,title]
        
        for items in allContactViews{
            contactView.addSubview(items)
            items.translatesAutoresizingMaskIntoConstraints = false
        }
        
        profilePicture.layer.cornerRadius = 25.0
        profilePicture.clipsToBounds = true
        profilePicture.contentMode = UIViewContentMode.ScaleAspectFill
        contactView.addConstraint(NSLayoutConstraint(item: profilePicture, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 50.0))
        contactView.addConstraint(NSLayoutConstraint(item: profilePicture, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 50.0))
        contactView.addConstraint(NSLayoutConstraint(item: profilePicture, attribute: .Left, relatedBy: .Equal, toItem: contactView, attribute: .Left, multiplier: 1.0, constant: 20.0))
        contactView.addConstraint(NSLayoutConstraint(item: profilePicture, attribute: .Top, relatedBy: .Equal, toItem: contactView, attribute: .Top, multiplier: 1.0, constant: 30.0))
        
        userName.text = userNameText
        userName.textColor = UIColor.whiteColor()
        userName.font = UIFont(name: label.font.fontName, size: 19)
        contactView.addConstraint(NSLayoutConstraint(item: userName, attribute: .Top, relatedBy: .Equal, toItem: contactView, attribute: .Top, multiplier: 1.0, constant: 42.0))
        contactView.addConstraint(NSLayoutConstraint(item: userName, attribute: .Left, relatedBy: .Equal, toItem: profilePicture, attribute: .Right, multiplier: 1.0, constant: 20.0))
        
        phoneNumber.text = "Phone: \(phone)"
        phoneNumber.font = UIFont(name: label.font.fontName, size: 17)
        phoneNumber.textColor = UIColor.whiteColor()
        contactView.addConstraint(NSLayoutConstraint(item: phoneNumber, attribute: .Top, relatedBy: .Equal, toItem: profilePicture, attribute: .Bottom, multiplier: 1.0, constant: 35.0))
        contactView.addConstraint(NSLayoutConstraint(item: phoneNumber, attribute: .Left, relatedBy: .Equal, toItem: contactView, attribute: .Left, multiplier: 1.0, constant: 20.0))
        
        
        let descriptors = [emailAddress,company,title]
        let descriptorValues = [email,companyName,titleName]
        let descriptorNames = ["Email: ","Company: ","Title: "]
        var itemCount = 0
        
        for des in descriptors{
            des.text = descriptorNames[itemCount] + " " + descriptorValues[itemCount]
            des.font = UIFont(name: label.font.fontName, size: 17)
            des.textColor = UIColor.whiteColor()
            
            if des == emailAddress{
                contactView.addConstraint(NSLayoutConstraint(item: des, attribute: .Top, relatedBy: .Equal, toItem: phoneNumber, attribute: .Bottom, multiplier: 1.0, constant: 20.0))
            }
            else{
                contactView.addConstraint(NSLayoutConstraint(item: des, attribute: .Top, relatedBy: .Equal, toItem: descriptors[itemCount-1], attribute: .Bottom, multiplier: 1.0, constant: 20.0))
            }

            contactView.addConstraint(NSLayoutConstraint(item: des, attribute: .Left, relatedBy: .Equal, toItem: contactView, attribute: .Left, multiplier: 1.0, constant: 20.0))
            
            itemCount += 1
        }
    }
    
    func stopBeacon(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        peripheral.stopAdvertising()
        BeaconStarted.beacon.started = false
        locationManager.stopRangingBeaconsInRegion(region)

        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func swipeDown(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == UISwipeGestureRecognizerDirection.Down && topConstraint.constant == 0{
                topConstraint.constant = 2000.0
                UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
                    self.view.layoutIfNeeded()
                    }, completion: nil)
        }else if gesture.direction == UISwipeGestureRecognizerDirection.Down && topConstraint.constant == 2000.0{
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

