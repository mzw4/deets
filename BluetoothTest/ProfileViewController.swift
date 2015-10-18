//
//  ProfileViewController.swift
//  BluetoothTest
//
//  Created by Mike Wang on 10/14/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController, UIScrollViewDelegate,
    UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    // TEMP
    var sampleEvents = ["Entrepreneurs Meetup", "Hilton Networking Event", "VC Meet & Greet", "Cornell Tech Meetup", "Comic Con: San Diego","Cornell Career Fair"]
    var eventImages = ["event.jpg","event2.jpg","event3.jpg","event4.jpg","event5.png","event.jpg"]
    var dates = ["10/25/2015","11/04/2015","11/11/2015","12/14/2015","12/16/2015","01/12/2015"]
    var locations = ["Javits Center","Hilton Union Square","W. Hotel Midtown West","Cornell Tech NYC","San Diego Convention Center","Cornell Tech NYC"]
    // END TEMP
    
    let viewSections = ["Info", "Events", "Notes"]
    
    let scrollView = UIScrollView()
    let topView = UIView()
    let bottomView = UIView()
    
    let topViewRestingHeight = CGFloat(Double(2 * UIConstants.spacing1 + UIConstants.spacing0 + UIConstants.profilePictureSize) + 2 * UIConstants.textHeight)
    let topDetailsContainer = UIView()
    let profilePicture = UIImageView()
    let coverPhoto = UIImageView()
    let nameView = UILabel()
    let titleView = UILabel()
    
    // Section buttons
    let segmentedControlView = UISegmentedControl(items: ["Info", "Events", "Notes"])
    let infoButton = UIButton(type: UIButtonType.System)
    let eventsButton = UIButton(type: UIButtonType.System)
    let notesButton = UIButton(type: UIButtonType.System)
    
    // Info views
    let infoView = UIView()
    let infoScrollView = UIScrollView()
    let backgroundImageView = UIImageView()

    let quoteView = UILabel()
    let descriptionView = UITextView()
    let emailLabelView = UILabel()
    let emailView = UILabel()
    let phoneLabelView = UILabel()
    let phoneView = UILabel()

    let twitterView = UIButton(type: UIButtonType.System)
    let linkedInView = UIButton(type: UIButtonType.System)
    let facebookView = UIButton(type: UIButtonType.System)
    
    let skillsPanelView = UIView()
    let skillsLabel = UILabel()
    
    // Events views
    let eventsView = UIView()
    var eventTable = UITableView()

    // Notes views
    let notesView = UIView()
    let notesFieldView = UITextView()
    let noteIcon = UILabel()

    func changeSegment(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            infoView.hidden = false
            eventsView.hidden = true
            notesView.hidden = true
        case 1:
            infoView.hidden = true
            eventsView.hidden = false
            notesView.hidden = true
        case 2:
            infoView.hidden = true
            eventsView.hidden = true
            notesView.hidden = false
        default:
            break;
        }
        view.endEditing(true)
    }
    
    func handleTwitter(sender: UIButton) {
        print("open twitter")
    }
    
    func handleLinkedIn(sender: UIButton) {
        print("open linkedin")
    }
    
    func handleFacebook(sender: UIButton) {
        print("open facebook")
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return coverPhoto
    }
    
    override func viewDidLayoutSubviews() {
        self.scrollView.contentSize = CGSize(width: view.frame.width, height: topViewRestingHeight)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // reveal cover photo and fade profile details when scrolled
        // fully faded when cover photo is 1.5 * its original height)
        let ratioRevealed = (topView.frame.height - topViewRestingHeight)/(0.5 * topViewRestingHeight)
        print("scrolled \(ratioRevealed)")

        coverPhoto.alpha = max(UIConstants.alphaHighFade, CGFloat(UIConstants.alphaHighFade) + ratioRevealed * (1 - CGFloat(UIConstants.alphaHighFade)))
        topDetailsContainer.alpha = 1 - ratioRevealed
    }
    
    func createView() {
        
        // Navigation bar
        navigationItem.title = "Profile"
        let navHeight = navigationController!.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.height
        let tabHeight = tabBarController!.tabBar.frame.height

        view.backgroundColor = UIColor.blackColor()
        
        let blurEffectDark = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectSegmentView = UIVisualEffectView(effect: blurEffectDark)
        let blurEffectLight = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectCoverPhotoView = UIVisualEffectView(effect: blurEffectLight)

//        let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffectLight)
//        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
//        vibrancyEffectView.frame = coverPhoto.bounds
//        blurEffectCoverPhotoView.addSubview(vibrancyEffectView)
        
        // --------------------- Add subviews ---------------------
        
        view.addSubview(scrollView)
        scrollView.addSubview(topView)
        scrollView.addSubview(bottomView)

        // top view contains profile pic, name and title
        topView.addSubview(coverPhoto)
        topView.addSubview(blurEffectCoverPhotoView)
        topView.addSubview(topDetailsContainer)
        topDetailsContainer.addSubview(profilePicture)
        topDetailsContainer.addSubview(nameView)
        topDetailsContainer.addSubview(titleView)

        bottomView.addSubview(backgroundImageView)
        bottomView.addSubview(blurEffectSegmentView)

        bottomView.addSubview(infoScrollView)
        infoScrollView.addSubview(infoView)
        infoView.addSubview(quoteView)
        infoView.addSubview(descriptionView)
        infoView.addSubview(emailLabelView)
        infoView.addSubview(emailView)
        infoView.addSubview(phoneLabelView)
        infoView.addSubview(phoneView)
        
        infoView.addSubview(twitterView)
        infoView.addSubview(linkedInView)
        infoView.addSubview(facebookView)
        
        bottomView.addSubview(notesView)
        notesView.addSubview(noteIcon)
        notesView.addSubview(notesFieldView)
        
        bottomView.addSubview(eventsView)
        eventsView.addSubview(eventTable)

        bottomView.addSubview(segmentedControlView)

        // --------------------- Scroll View ---------------------

        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
        scrollView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view.snp_top)
            make.width.equalTo(view.snp_width)
            make.height.equalTo(view.frame.height - tabHeight)
        }
        
        // --------------------- Top View ---------------------
        
        topView.snp_makeConstraints { (make) -> Void in
            // Keep the top fixed to the top of the view, and the
            // bottom a fixed distance from the top of the scrollView, so the height will
            // expand when then view is scrolled
            make.top.equalTo(view.snp_top).offset(navHeight)
            make.width.equalTo(scrollView.snp_width)
            make.centerX.equalTo(scrollView.snp_centerX)
            make.bottom.equalTo(scrollView.snp_top).offset(topViewRestingHeight)
            make.height.greaterThanOrEqualTo(CGFloat(2 * UIConstants.spacing1) + topViewRestingHeight)
        }
        
        topDetailsContainer.snp_makeConstraints { (make) -> Void in
            // Top details container has a fixed height and is
            // always centered in the top view when scrolled
            make.centerY.equalTo(topView.snp_centerY)
            make.width.equalTo(topView.snp_width)
            make.height.equalTo(topViewRestingHeight - CGFloat(2 * UIConstants.spacing1))
        }
        
        // Profile pic
        profilePicture.image = UIImage(named: "jonsnow.png")
        profilePicture.contentMode = .ScaleAspectFit
        profilePicture.layer.cornerRadius = CGFloat(UIConstants.profilePictureSize/2)
        profilePicture.layer.borderWidth = 2
        profilePicture.layer.borderColor = UIColor.whiteColor().CGColor
        profilePicture.clipsToBounds = true
        profilePicture.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(topDetailsContainer.snp_top)
            make.centerX.equalTo(topDetailsContainer.snp_centerX)
            make.size.equalTo(CGSize(width: UIConstants.profilePictureSize, height: UIConstants.profilePictureSize))
        }

        // Profile name
        formatLabel(nameView, text: "Jon Snow", color: UIColor.whiteColor(), fontName: UIConstants.systemFont, fontSize: UIConstants.fontSmallish)
        nameView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(profilePicture.snp_bottom).offset(UIConstants.spacing0)
            make.centerX.equalTo(topDetailsContainer.snp_centerX)
        }
        
        // Professional title
        formatLabel(titleView, text: "Lord Commander, The Night's Watch", color: UIColor.lightGrayColor(), fontName: UIConstants.systemFont, fontSize: UIConstants.fontSmallish)
        titleView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(nameView.snp_bottom)
            make.centerX.equalTo(topDetailsContainer.snp_centerX)
        }

        coverPhoto.image = UIImage(named: "nightswatch.png")
        coverPhoto.contentMode = .ScaleAspectFill
        coverPhoto.alpha = CGFloat(UIConstants.alphaHighFade)
        coverPhoto.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(topView.snp_top)
            make.bottom.equalTo(topView.snp_bottom)
            make.width.equalTo(topView.snp_width)
        }
        
        blurEffectCoverPhotoView.snp_makeConstraints { (make) -> Void in
//            make.center.equalTo(coverPhoto.snp_center)
//            make.size.equalTo(coverPhoto.snp_size)
        }
        
        // --------------------- Bottom View ---------------------
        
        bottomView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        bottomView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(topView.snp_bottom)
            make.bottom.equalTo(view.snp_bottom).offset(-tabHeight)
            make.width.equalTo(scrollView.snp_width)
        }
        
        // Set the bottom view background image
        backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        backgroundImageView.image = UIImage(named: "jonsnow.png")!
        backgroundImageView.clipsToBounds = true
        backgroundImageView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(bottomView.snp_center)
            make.size.equalTo(bottomView.snp_size)
        }
        
        blurEffectSegmentView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(bottomView.snp_center)
            make.size.equalTo(bottomView.snp_size)
        }
        
        segmentedControlView.layer.borderWidth = CGFloat(UIConstants.borderThin)
        segmentedControlView.layer.borderColor = UIColor.whiteColor().CGColor
        segmentedControlView.tintColor = UIColor.whiteColor()
        segmentedControlView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bottomView.snp_top)
            make.left.equalTo(bottomView.snp_left)
            make.right.equalTo(bottomView.snp_right)
        }
        segmentedControlView.addTarget(self, action: "changeSegment:", forControlEvents: .ValueChanged)
        segmentedControlView.selectedSegmentIndex = 0
        segmentedControlView.backgroundColor = UIConstants.veryFadedColor
        
        // --------------------- Info View ---------------------

        infoScrollView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(segmentedControlView.snp_bottom)
            make.centerX.equalTo(bottomView.snp_centerX)
            make.bottom.equalTo(bottomView.snp_bottom)
            make.width.equalTo(bottomView.snp_width)
        }
        
        infoView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(infoScrollView.snp_top)
            make.centerX.equalTo(bottomView.snp_centerX)
            make.width.equalTo(bottomView.snp_width)
            make.bottom.equalTo(linkedInView.snp_bottom).offset(UIConstants.spacing1)
        }
        
        formatLabel(quoteView, text: "\u{f10d}", color: UIColor.whiteColor())
        quoteView.font = UIFont(name: "FontAwesome", size: 18)
        quoteView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(infoView.snp_top).offset(UIConstants.spacing1)
            make.left.equalTo(infoView.snp_left).offset(UIConstants.spacing1)
        }
        
        descriptionView.backgroundColor = UIColor.clearColor()
        descriptionView.textColor = UIColor.whiteColor()
        descriptionView.scrollEnabled = false
//        descriptionView.editable = false
        descriptionView.font = UIFont(name: UIConstants.fontRegular, size: CGFloat(UIConstants.fontSmall))
        descriptionView.text = "My name is Jon Snow. I am Lord Commander of the Night's Watch, steward of justice and killer of white walkers. I am son to a murdered father, brother to murdered kin, husband to a murdered wife, I'm not sure who my mother was, and I was murdered too. And I will have my vengenace, in this life or the next."
        descriptionView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(infoView.snp_top).offset(UIConstants.spacing1)
            make.left.equalTo(quoteView.snp_right).offset(UIConstants.spacing0)
            make.right.equalTo(infoView.snp_right).offset(-UIConstants.spacing1)
        }
        
        formatLabel(emailLabelView, text: "Email: ", color: UIColor.lightGrayColor())
        emailLabelView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(descriptionView.snp_bottom).offset(UIConstants.spacing1)
            make.left.equalTo(infoView.snp_left).offset(UIConstants.spacing1)
        }
        
        formatLabel(emailView, text: "jsnow@winterfell.edu", color: UIColor.whiteColor())
        emailView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(descriptionView.snp_bottom).offset(UIConstants.spacing1)
            make.left.equalTo(emailLabelView.snp_right).offset(UIConstants.spacing0)
        }
        
        formatLabel(phoneLabelView, text: "Phone: ", color: UIColor.lightGrayColor())
        phoneLabelView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(emailLabelView.snp_bottom).offset(UIConstants.spacing0)
            make.left.equalTo(infoView.snp_left).offset(UIConstants.spacing1)
        }

        formatLabel(phoneView, text: "424-242-4242", color: UIColor.whiteColor())
        phoneView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(emailView.snp_bottom).offset(UIConstants.spacing0)
            make.left.equalTo(phoneLabelView.snp_right).offset(UIConstants.spacing0)
        }
        
        formatButton(linkedInView, title: "\u{f0e1}", action: "handleLinkedIn:", delegate: self)
        linkedInView.titleLabel?.font = UIFont(name: "FontAwesome", size: 30)
        linkedInView.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(twitterView.snp_centerY)
            make.centerX.equalTo(infoView.snp_centerX)
            make.width.equalTo((linkedInView.titleLabel?.intrinsicContentSize().width)!)
        }
        linkedInView.layoutIfNeeded()
        print(linkedInView.frame.width)
        
        formatButton(twitterView, title: "\u{f099}", action: "handleTwitter:", delegate: self)
        twitterView.titleLabel?.font = UIFont(name: "FontAwesome", size: 30)
        twitterView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(phoneView.snp_bottom).offset(UIConstants.spacing1)
            make.right.equalTo(linkedInView.snp_left).offset(-UIConstants.spacing1)
            make.width.equalTo((twitterView.titleLabel?.intrinsicContentSize().width)!)
        }
        twitterView.layoutIfNeeded()

        formatButton(facebookView, title: "\u{f09a}", action: "handleFacebook:", delegate: self)
        facebookView.titleLabel?.font = UIFont(name: "FontAwesome", size: 30)
        facebookView.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(twitterView.snp_centerY)
            make.left.equalTo(linkedInView.snp_right).offset(UIConstants.spacing1)
            make.width.equalTo((facebookView.titleLabel?.intrinsicContentSize().width)!)
        }
        facebookView.layoutIfNeeded()
        
        infoView.layoutIfNeeded()
        infoScrollView.contentSize = CGSize(width: infoView.frame.width, height: infoView.frame.height)
        
        // --------------------- Events View ---------------------
        
        eventsView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(segmentedControlView.snp_bottom)
            make.width.equalTo(bottomView.snp_width)
            make.bottom.equalTo(bottomView.snp_bottom)
        }
        eventsView.hidden = true
        
        eventTable.backgroundColor = UIColor.blackColor()
        eventTable.separatorColor = UIColor(white: 1.0, alpha: 0.2)
//        eventTable.separatorInset = UIEdgeInsetsZero
//        eventTable.layoutMargins = UIEdgeInsetsZero
//        eventTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        eventTable.dataSource = self
        eventTable.delegate = self
        eventTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        eventTable.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(eventsView.snp_center)
            make.size.equalTo(eventsView.snp_size)
        }
        eventTable.rowHeight = UITableViewAutomaticDimension
        eventTable.estimatedRowHeight = 100
        
        // --------------------- Notes View ---------------------
        
        notesView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(segmentedControlView.snp_bottom)
            make.centerX.equalTo(bottomView.snp_centerX)
            make.bottom.equalTo(bottomView.snp_bottom)
            make.width.equalTo(bottomView.snp_width)
        }
        notesView.hidden = true

        formatLabel(noteIcon, text: "\u{f044}", color: UIColor.whiteColor())
        noteIcon.font = UIFont(name: "FontAwesome", size: 18)
        noteIcon.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(segmentedControlView.snp_bottom).offset(UIConstants.spacing1)
            make.left.equalTo(notesView.snp_left).offset(UIConstants.spacing1)
        }
        
        notesFieldView.backgroundColor = UIColor.clearColor()
        notesFieldView.textColor = UIColor.whiteColor()
        notesFieldView.tintColor = UIColor.whiteColor()
        notesFieldView.delegate = self
        notesFieldView.editable = true
        notesFieldView.scrollEnabled = true
        notesFieldView.font = UIFont(name: UIConstants.fontRegular, size: CGFloat(UIConstants.fontSmall))
        notesFieldView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(noteIcon.snp_bottom).offset(UIConstants.spacing0)
            make.left.equalTo(notesView.snp_left).offset(UIConstants.spacing1)
            make.right.equalTo(notesView.snp_right).offset(-UIConstants.spacing1)
            make.bottom.equalTo(notesView.snp_bottom).offset(-UIConstants.spacing1)
        }
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: 200)//view.frame.height - navHeight - tabHeight)
        print(navHeight)
        print(tabHeight)
        
        print(view.frame.size)
        print(scrollView.frame.height)
        print(scrollView.contentSize)
        print(topView.frame.height)
        print(bottomView.frame.height)
        print(eventsView.frame.height)
    }
    
    // --------------------- TextView delegate functions ---------------------

    func textViewDidBeginEditing(textView: UITextView) {
//        var scrollPoint : CGPoint = CGPointMake(0, notesFieldView.frame.origin.y)
//        self.scrollView.setContentOffset(scrollPoint, animated: true)
        
        notesFieldView.scrollRangeToVisible(NSMakeRange(notesFieldView.text.characters.count - 1, 1))
//        print("editting")
    }
    
    func textViewDidChange(textView: UITextView) {
        notesFieldView.scrollRangeToVisible(NSMakeRange(notesFieldView.text.characters.count - 1, 1))
        print("editting")
    }
    
    // --------------------- Table delegate functions ---------------------

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel!.text = sampleEvents[indexPath.row]
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont.systemFontOfSize(CGFloat(UIConstants.fontSmallish), weight: UIFontWeightLight)
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
        cell.textLabel?.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(cell.snp_top).offset(UIConstants.spacing1)
            make.left.equalTo(cell.snp_left).offset(UIConstants.spacing1)
        }
        
        let dateLabel = UILabel()//frame: CGRectMake(16, 170, view.frame.width/2, 30))
        let locationIcon = UIImageView()//frame: CGRectMake(13, 137, 20, 20))
        let imageView = UIImageView()//frame: CGRectMake(0, -20, view.frame.width, 245))
        let shadowView = UIImageView(frame: CGRectMake(0, 0, view.frame.width, 225))
        let locationLabel = UILabel()//frame: CGRectMake(40, 134, view.frame.width-50, 30))
        
        cell.clipsToBounds = true
        cell.backgroundView = UIView()
        cell.backgroundView!.alpha = UIConstants.alphaMedFade
        cell.backgroundView!.addSubview(imageView)
        cell.backgroundView!.addSubview(shadowView)
        cell.backgroundView!.addSubview(dateLabel)
        cell.backgroundView!.addSubview(locationIcon)
        cell.backgroundView!.addSubview(locationLabel)
        cell.backgroundView?.clipsToBounds = true
        
        imageView.image = UIImage(named: eventImages[indexPath.row])
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.alpha = UIConstants.alphaMedFade
        imageView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(cell.snp_center)
            make.size.equalTo(cell.snp_size)
        }
        
//        shadowView.image = UIImage(named: "shadow.png")
//        shadowView.contentMode = UIViewContentMode.ScaleAspectFill
//        shadowView.clipsToBounds = true
        
        dateLabel.textColor = UIColor.whiteColor()
        dateLabel.font = UIFont.systemFontOfSize(15, weight: UIFontWeightLight)
        dateLabel.text = dates[indexPath.row]
        dateLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(cell.snp_top).offset(UIConstants.spacing1)
            make.right.equalTo(cell.snp_right).offset(-UIConstants.spacing1)
        }
        
        locationIcon.image = UIImage(named: "location.png")
        locationIcon.contentMode = UIViewContentMode.ScaleAspectFit
        locationIcon.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(cell.textLabel!.snp_bottom).offset(UIConstants.spacing0)
            make.left.equalTo(cell.textLabel!.snp_left)//.offset(UIConstants.spacing1)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        locationLabel.text = locations[indexPath.row]
        locationLabel.font = UIFont.systemFontOfSize(17, weight: UIFontWeightRegular)
        locationLabel.textColor = UIColor.whiteColor()
        locationLabel.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(locationIcon.snp_bottom)//.offset(UIConstants.spacing1)
            make.left.equalTo(locationIcon.snp_right).offset(UIConstants.spacing0)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        rowToSelect = indexPath.row
//        rowTapped += 1
//        print(rowTapped)
//        if rowTapped == 2{
//            EventChosen.events.eventSelected = sampleEvents[indexPath.row]
//            EventChosen.events.eventImage = eventImages[indexPath.row]
//            startEvent()
//            rowTapped = 0
//        }
//        
//        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
//        selectedCell.backgroundView!.alpha = 0.7
//        selectedCell.textLabel?.font = UIFont.systemFontOfSize(25, weight: UIFontWeightRegular)
//        
//        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
//            selectedCell.textLabel?.alpha = 1.0
//            }, completion: nil)
//        
//        tableView.selectRowAtIndexPath(NSIndexPath(forRow: rowToSelect, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.None)
//        
//        if indexPath.row != 0{
//            self.tableView(self.eventTable, didDeselectRowAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))
//            rowTapped = 1
//        }
//        
//        
//        tableView.beginUpdates()
//        tableView.endUpdates()
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        let deselectedCell:UITableViewCell? = tableView.cellForRowAtIndexPath(indexPath)
//        
//        deselectedCell?.backgroundView!.alpha = 0.13
//        deselectedCell?.textLabel?.font = UIFont.systemFontOfSize(20, weight: UIFontWeightLight)
//        deselectedCell?.textLabel?.alpha = 0.5
//        
//        rowTapped = 0
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleEvents.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        

    }

}
