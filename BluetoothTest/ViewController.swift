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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        /* START BROADCASTING BEACON */
        
        let UUID = NSUUID(UUIDString: "9BF22DAD-2C5E-4F9A-89D0-EB375E069F46")
        let major: CLBeaconMajorValue = 902
        let minor: CLBeaconMinorValue = 123
        
        beacon = CLBeaconRegion(proximityUUID: UUID, major: major, minor: minor, identifier: "TEST")
        peripheral = CBPeripheralManager(delegate: nil, queue: nil)
        beaconData = beacon.peripheralDataWithMeasuredPower(nil)
        
        
        
        /* START LISTENING FOR BEACON */
        
        view.addSubview(label)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: -200.0))
        
        label.text = "Searching..."
        label.textColor = UIColor.grayColor()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "9BF22DAD-2C5E-4F9A-89D0-EB375E069F46"), identifier: "TEST")
        
        locationManager.startRangingBeaconsInRegion(region)
        
        createView()

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager){
        if peripheral.state == .PoweredOn {
            peripheral.startAdvertising(beaconData as! [String: AnyObject]!)
        } else if peripheral.state == .PoweredOff {
            peripheral.stopAdvertising()
        }
    }
    
    
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {

        
        var beaconMajor = 0
        var rssi = 0
        
        for beacon in beacons{
            beaconMajor = beacon.major as! Int
            rssi = beacon.rssi
        }
        
        if (beaconMajor == 902)
        {
            customActivity.removeFromSuperview()
            view.addSubview(contactView)
            
            label.text = "Vivek's Phone - \(rssi) -\(beaconMajor)"
            
            contactView.setTranslatesAutoresizingMaskIntoConstraints(false)
            contactView.backgroundColor = UIColor.blackColor()
            view.addConstraint(NSLayoutConstraint(item: contactView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.6, constant: 0.0))
            view.addConstraint(NSLayoutConstraint(item: contactView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1.0, constant: 0.0))
        }
        
    }
    
    
    func createView(){
        view.backgroundColor = UIColor.whiteColor()

        view.addSubview(customActivity)
        customActivity.setTranslatesAutoresizingMaskIntoConstraints(false)
        customActivity.image = UIImage(named: "Radar.png")
        customActivity.rotate360Degrees(duration: 100000.0, completionDelegate: nil)
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

