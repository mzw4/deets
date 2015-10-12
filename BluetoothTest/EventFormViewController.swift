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
    var eventStart = UITextField()
    var eventEnd = UITextField()
    var eventCompany = UITextField()
    var Description = UITextField()
    
    let dateFormat: NSDateFormatter = NSDateFormatter()
    let startDatePicker: UIDatePicker = UIDatePicker()
    let endDatePicker: UIDatePicker = UIDatePicker()
    var fontAwesomeIcon: UILabel!
    
    //To do: Image, Description, Max Participants
    //To do: Fix Address field
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for family: String in UIFont.familyNames()
        {
            print("\(family)")
            for names: String in UIFont.fontNamesForFamilyName(family)
            {
                print("== \(names)")
            }
        }
        
        let label: UILabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.size.width, 120))
        label.textAlignment = NSTextAlignment.Center
        label.text = "\u{f271} Create Event"
        label.font = UIFont(name: "FontAwesome", size: 30)
        label.backgroundColor = UIColor(red: 0, green: 74, blue: 255, alpha: 1.0)
        self.view.addSubview(label)
        
        view.backgroundColor = UIColor(red: 0.16, green: 0.19, blue: 0.22, alpha: 1.0)
        
        
        
        //Unnecessary Label
        let labelItems: UILabel = UILabel(frame: CGRectMake(0, 200, self.view.frame.size.width, 13))
        labelItems.textAlignment = NSTextAlignment.Center
        labelItems.text = "Fields"
        labelItems.font = UIFont(name: "FontAwesome", size: 12)
        labelItems.textColor = UIColor.whiteColor()
        labelItems.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        self.view.addSubview(labelItems)
        
        
        //eventTitle Field
        view.addSubview(eventTitle)
        eventTitle.delegate=self
        eventTitle.translatesAutoresizingMaskIntoConstraints = false
        eventTitle.backgroundColor = UIColor.whiteColor()
        eventTitle.layer.borderColor = UIColor(red:0/255.0, green:188.7/255.0, blue:255/255.0, alpha: 1.0).CGColor
        eventTitle.layer.borderWidth = 1.5
        eventTitle.attributedPlaceholder = NSAttributedString(string:"Event Title",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        eventTitle.font = UIFont(name: "FontAwesome", size: 12)
        eventTitle.layer.sublayerTransform = CATransform3DMakeTranslation(10, 000, 0)
        eventTitle.selectedTextRange = eventTitle.textRangeFromPosition(eventTitle.beginningOfDocument, toPosition: eventTitle.beginningOfDocument)
        eventTitle.layer.cornerRadius = 10
        view.addConstraint(NSLayoutConstraint(item: eventTitle, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)) //Tell field to center on x-axis
        view.addConstraint(NSLayoutConstraint(item: eventTitle, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: -100)) //Tell field to center on y-axis
        view.addConstraint(NSLayoutConstraint(item: eventTitle, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 30))
        view.addConstraint(NSLayoutConstraint(item: eventTitle, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 200))
        
        
        //eventAddress Field
        view.addSubview(eventAddress)
        //eventAddress.delegate=self
        eventAddress.backgroundColor = UIColor.whiteColor()
        eventAddress.layer.borderColor = UIColor(red:0/255.0, green:188.7/255.0, blue:255/255.0, alpha: 1.0).CGColor
        eventAddress.layer.borderWidth = 1.5
        eventAddress.attributedPlaceholder = NSAttributedString(string:"\u{f124} Location",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        eventAddress.font = UIFont(name: "FontAwesome", size: 12)
        eventAddress.layer.sublayerTransform = CATransform3DMakeTranslation(10, 000, 0)
        eventAddress.translatesAutoresizingMaskIntoConstraints = false
        eventAddress.layer.cornerRadius = 10
        view.addConstraint(NSLayoutConstraint(item: eventAddress, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)) //Tell field to center on x-axis
        view.addConstraint(NSLayoutConstraint(item: eventAddress, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: eventTitle, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 10)) //Tell field to center on y-axis
        view.addConstraint(NSLayoutConstraint(item: eventAddress, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 30))
        view.addConstraint(NSLayoutConstraint(item: eventAddress, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 200))
        
        //eventCompany Field
        view.addSubview(eventCompany)
        //eventAddress.delegate=self
        eventCompany.backgroundColor = UIColor.whiteColor()
        eventCompany.layer.borderColor = UIColor(red:0/255.0, green:188.7/255.0, blue:255/255.0, alpha: 1.0).CGColor
        eventCompany.layer.borderWidth = 1.5
        eventCompany.attributedPlaceholder = NSAttributedString(string:"\u{f0f2} Company Name",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        eventCompany.font = UIFont(name: "FontAwesome", size: 12)
        eventCompany.layer.sublayerTransform = CATransform3DMakeTranslation(10, 000, 0)
        eventCompany.translatesAutoresizingMaskIntoConstraints = false
        eventCompany.layer.cornerRadius = 10
        view.addConstraint(NSLayoutConstraint(item: eventCompany, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)) //Tell field to center on x-axis
        view.addConstraint(NSLayoutConstraint(item: eventCompany, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: eventAddress, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 10)) //Tell field to center on y-axis
        view.addConstraint(NSLayoutConstraint(item: eventCompany, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 30))
        view.addConstraint(NSLayoutConstraint(item: eventCompany, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 200))
        
        
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
        eventStart.layer.borderColor = UIColor(red:0/255.0, green:188.7/255.0, blue:255/255.0, alpha: 1.0).CGColor
        eventStart.layer.borderWidth = 1.5
        eventStart.attributedPlaceholder = NSAttributedString(string:"\u{f073} Start Date",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        eventStart.font = UIFont(name: "FontAwesome", size: 12)
        eventStart.layer.sublayerTransform = CATransform3DMakeTranslation(10, 000, 0)
        eventStart.layer.cornerRadius = 10
        view.addConstraint(NSLayoutConstraint(item: eventStart, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)) //Tell field to center on x-axis
        view.addConstraint(NSLayoutConstraint(item: eventStart, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: eventCompany, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 10)) //Tell field to center on y-axis
        view.addConstraint(NSLayoutConstraint(item: eventStart, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 30))
        view.addConstraint(NSLayoutConstraint(item: eventStart, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 200))
        
        //eventEnd Field
        eventEnd.inputView = endDatePicker
        view.addSubview(eventEnd)
        //eventEnd.delegate=self
        eventEnd.translatesAutoresizingMaskIntoConstraints = false
        eventEnd.backgroundColor = UIColor.whiteColor()
        eventEnd.layer.borderColor = UIColor(red:0/255.0, green:188.7/255.0, blue:255/255.0, alpha: 1.0).CGColor
        eventEnd.layer.borderWidth = 1.5
        eventEnd.attributedPlaceholder = NSAttributedString(string:"\u{f073} End Date",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        eventEnd.font = UIFont(name: "FontAwesome", size: 12)
        eventEnd.layer.sublayerTransform = CATransform3DMakeTranslation(10, 000, 0)
        eventEnd.layer.cornerRadius = 10
        view.addConstraint(NSLayoutConstraint(item: eventEnd, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)) //Tell field to center on x-axis
        view.addConstraint(NSLayoutConstraint(item: eventEnd, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: eventStart, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 10)) //Tell field to center on y-axis
        view.addConstraint(NSLayoutConstraint(item: eventEnd, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 30))
        view.addConstraint(NSLayoutConstraint(item: eventEnd, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 200))
        
        
        
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
        self.view.frame.origin.y -= 100
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 100
    }
    
    
    //Address Attempt
    
    @IBAction func eventAddress(sender: AnyObject) {
        self.performSearch()
    }
    
    func performSearch() {
        
        //matchingItems.removeAll()
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