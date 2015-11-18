//
//  EventDetailsViewController.swift
//  BluetoothTest
//
//  Created by Vivek Sudarsan on 10/27/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import UIKit
import SnapKit
import XMSegmentedControl

extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 100000.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)*100000
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate
        }
        self.layer.addAnimation(rotateAnimation, forKey: nil)
    }
}


class EventDetailsViewController: UIViewController, UIScrollViewDelegate, XMSegmentedControlDelegate, UITableViewDelegate,UITableViewDataSource{
    var containerScroll = UIScrollView()
    var containerView = UIView()
    
    var topView = UIView()
    var topImageView = UIImageView()
    var eventLabel = UILabel()
    var eventIcon = UIImageView()
    var joinButton = UIButton()
    
    var bottomView = UIView()
    var widthConstraint:NSLayoutConstraint?
    var topConstraint:Constraint? = nil
    
    var pagingViews = UIScrollView()
    var pageViewContainer = UIView()
    var subPageView1 = UIView()
    var subPageView2 = UIView()
    var subPageView3 = UIView()
    var eventDetails = UIView()
    var eventDetailsTitle = UILabel()
    var eventDetailsText = UILabel()
    var eventDivider = UIView()
    var calImage = UIImageView()
    
    var attendeesTable = UITableView()
    var attendees = ["Jon Snow","Arya Stark","Ned Stark","Tyrion Lannister","Cersei Lannister","Joffrey Baratheon","The Mountain"]
    var attendeesDetails = ["Night's Watch","House of White and Black","House Stark","House Lannister","House Lannister","House Baratheon","Crazy S.O.B."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        view.addSubview(containerScroll)
        containerScroll.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp_width)
            make.top.equalTo(view.snp_top)
            make.bottom.equalTo(view.snp_bottom)
            make.height.equalTo(view.snp_height)
        }
        containerScroll.scrollEnabled = true
        containerScroll.delegate = self
        containerScroll.backgroundColor = UIColor.blackColor()

        createView()
        navigationItem.title = "Event Details"
        
        if BeaconStarted.beacon.started == false{
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "locationheader"), landscapeImagePhone: UIImage(named: "locationheader"), style: UIBarButtonItemStyle.Plain, target: self, action: "test")
        }else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Radar4"), landscapeImagePhone: UIImage(named: "Radar4"), style: UIBarButtonItemStyle.Plain, target: self, action: "test")
        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if BeaconStarted.beacon.started == false{
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "locationheader"), landscapeImagePhone: UIImage(named: "locationheader"), style: UIBarButtonItemStyle.Plain, target: self, action: "test")
        }else{
//            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Radar4"), landscapeImagePhone: UIImage(named: "Radar4"), style: UIBarButtonItemStyle.Plain, target: self, action: "test")
            let icon = UIImage(named: "Radar4")
            let iconSize = CGRect(origin: CGPointZero, size: icon!.size)
            let iconButton = UIButton(frame: iconSize)
            iconButton.setBackgroundImage(icon, forState: .Normal)
            navigationItem.rightBarButtonItem!.customView = iconButton
//            navigationItem.rightBarButtonItem!.customView!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 6/5)*1000)
            navigationItem.rightBarButtonItem!.customView!.rotate360Degrees()
        }
    }
    
    
    func createView(){
        containerScroll.addSubview(containerView)
        containerView.addSubview(topView)
        containerView.addSubview(bottomView)
        containerScroll.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height-100)
        containerScroll.clipsToBounds = true
        containerScroll.canCancelContentTouches = false
        containerScroll.delaysContentTouches = true
        containerScroll.panGestureRecognizer.delaysTouchesBegan = true
        
        containerView.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(view.snp_height)
            make.width.equalTo(view.snp_width)
        }
        topView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(containerView.snp_top)
            make.width.equalTo(containerView.snp_width)
            make.height.equalTo(containerView.snp_height).multipliedBy(0.35)
        }
        
        bottomView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(containerView.snp_width)
            make.top.equalTo(topView.snp_bottom)
            make.height.equalTo(containerView.snp_height).multipliedBy(0.65)
        }
        bottomView.clipsToBounds = false
        topView.backgroundColor = UIColor.blackColor()
        bottomView.backgroundColor = UIColor.blackColor()
        
        topView.addSubview(topImageView)
        topImageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view.snp_top)
            make.centerX.equalTo(view.snp_centerX)
        }
        widthConstraint = NSLayoutConstraint(item: topImageView, attribute: .Width, relatedBy: .Equal, toItem: topView, attribute: .Width, multiplier: 1.0, constant: 0.0)
        topView.addConstraint(widthConstraint!)
        
        topImageView.image = UIImage(named: EventChosen.events.eventImage)
        topImageView.contentMode = UIViewContentMode.ScaleAspectFill
        topImageView.alpha = 0.3
        
        
        
        topView.addSubview(eventIcon)
        eventIcon.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(topView.snp_width).multipliedBy(0.2)
            make.height.equalTo(topView.snp_width).multipliedBy(0.2)
            make.centerX.equalTo(topView.snp_centerX)
            make.top.equalTo(topView.snp_top).offset(30)
        }
        eventIcon.layer.borderColor = UIColor.whiteColor().CGColor
        eventIcon.layer.borderWidth = 1.0
        eventIcon.layoutIfNeeded()
        eventIcon.layer.cornerRadius = eventIcon.frame.size.width/2.0
        eventIcon.image = UIImage(named: "hilton")
        eventIcon.clipsToBounds = true
        eventIcon.contentMode = UIViewContentMode.ScaleAspectFill
        
        topView.addSubview(eventLabel)
        eventLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(topView.snp_centerX)
            make.top.equalTo(eventIcon.snp_bottom).offset(20)
        }
        eventLabel.textColor = UIColor.whiteColor()
        eventLabel.font = UIFont.systemFontOfSize(20, weight: UIFontWeightRegular)
        eventLabel.textAlignment = NSTextAlignment.Center
        eventLabel.text = EventChosen.events.eventSelected
        
        topView.addSubview(joinButton)
        joinButton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(topView.snp_centerX)
            make.bottom.equalTo(topView.snp_bottom).offset(-27)
            make.width.equalTo(topView.snp_width).multipliedBy(0.35)
            make.height.equalTo(28)
        }
        joinButton.layer.cornerRadius = 4
        joinButton.backgroundColor = UIConstants.primaryColor
        joinButton.setTitle("Check-In", forState: UIControlState.Normal)
        joinButton.titleLabel!.font = UIFont.systemFontOfSize(14)
        joinButton.addTarget(self, action: "startBeacon", forControlEvents: UIControlEvents.TouchUpInside)
        
        bottomView.addSubview(pagingViews)
        pagingViews.scrollEnabled = true
        pagingViews.delegate = self
        pagingViews.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(bottomView.snp_height)
            make.top.equalTo(topView.snp_bottom)
            make.width.equalTo(bottomView.snp_width)
            make.left.equalTo(bottomView.snp_left)
        }
        pagingViews.pagingEnabled = true
        pagingViews.backgroundColor = UIColor.clearColor()
        pagingViews.addSubview(pageViewContainer)
        pagingViews.clipsToBounds = false
        pagingViews.addSubview(subPageView1)
        pagingViews.addSubview(subPageView2)
        
        
        
        let segmented = XMSegmentedControl(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44), segmentTitle: ["About", "Attendees"], selectedItemHighlightStyle: XMSelectedItemHighlightStyle.BottomEdge)
        segmented.backgroundColor = UIColor(red: 20.0/255, green: 20.0/255, blue: 20.0/255, alpha: 1.0)
        segmented.highlightColor = UIColor(white: 1.0, alpha: 0.3)
        segmented.tint = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
        segmented.highlightTint = UIColor.whiteColor()
        segmented.delegate = self
        bottomView.addSubview(segmented)
        
        
        subPageView1.backgroundColor = UIColor(white: 1.0, alpha: 0.05)
        subPageView2.backgroundColor = UIColor(white: 1.0, alpha: 0.05)
        subPageView3.backgroundColor = UIColor(white: 1.0, alpha: 0.05)

        subPageView1.snp_makeConstraints(closure: { (make) -> Void in
            make.width.equalTo(view.snp_width)
            make.top.equalTo(topView.snp_bottom)
            make.height.equalTo(pagingViews.snp_height)
            make.left.equalTo(pagingViews.snp_left)
        })
        
        subPageView2.snp_makeConstraints(closure: { (make) -> Void in
                make.width.equalTo(view.snp_width)
                make.top.equalTo(pagingViews.snp_top)
                make.height.equalTo(pagingViews.snp_height)
                make.left.equalTo(subPageView1.snp_right)
        })
        
        
        
        subPageView1.addSubview(eventDetails)
        eventDetails.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(pagingViews.snp_width).multipliedBy(0.95)
            make.height.equalTo(view.frame.size.height - (topView.frame.size.height+44))
            make.top.equalTo(topView.snp_bottom)
            make.centerX.equalTo(subPageView1.snp_centerX)
        }
        eventDetails.addSubview(eventDetailsTitle)
        eventDetails.addSubview(eventDetailsText)
        eventDetails.addSubview(eventDivider)
        
        
        eventDetailsTitle.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(eventDetails.snp_top).offset(70)
            make.width.equalTo(eventDetails.snp_width).multipliedBy(0.95)
            make.left.equalTo(eventDetails.snp_left).offset(40)
        }
        eventDetailsTitle.textColor = UIColor(white: 1.0, alpha: 0.8)
        eventDetailsTitle.textAlignment = NSTextAlignment.Left
        eventDetailsTitle.text = "Thu, Nov 26 at 7 P.M."
        eventDetailsTitle.font = UIFont.systemFontOfSize(14.5, weight: UIFontWeightMedium)
        
        eventDetailsText.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(eventDetailsTitle.snp_bottom).offset(40)
            make.width.equalTo(eventDetails.snp_width).multipliedBy(0.95)
            make.centerX.equalTo(eventDetails.snp_centerX)
        }
        eventDetailsText.textColor = UIColor(white: 1.0, alpha: 0.8)
        eventDetailsText.textAlignment = NSTextAlignment.Left
        eventDetailsText.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non iaculis lorem. Sed at efficitur purus. Sed auctor venenatis lacus, in accumsan nunc blandit sed. Aliquam semper dolor sed ultrices venenatis. Nulla a sodales ex, eget imperdiet felis. Aenean sit amet dui ut libero efficitur venenatis. Nam sagittis consectetur tristique."
        eventDetailsText.lineBreakMode = NSLineBreakMode.ByWordWrapping
        eventDetailsText.numberOfLines = 0
        eventDetailsText.font = UIFont.systemFontOfSize(12.8, weight: UIFontWeightLight)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 3
        let attributes = [NSParagraphStyleAttributeName : style]
        eventDetailsText.attributedText = NSAttributedString(string: eventDetailsText.text!, attributes:attributes)
        eventDetailsText.font = UIFont.systemFontOfSize(12.8, weight: UIFontWeightLight)
        
        eventDivider.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(eventDetails.snp_width).multipliedBy(0.95)
            make.height.equalTo(1.0)
            make.top.equalTo(eventDetailsTitle.snp_bottom).offset(20)
            make.centerX.equalTo(eventDetails.snp_centerX)
        }
        eventDivider.backgroundColor = UIColor.whiteColor()
        eventDivider.alpha = 0.3
        
        eventDetails.addSubview(calImage)
        calImage.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(eventDivider.snp_left)
            make.width.equalTo(eventDetails.snp_width).multipliedBy(0.06)
            make.height.equalTo(eventDetails.snp_width).multipliedBy(0.06)
            make.centerY.equalTo(eventDetailsTitle.snp_centerY)
        }
        
        calImage.image = UIImage(named: "calendar")
        calImage.image = calImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        calImage.tintColor = UIColor.whiteColor()
        calImage.alpha = 0.7
        calImage.contentMode = UIViewContentMode.ScaleAspectFit
        
        subPageView2.addSubview(attendeesTable)
        attendeesTable.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(pagingViews.snp_width).multipliedBy(0.98)
            make.height.equalTo(pagingViews.snp_height).offset(-88)
            make.top.equalTo(topView.snp_bottom).offset(44)
            make.centerX.equalTo(subPageView2.snp_centerX)
        }
        attendeesTable.backgroundColor = UIColor.clearColor()
        attendeesTable.rowHeight = 74
        attendeesTable.separatorColor = UIColor(white: 1.0, alpha: 0.3)
        attendeesTable.separatorInset = UIEdgeInsetsZero
        attendeesTable.layoutMargins = UIEdgeInsetsZero
        attendeesTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        attendeesTable.dataSource = self
        attendeesTable.delegate = self
        attendeesTable.scrollEnabled = true
        attendeesTable.bounces = true
        attendeesTable.alwaysBounceVertical = true
        attendeesTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        attendeesTable.layer.zPosition = 1

        

    }
    
    override func viewDidLayoutSubviews() {
        pagingViews.contentSize = CGSize(width: view.frame.size.width*2, height: bottomView.frame.size.height)
        view.setNeedsLayout()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = containerScroll.contentOffset.y
        if offsetY < -64.0{
            let width = 1.1 + (-offsetY - 64.0)/64.0
            topView.removeConstraint(widthConstraint!)
            widthConstraint = NSLayoutConstraint(item: topImageView, attribute: .Width, relatedBy: .Equal, toItem: topView, attribute: .Width, multiplier: width, constant: 0.0)
            topView.addConstraint(widthConstraint!)
            topImageView.snp_updateConstraints(closure: { (make) -> Void in
                make.top.equalTo(view.snp_top).offset((-offsetY-64.0))
            })
            view.updateConstraints()
            let alpha = 0.3 + (1.0-((64)/(-offsetY)))
            topImageView.alpha = alpha
            let infoalpha = 1.0 - (1.3-((64)/(-offsetY)))
            eventIcon.alpha = infoalpha
            eventLabel.alpha = infoalpha
            joinButton.alpha = infoalpha
        }else{
            let width = CGFloat(1.0)
            topView.removeConstraint(widthConstraint!)
            widthConstraint = NSLayoutConstraint(item: topImageView, attribute: .Width, relatedBy: .Equal, toItem: topView, attribute: .Width, multiplier: width, constant: 0.0)
            topView.addConstraint(widthConstraint!)
            topImageView.snp_updateConstraints(closure: { (make) -> Void in
                make.top.equalTo(view.snp_top).offset((-offsetY-64.0)/2)
            })
            view.updateConstraints()
            topImageView.alpha = 0.3
            eventLabel.alpha = 1.0
            eventIcon.alpha = 1.0
            joinButton.alpha = 1.0
        }

        let offSetX = pagingViews.contentOffset.x
        print(offSetX)
        
    }
    
    func test(){
        print("Test: \(pageViewContainer.frame.size.width)")
        print("Content Size: \(pagingViews.contentSize.width), \(pagingViews.contentSize.height)")
    }
    
    func startBeacon(){
        presentViewController(ViewController(), animated: true, completion: nil)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

//        cell.textLabel?.textColor = UIColor.whiteColor()
//        cell.textLabel?.font = UIFont.systemFontOfSize(14.5, weight: UIFontWeightRegular)
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.textLabel!.text = attendees[indexPath.row]
        cell.textLabel!.hidden = true
//        cell.indentationLevel = 7
        
        let nameLabel = UILabel(frame: CGRect(x: 70, y: 15, width: 200, height: 20))
        let titleLabel = UILabel(frame: CGRect(x: 70, y: 39, width: 200, height: 20))
        let addButton = UIButton()
        let images = UIImageView(frame: CGRect(x: 13, y: 17, width: 40, height: 40))
        cell.backgroundView = UIView()
        cell.backgroundView?.addSubview(images)
        cell.backgroundView?.addSubview(nameLabel)
        cell.backgroundView?.addSubview(titleLabel)
        cell.contentView.addSubview(addButton)
        images.image = UIImage(named: "jonsnow")
        images.layer.cornerRadius = 20
        images.clipsToBounds = true
        
        nameLabel.text = attendees[indexPath.row]
        nameLabel.font = UIFont.systemFontOfSize(15, weight: UIFontWeightRegular)
        nameLabel.textColor = UIColor.whiteColor()
        
        titleLabel.text = attendeesDetails[indexPath.row]
        titleLabel.font = UIFont.systemFontOfSize(12.5, weight: UIFontWeightRegular)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.alpha = 0.7
        
        addButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(cell.snp_right).offset(-13)
            make.width.equalTo(cell.snp_width).multipliedBy(0.25)
            make.height.equalTo(27)
            make.centerY.equalTo(cell.snp_centerY)
        }
        addButton.layer.cornerRadius = 3.5
        addButton.layer.borderColor = UIColor.grayColor().CGColor
        addButton.layer.borderWidth = 0.5
        addButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        addButton.setTitle("Add Contact", forState: UIControlState.Normal)
        addButton.titleLabel!.font = UIFont.systemFontOfSize(12, weight: UIFontWeightThin)
        addButton.addTarget(self, action: "addUser:", forControlEvents: UIControlEvents.TouchUpInside)

        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendees.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        ProfileChosen.profiles.profileSelected = (cell?.textLabel?.text)!
        
        navigationController?.pushViewController(ProfileViewController(), animated: true)

    }
    
    func addUser(sender: UIButton){
        sender.backgroundColor = UIConstants.primaryColor
        sender.layer.borderColor = nil
        sender.layer.borderWidth = 0.0
        sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        sender.titleLabel?.textColor = UIColor.whiteColor()
        sender.setTitle("Added", forState: UIControlState.Normal)
    }
    
    
    func xmSegmentedControl(xmSegmentedControl: XMSegmentedControl, selectedSegment: Int) {
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2, options: [], animations: { () -> Void in
                self.pagingViews.contentOffset.x = self.view.frame.size.width*CGFloat(selectedSegment)
                }, completion: nil)

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
