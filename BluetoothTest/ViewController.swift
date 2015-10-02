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

extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 100000.0)
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate
        }
        self.layer.addAnimation(rotateAnimation, forKey: nil)
    }
}


class ViewController: UIViewController, CLLocationManagerDelegate, CBPeripheralManagerDelegate {
    let locationManager = CLLocationManager()
    var beacon: CLBeaconRegion!
    var beaconData: NSDictionary!
    var peripheral: CBPeripheralManager!
    
    var label = UILabel()

    let requestHandler = RequestHandler() // for http requests

    var customActivity = UIImageView()
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    var contactView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
    var topConstraint: NSLayoutConstraint!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* START BROADCASTING BEACON */
        
        let UUID = NSUUID(UUIDString: "9BF22DAD-2C5E-4F9A-89D0-EB375E069F46")!
        let major: CLBeaconMajorValue = 234
        let minor: CLBeaconMinorValue = 678
        
        beacon = CLBeaconRegion(proximityUUID: UUID, major: major, minor: minor, identifier: "TEST")
        peripheral = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        beaconData = beacon.peripheralDataWithMeasuredPower(nil)

        
        /* START LISTENING FOR BEACON */
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "9BF22DAD-2C5E-4F9A-89D0-EB375E069F46")!, identifier: "TEST")
        
        locationManager.startRangingBeaconsInRegion(region)
        
        createView()
        
        // Write data to Firebase
        // Add user data
//        userref.childByAppendingPath("999").updateChildValues(["email":"jonsnow@got.com", "name": "Jon Snow", "title":"Lord Commander of the Night's Watch", "profile_pic":"http://i.imgur.com/oAM2HAo.png", "phone":"222-222-2222"])

        // use ATS for security eventually
//        let params = ["client_id": "30e036d353d740b", "response_type": "token", "state": ""]
//        requestHandler.sendRequest("https://api.imgur.com/oauth2/authorize", method: "GET", params: params, completionHandler: responseHandler)

        firebaseRef.authUser("bobtony@example.com", password: "correcthorsebatterystaple",
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
        if peripheral.state == .PoweredOn {
            print("test worked")
            peripheral.startAdvertising(beaconData as! [String: AnyObject]!)
        } else if peripheral.state == .PoweredOff {
            peripheral.stopAdvertising()
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
        
        /* Use beaconMajor as closes becaon - send that ID to firebase to retrieve contact information */
        if peopleMet.contains(beaconMajor){
            print("Person already met")
        }
        else{
//            if (beaconMajor == 000)
//            {
                print(beaconMajor)
            
                // Attach a closure to read the data at our posts reference
                userref.childByAppendingPath(beaconMajor).observeEventType(.Value, withBlock: { snapshot in
                    print(snapshot.value)
                    self.populateUserInfo(snapshot.value as! NSDictionary)
                    self.peopleMet.append(beaconMajor)

                    }, withCancelBlock: { error in
                        print(error.description)
                })
//            }
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
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    func createView(){
        view.backgroundColor = UIColor(red: 0.16, green: 0.19, blue: 0.22, alpha: 1.0)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.translucent = true
        navigationController?.view.backgroundColor = UIColor.clearColor()
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        

        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 120.0))
        
        label.text = "Entreprenuers Meetup"
        label.textColor = UIColor.whiteColor()
        label.font = UIFont(name: label.font.fontName, size: 21.0)
        
        view.addSubview(customActivity)
        customActivity.translatesAutoresizingMaskIntoConstraints = false
        customActivity.image = UIImage(named: "Radar2.png")
        customActivity.rotate360Degrees(100000.0, completionDelegate: nil)
        customActivity.contentMode = UIViewContentMode.ScaleAspectFit
        view.addConstraint(NSLayoutConstraint(item: customActivity, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: customActivity, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: -100.0))
        view.addConstraint(NSLayoutConstraint(item: customActivity, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.75, constant: 0.0))

        view.addSubview(viewContacts)
        viewContacts.translatesAutoresizingMaskIntoConstraints = false
        viewContacts.layer.cornerRadius = 25.0
        viewContacts.backgroundColor = UIColor(red: 0.0, green: 0.74, blue: 1.0, alpha: 1.0)
        viewContacts.setTitle("View Contacts", forState: .Normal)
        view.addConstraint(NSLayoutConstraint(item: viewContacts, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: viewContacts, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.7, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: viewContacts, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 50.0))
        view.addConstraint(NSLayoutConstraint(item: viewContacts, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -60.0))
        
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
    
    
    func swipeDown(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == UISwipeGestureRecognizerDirection.Down {
                topConstraint.constant = 2000.0
                UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
                    self.view.layoutIfNeeded()
                    }, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return UIStatusBarStyle.LightContent
//    }

}

