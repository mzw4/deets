//
//  EventFormViewController.swift
//  BluetoothTest
//
//  Created by Julian Ferdman on 10/6/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class EventFormViewController: UIViewController, UITextFieldDelegate {
    
    var eventTitle = UITextField()
    var eventAddress = UITextField() //Thought is to change all address fields to a single Maps Query
    var matchingItems: [MKMapItem] = [MKMapItem]()
    var eventStart = UITextField()
    var eventEnd = UITextField()
    
    let dateFormat: NSDateFormatter = NSDateFormatter()
    let startDatePicker: UIDatePicker = UIDatePicker()
    let endDatePicker: UIDatePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(eventTitle)
        eventTitle.delegate=self
        eventTitle.translatesAutoresizingMaskIntoConstraints = false
        eventTitle.backgroundColor = UIColor.whiteColor()
        eventTitle.layer.borderColor = UIColor.blackColor().CGColor
        eventTitle.layer.borderWidth = 1.0
        eventTitle.attributedPlaceholder = NSAttributedString(string:"Event Title",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        eventTitle.layer.sublayerTransform = CATransform3DMakeTranslation(10, 000, 0)
        eventTitle.selectedTextRange = eventTitle.textRangeFromPosition(eventTitle.beginningOfDocument, toPosition: eventTitle.beginningOfDocument)
        eventTitle.layer.cornerRadius = 10
        view.addConstraint(NSLayoutConstraint(item: eventTitle, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)) //Tell field to center on x-axis
        view.addConstraint(NSLayoutConstraint(item: eventTitle, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)) //Tell field to center on y-axis
        view.addConstraint(NSLayoutConstraint(item: eventTitle, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 30))
        view.addConstraint(NSLayoutConstraint(item: eventTitle, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 200))
        
        // Setup Start date picker
        dateFormat.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormat.timeStyle = NSDateFormatterStyle.ShortStyle
        startDatePicker.datePickerMode = UIDatePickerMode.DateAndTime
        startDatePicker.addTarget(self, action: Selector("updateStartDateField:"), forControlEvents:UIControlEvents.ValueChanged)
        
        // Setup End date picker
        dateFormat.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormat.timeStyle = NSDateFormatterStyle.ShortStyle
        endDatePicker.datePickerMode = UIDatePickerMode.DateAndTime
        endDatePicker.addTarget(self, action: Selector("updateEndDateField:"), forControlEvents:UIControlEvents.ValueChanged)
        
        
        
        //eventStart Field
        eventStart.inputView = startDatePicker
        view.addSubview(eventStart)
        //eventStart.delegate=self
        eventStart.translatesAutoresizingMaskIntoConstraints = false
        eventStart.backgroundColor = UIColor.whiteColor()
        eventStart.layer.borderColor = UIColor.blackColor().CGColor
        eventStart.layer.borderWidth = 1.0
        eventStart.attributedPlaceholder = NSAttributedString(string:"Start Date",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        eventStart.layer.sublayerTransform = CATransform3DMakeTranslation(10, 000, 0)
        eventStart.layer.cornerRadius = 10
        view.addConstraint(NSLayoutConstraint(item: eventStart, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)) //Tell field to center on x-axis
        view.addConstraint(NSLayoutConstraint(item: eventStart, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: eventTitle, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 10)) //Tell field to center on y-axis
        view.addConstraint(NSLayoutConstraint(item: eventStart, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 30))
        view.addConstraint(NSLayoutConstraint(item: eventStart, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 200))
        
        //eventEnd Field
        eventEnd.inputView = endDatePicker
        view.addSubview(eventEnd)
        //eventEnd.delegate=self
        eventEnd.translatesAutoresizingMaskIntoConstraints = false
        eventEnd.backgroundColor = UIColor.whiteColor()
        eventEnd.layer.borderColor = UIColor.blackColor().CGColor
        eventEnd.layer.borderWidth = 1.0
        eventEnd.attributedPlaceholder = NSAttributedString(string:"Start End",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        eventEnd.layer.sublayerTransform = CATransform3DMakeTranslation(10, 000, 0)
        eventEnd.layer.cornerRadius = 10
        view.addConstraint(NSLayoutConstraint(item: eventEnd, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)) //Tell field to center on x-axis
        view.addConstraint(NSLayoutConstraint(item: eventEnd, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: eventStart, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 10)) //Tell field to center on y-axis
        view.addConstraint(NSLayoutConstraint(item: eventEnd, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 30))
        view.addConstraint(NSLayoutConstraint(item: eventEnd, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 200))
        
        
        //eventAddress Field
        view.addSubview(eventAddress)
        //eventAddress.delegate=self
        eventAddress.backgroundColor = UIColor.whiteColor()
        eventAddress.layer.borderColor = UIColor.blackColor().CGColor
        eventAddress.layer.borderWidth = 1.0
        eventAddress.attributedPlaceholder = NSAttributedString(string:"Location",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        eventAddress.layer.sublayerTransform = CATransform3DMakeTranslation(10, 000, 0)
        eventAddress.translatesAutoresizingMaskIntoConstraints = false
        eventAddress.layer.cornerRadius = 10
        view.addConstraint(NSLayoutConstraint(item: eventAddress, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)) //Tell field to center on x-axis
        view.addConstraint(NSLayoutConstraint(item: eventAddress, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: eventEnd, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 10)) //Tell field to center on y-axis
        view.addConstraint(NSLayoutConstraint(item: eventAddress, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 30))
        view.addConstraint(NSLayoutConstraint(item: eventAddress, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 200))
        
        
        //Keyboard Fix
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //Remove Keyboard when clicking outside
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func updateStartDateField(sender: UIDatePicker) {
        eventStart.text = dateFormat.stringFromDate(sender.date)
    }
    
    func updateEndDateField(sender: UIDatePicker) {
        eventEnd.text = dateFormat.stringFromDate(sender.date)
    }
    
    
    //Keyboard Position Fix
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 150
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 150
    }
    
    
    //Address Attempt
    
    @IBAction func eventAddress(sender: AnyObject) {
        sender.resignFirstResponder()
        self.performSearch()
    }
    
    func performSearch() {
        
        matchingItems.removeAll()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = eventAddress.text
        //request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler {
            (response, error)  in
            if response == nil {
                print(error)
                return
            }
        }
    }
    
    
}

