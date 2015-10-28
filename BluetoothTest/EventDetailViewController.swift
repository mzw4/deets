//
//  EventDetailViewController.swift
//  BluetoothTest
//
//  Created by Vivek Sudarsan on 10/26/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import UIKit
import SnapKit


class EventDetailViewController: UIViewController, UIScrollViewDelegate{
    
    var containerScroll = UIScrollView()
    var containerView = UIView()
    
    var topView = UIView()
    var topImageView = UIImageView()
    var eventLabel = UILabel()
    
    
    var bottomView = UIView()
    var widthConstraint:NSLayoutConstraint?


    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        
        view.addSubview(containerScroll)
        containerScroll.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp_width)
            make.top.equalTo(view.snp_top)
            make.bottom.equalTo(view.snp_bottom)
        }
        containerScroll.scrollEnabled = true
        containerScroll.delegate = self
        containerScroll.backgroundColor = UIColor.blackColor()
        createView()
        navigationItem.title = "Event Details"
    }
    
    
    func createView(){
        containerScroll.addSubview(containerView)
        containerView.addSubview(topView)
        containerView.addSubview(bottomView)
        containerScroll.contentSize = CGSize(width: view.frame.size.width, height: 600)
        
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
            make.height.equalTo(600)
        }
        
        topView.backgroundColor = UIColor.blackColor()
        bottomView.backgroundColor = UIColor.blackColor()
        
        topView.addSubview(topImageView)
        topImageView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(bottomView.snp_top)
            make.centerX.equalTo(view.snp_centerX)
        }
        
        widthConstraint = NSLayoutConstraint(item: topImageView, attribute: .Width, relatedBy: .Equal, toItem: topView, attribute: .Width, multiplier: 1.0, constant: 0.0)
        topView.addConstraint(widthConstraint!)
        
        topImageView.image = UIImage(named: EventChosen.events.eventImage)
        topImageView.contentMode = UIViewContentMode.ScaleAspectFill
        topImageView.alpha = 0.3
        
        topView.addSubview(eventLabel)
        eventLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(topView.snp_centerX)
            make.top.equalTo(topView.snp_bottom).offset(-50)
        }
        eventLabel.textColor = UIColor.whiteColor()
        eventLabel.font = UIFont.systemFontOfSize(20, weight: UIFontWeightRegular)
        eventLabel.textAlignment = NSTextAlignment.Center
        eventLabel.text = EventChosen.events.eventSelected
        
        
        
        bottomView.addSubview(segment)
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = containerScroll.contentOffset.y
        let width = 1.0 + (-offsetY - 64.0)/66.0
        let alpha = 0.3 + (1.0-((64)/(-offsetY)))
        let infoalpha = 1.0 - (1.0-((64)/(-offsetY)))
        topView.removeConstraint(widthConstraint!)
        widthConstraint = NSLayoutConstraint(item: topImageView, attribute: .Width, relatedBy: .Equal, toItem: topView, attribute: .Width, multiplier: width, constant: 0.0)
        topView.addConstraint(widthConstraint!)
        topImageView.alpha = alpha
        eventLabel.alpha = infoalpha
        

        print(infoalpha)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
