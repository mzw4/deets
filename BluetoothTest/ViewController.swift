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




class ViewController: UIViewController, CLLocationManagerDelegate, CBPeripheralDelegate {
    let locationManager = CLLocationManager()
    var label = UILabel()
    
    
    var beacon: CLBeaconRegion!
    var beaconData: NSDictionary!
    var peripheral: CBPeripheralManager!
    
    var customActivity = UIImageView()
    var contactView = UIView()
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)

    let requestHandler = RequestHandler() // for http requests

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        /* START BROADCASTING BEACON */
        
        let UUID = NSUUID(UUIDString: "9BF22DAD-2C5E-4F9A-89D0-EB375E069F46")
        let major: CLBeaconMajorValue = 902
        let minor: CLBeaconMinorValue = 123
        
        beacon = CLBeaconRegion(proximityUUID: UUID!, major: major, minor: minor, identifier: "TEST")
        peripheral = CBPeripheralManager(delegate: nil, queue: nil)
        beaconData = beacon.peripheralDataWithMeasuredPower(nil)
        
        /* START LISTENING FOR BEACON */
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: -200.0))
        
        label.text = "Searching..."
        label.textColor = UIColor.grayColor()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B7D1027D-6788-416E-994F-EA11075F1765")!, identifier: "TEST")
        
        locationManager.startRangingBeaconsInRegion(region)
        
        createView()
        
        // Firebase stuff
        
        // Create a reference to a Firebase location
        let userref = Firebase(url:"https://fiery-heat-4470.firebaseio.com/users")

//        let mailingref = firebaseRootRef.childByAppendingPath("mailing-list")
//        mailingref.setValue("hi")
        
        // Write data to Firebase
        // Add user data
        userref.childByAppendingPath("000").updateChildValues(["email":"dtrump@president.com", "name": "Donald Trump", "title":"future president", "profile_pic":"http://i.imgur.com/gGwaKO2.jpg", "phone":"111-111-1111"])
        userref.childByAppendingPath("999").updateChildValues(["email":"jonsnow@got.com", "name": "Jon Snow", "title":"Lord Commander of the Night's Watch", "profile_pic":"http://i.imgur.com/oAM2HAo.png", "phone":"222-222-2222"])
        userref.childByAppendingPath("234").updateChildValues(["email":"jonsnow@got.com", "name": "Jon Snow", "title":"Lord Commander of the Night's Watch", "profile_pic":"http://i.imgur.com/oAM2HAo.png", "phone":"111-111-1111"])
        userref.childByAppendingPath("123").updateChildValues(["email":"mzw4@cornell", "name": "Mike Wang", "title":"Cornell Tech Student, Parkour master", "profile_pic":"http://i.imgur.com/vei6Ryq.jpg", "phone":"781-526-1943"])
        
        // Attach a closure to read the data at our posts reference
        userref.childByAppendingPath("000").observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            self.displayUserInfo(snapshot.value as! NSDictionary)
            
            }, withCancelBlock: { error in
                print(error.description)
        })

        
        // use ATS for security eventually
//        let params = ["client_id": "30e036d353d740b", "response_type": "token", "state": ""]
//        requestHandler.sendRequest("https://api.imgur.com/oauth2/authorize", method: "GET", params: params, completionHandler: responseHandler)
//        
//        firebaseRootRef.createUser("bobtony@example.com", password: "correcthorsebatterystaple",
//            withValueCompletionBlock: { error, result in
//                if error != nil {
//                    // There was an error creating the account
//                    print("error creating account: \(error)")
//                } else {
//                    let uid = result["uid"] as? String
//                    print("Successfully created user account with uid: \(uid)")
//                }
//        })
//        
//        firebaseRootRef.authUser("bobtony@example.com", password: "correcthorsebatterystaple",
//            withCompletionBlock: { error, authData in
//                if error != nil {
//                    // There was an error logging in to this account
//                    print("Error logging in! \(error)")
//                } else {
//                    // We are now logged in
//                    let email = authData.providerData["email"]
//                    print("\(authData) logged in with email \(email)")
//                }
//        })
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func displayUserInfo(info: NSDictionary) {
        let url = NSURL(string: info.objectForKey("profile_pic") as! String)
        let img_data = NSData(contentsOfURL: url!)
        let img = UIImage(data: img_data!)

        let imgview = UIImageView(image: img)
        imgview.layer.masksToBounds = true
        imgview.layer.cornerRadius = (img?.size.height)!/2
        
        self.view.addSubview(imgview)
    }
    
    func responseHandler(response: NSURLResponse?, data: NSData?, error: NSError?) -> Void {
        print("Response")
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager){
        if peripheral.state == .PoweredOn {
            peripheral.startAdvertising(beaconData as! [String: AnyObject]!)
        } else if peripheral.state == .PoweredOff {
            peripheral.stopAdvertising()
        }
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        var beaconMajor = 0
        var rssi = 0
        
        for beacon in beacons{
            beaconMajor = beacon.major as Int
            rssi = beacon.rssi
        }
        
        if (beaconMajor == 902)
        {
            customActivity.removeFromSuperview()
            view.addSubview(contactView)
            
            label.text = "Vivek's Phone - \(rssi) -\(beaconMajor)"
            
            contactView.translatesAutoresizingMaskIntoConstraints = false
            contactView.backgroundColor = UIColor.blackColor()
            view.addConstraint(NSLayoutConstraint(item: contactView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.6, constant: 0.0))
            view.addConstraint(NSLayoutConstraint(item: contactView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1.0, constant: 0.0))
        }
        
    }
    
    
    func createView(){
        view.backgroundColor = UIColor.whiteColor()

        view.addSubview(customActivity)
        customActivity.translatesAutoresizingMaskIntoConstraints = false
        customActivity.image = UIImage(named: "Radar.png")
        customActivity.rotate360Degrees(100000.0, completionDelegate: nil)
        customActivity.contentMode = UIViewContentMode.ScaleAspectFit
        view.addConstraint(NSLayoutConstraint(item: customActivity, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: customActivity, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: customActivity, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 150.0))
        view.addConstraint(NSLayoutConstraint(item: customActivity, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 150.0))
        
        //        view.addSubview(activityIndicator)
        //        activityIndicator.setTranslatesAutoresizingMaskIntoConstraints(false)
        //        view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        //        view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 30.0))
        //        activityIndicator.tintColor = UIColor.grayColor()
        //
        //        activityIndicator.startAnimating()
    
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

