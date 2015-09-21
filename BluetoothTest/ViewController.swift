//
//  ViewController.swift
//  BluetoothTest
//
//  Created by Vivek Sudarsan on 9/10/15.
//  Copyright (c) 2015 Vivek Sudarsan. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        
        label.text = "No Match Yet"
        label.textColor = UIColor.whiteColor()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B7D1027D-6788-416E-994F-EA11075F1765")!, identifier: "TEST")
        
        locationManager.startRangingBeaconsInRegion(region)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        
        var beaconMajor = 0
        var rssi = 0
        
        for beacon in beacons{
            beaconMajor = beacon.major as Int
            rssi = beacon.rssi
        }
        
        if (beaconMajor == 60611)
        {
            label.text = "Melissa's Phone - \(rssi) -\(beaconMajor)"
        }
        
        if (rssi == 0){
            view.backgroundColor = UIColor.blackColor()
            label.text = "No Match Yet"
        }
        
        if (rssi > -60){
            view.backgroundColor = UIColor.greenColor()
        }
        else if (rssi > -75 && rssi <= -60){
            view.backgroundColor = UIColor.orangeColor()
        }
        else{
            view.backgroundColor = UIColor.redColor()
        }
        
        print(beaconMajor)
        print(rssi)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

