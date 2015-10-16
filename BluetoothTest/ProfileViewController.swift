//
//  ProfileViewController.swift
//  BluetoothTest
//
//  Created by Mike Wang on 10/14/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController, UIScrollViewDelegate {
    
    let viewSections = ["Info", "Events", "Notes"]
    
    let scrollView = UIScrollView()
    let topView = UIView()
    let bottomView = UIView()

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
    let backgroundImageView = UIImageView()

    let quoteView = UILabel()
    let descriptionView = UITextView()
    let emailLabelView = UILabel()
    let emailView = UILabel()
    let phoneLabelView = UILabel()
    let phoneView = UILabel()

    let twitterView = UIButton()
    let linkedInView = UIButton()
    let facebookView = UIButton()
    
    let skillsPanelView = UIView()
    let skillsLabel = UILabel()
    
    // Events views
    let eventsView = UIView()

    // Notes views
    let notesView = UIView()
    
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
    }
    
    func handleTwitter(sender: UIButton) {
        print("open twitter")
    }
    
    func setZoomScale() {
        let imageViewSize = coverPhoto.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.zoomScale = 1.0
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return coverPhoto
    }
    
    override func viewDidLayoutSubviews() {
        self.scrollView.contentSize = view.frame.size
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let y = -scrollView.contentOffset.y
        if(y > 0) {
            
        }
    }
    
    func createView() {
        
        // Navigation bar
        navigationItem.title = "Profile"
        let navHeight = navigationController!.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.height
        
        view.backgroundColor = UIColor.blackColor()
        
        let blurEffectDark = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectSegmentView = UIVisualEffectView(effect: blurEffectDark)
        let blurEffectLight = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectCoverPhotoView = UIVisualEffectView(effect: blurEffectLight)

        let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffectLight)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = coverPhoto.bounds
        blurEffectCoverPhotoView.addSubview(vibrancyEffectView)
        
        // --------------------- Add subviews ---------------------
        
        view.addSubview(scrollView)
        scrollView.addSubview(topView)
        scrollView.addSubview(bottomView)

        topView.addSubview(coverPhoto)
        topView.addSubview(blurEffectCoverPhotoView)
        topView.addSubview(profilePicture)
        topView.addSubview(nameView)
        topView.addSubview(titleView)

        bottomView.addSubview(backgroundImageView)
        bottomView.addSubview(blurEffectSegmentView)
        bottomView.addSubview(segmentedControlView)

        bottomView.addSubview(infoView)
        infoView.addSubview(quoteView)
        infoView.addSubview(descriptionView)
        infoView.addSubview(emailLabelView)
        infoView.addSubview(emailView)
        infoView.addSubview(phoneLabelView)
        infoView.addSubview(phoneView)
        infoView.addSubview(twitterView)
        infoView.addSubview(linkedInView)
        infoView.addSubview(facebookView)
        
        scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 4.0
        scrollView.zoomScale = 1.0
        scrollView.scrollEnabled = true
        scrollView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(view.snp_center)
            make.size.equalTo(view.snp_size)
        }
        
        // --------------------- Top View ---------------------
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view.snp_top).offset(navHeight)
            make.left.equalTo(view.snp_left)
            make.right.equalTo(view.snp_right)
            make.bottom.equalTo(titleView.snp_bottom).offset(UIConstants.spacing1)
        }
        
        coverPhoto.translatesAutoresizingMaskIntoConstraints = false
        coverPhoto.image = UIImage(named: "nightswatch.png")
        coverPhoto.contentMode = .ScaleAspectFill
        coverPhoto.alpha = CGFloat(UIConstants.alphaHighFade)
        coverPhoto.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(topView.snp_center)
            make.size.equalTo(topView.snp_size)
        }
        
        blurEffectCoverPhotoView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(coverPhoto.snp_center)
            make.size.equalTo(coverPhoto.snp_size)
        }
        
        // Profile pic
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        profilePicture.image = UIImage(named: "jonsnow.png")
        profilePicture.contentMode = .ScaleAspectFit
        profilePicture.layer.cornerRadius = CGFloat(UIConstants.profilePictureSize/2)
        profilePicture.layer.borderWidth = 2
        profilePicture.layer.borderColor = UIColor.whiteColor().CGColor
        profilePicture.clipsToBounds = true
        profilePicture.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view.snp_top).offset(CGFloat(UIConstants.spacing1) + navHeight)
            make.centerX.equalTo(view.snp_centerX)
            make.size.equalTo(CGSize(width: UIConstants.profilePictureSize, height: UIConstants.profilePictureSize))
        }
        
        // Profile name
        nameView.translatesAutoresizingMaskIntoConstraints = false
        nameView.text = "Jon Snow"
        nameView.textColor = UIColor.whiteColor()
        nameView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(profilePicture.snp_bottom).offset(UIConstants.spacing0)
            make.centerX.equalTo(view.snp_centerX)
            make.width.equalTo(nameView.intrinsicContentSize().width)
            make.height.equalTo(nameView.intrinsicContentSize().height)
        }
        
        // Professional title
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.text = "Lord Commander, The Night's Watch"
        titleView.textColor = UIColor.lightGrayColor()
        titleView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(nameView.snp_bottom)
            make.centerX.equalTo(view.snp_centerX)
            make.width.equalTo(titleView.intrinsicContentSize().width)
            make.height.equalTo(titleView.intrinsicContentSize().height)
        }
        
        // --------------------- Bottom View ---------------------
        bottomView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(topView.snp_bottom)
            make.bottom.equalTo(view.snp_bottom).offset(200)
            make.width.equalTo(view.snp_width)
        }
        
        // Set the bottom view background image
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        backgroundImageView.image = UIImage(named: "jonsnow.png")!
        backgroundImageView.alpha = CGFloat(UIConstants.alphaHighFade)
        backgroundImageView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(bottomView.snp_center)
            make.size.equalTo(bottomView.snp_size)
        }
        
        blurEffectSegmentView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(bottomView.snp_center)
            make.size.equalTo(bottomView.snp_size)
        }
        
        segmentedControlView.translatesAutoresizingMaskIntoConstraints = false
        segmentedControlView.layer.borderWidth = CGFloat(UIConstants.borderThin)
        segmentedControlView.layer.borderColor = UIColor.whiteColor().CGColor
        segmentedControlView.tintColor = UIColor.whiteColor()
        segmentedControlView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bottomView.snp_top)
            make.left.equalTo(view.snp_left)
            make.right.equalTo(view.snp_right)
        }
        segmentedControlView.addTarget(self, action: "changeSegment:", forControlEvents: .ValueChanged)
        segmentedControlView.selectedSegmentIndex = 0

        // --------------------- Bottom View ---------------------
        infoView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(segmentedControlView.snp_bottom)
        }
        
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.backgroundColor = UIColor.clearColor()
        descriptionView.textColor = UIColor.whiteColor()
        descriptionView.scrollEnabled = false
        descriptionView.text = "My name is Jon Snow. I am Lord Commander of the Night's Watch, steward of justice and killer of white walkers. I am son to a murdered father, brother to murdered kin, husband to a murdered wife, I'm not sure who my mother was, and I was murdered too. And I will have my vengenace, in this life or the next."
        descriptionView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(segmentedControlView.snp_bottom).offset(UIConstants.spacing1)
            make.left.equalTo(bottomView.snp_left).offset(UIConstants.spacing1)
            make.right.equalTo(bottomView.snp_right).offset(-UIConstants.spacing1)
//            make.height.equalTo(descriptionView.contentSize)
        }
        
        formatLabel(emailLabelView, text: "Email: ", color: UIColor.lightGrayColor())
        emailLabelView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(descriptionView.snp_bottom).offset(UIConstants.spacing1)
            make.left.equalTo(bottomView.snp_left).offset(UIConstants.spacing1)
        }
        
        formatLabel(emailView, text: "jsnow@winterfell.edu", color: UIColor.whiteColor())
        emailView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(descriptionView.snp_bottom).offset(UIConstants.spacing1)
            make.left.equalTo(emailLabelView.snp_right).offset(UIConstants.spacing0)
        }
        
        formatLabel(phoneLabelView, text: "Phone: ", color: UIColor.lightGrayColor())
        phoneLabelView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(emailLabelView.snp_bottom).offset(UIConstants.spacing0)
            make.left.equalTo(bottomView.snp_left).offset(UIConstants.spacing1)
        }
        
        formatLabel(phoneView, text: "424-242-4242", color: UIColor.whiteColor())
        phoneView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(emailView.snp_bottom).offset(UIConstants.spacing0)
            make.left.equalTo(phoneLabelView.snp_right).offset(UIConstants.spacing0)
        }
        
        formatButton(twitterView, title: "\u{f271}", action: "handleTwitter:", delegate: self)
        twitterView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(phoneView.snp_bottom).offset(UIConstants.spacing1)
            make.left.equalTo(bottomView.snp_left)
            make.width.equalTo(bottomView.frame.width/3)
        }
//
//        formatLabel(phoneView, text: "424-242-4242", color: UIColor.whiteColor())
//        phoneView.snp_makeConstraints { (make) -> Void in
//            make.top.equalTo(emailView.snp_bottom).offset(UIConstants.spacing0)
//            make.left.equalTo(phoneLabelView.snp_right).offset(UIConstants.spacing0)
//        }
        
//        label.text = "\u{f271} Create Event"
//        label.font = UIFont(name: "FontAwesome", size: 30)

        
//        infoView.addSubview(quoteView)

//        infoView.addSubview(twitterView)
//        infoView.addSubview(linkedInView)
//        infoView.addSubview(facebookView)
    
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
