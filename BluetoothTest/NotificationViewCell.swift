//
//  NotificationViewCell.swift
//  BluetoothTest
//
//  Created by Mike Wang on 10/26/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import UIKit

class NotificationViewCell: UITableViewCell {

    let backgroundImage = UIImageView()
    let profilePicView = UIImageView()
    let nameLabel = UILabel()
    let acceptButton = UIButton(type: .System)
    let rejectButton = UIButton(type: .System)
    let dateLabel = UILabel()
    let locationIcon = UIImageView()
    let locationLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let blurEffectDark = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let cellBackgroundView = UIVisualEffectView(effect: blurEffectDark)
        
        contentView.addSubview(backgroundImage)
        contentView.addSubview(cellBackgroundView)
        contentView.addSubview(profilePicView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(locationIcon)
        contentView.addSubview(locationLabel)
        contentView.addSubview(acceptButton)
        contentView.addSubview(rejectButton)
        contentView.clipsToBounds = true
        
        // Cell background image and blur
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
        backgroundImage.clipsToBounds = true
        backgroundImage.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(contentView.snp_center)
            make.size.equalTo(contentView.snp_size)
        }
        cellBackgroundView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(contentView.snp_center)
            make.size.equalTo(contentView.snp_size)
        }
        
        // Profile pic
        profilePicView.contentMode = UIViewContentMode.ScaleAspectFill
        profilePicView.clipsToBounds = true
        profilePicView.layer.cornerRadius = CGFloat(UIConstants.profilePictureSizeSmall)/2
        profilePicView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_left).offset(UIConstants.spacing0)
            make.centerY.equalTo(contentView.snp_centerY)
            make.width.equalTo(UIConstants.profilePictureSizeSmall)
            make.height.equalTo(UIConstants.profilePictureSizeSmall)
        }
        
        // Name label
        formatLabel(nameLabel, text: "", color: UIColor.whiteColor(), font: UIFont.systemFontOfSize(UIConstants.fontSmallish, weight: UIFontWeightRegular), layout: false)
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(profilePicView.snp_top)
            make.left.equalTo(profilePicView.snp_right).offset(UIConstants.spacing0)
            make.right.equalTo(rejectButton.snp_left).offset(-UIConstants.spacing0)
        }
        
        // Location icon and text
        locationIcon.image = UIImage(named: "location.png")
        locationIcon.contentMode = UIViewContentMode.ScaleAspectFit
        locationIcon.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(nameLabel.snp_bottom)
            make.left.equalTo(profilePicView.snp_right).offset(UIConstants.spacing0)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        formatLabel(locationLabel, text: "", color: UIColor.whiteColor(), font: UIFont.systemFontOfSize(UIConstants.fontSmall, weight: UIFontWeightRegular), layout: false)
        locationLabel.font = UIFont.systemFontOfSize(12, weight: UIFontWeightRegular)
        locationLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(locationIcon.snp_top)//.offset(UIConstants.spacing0)
            make.left.equalTo(locationIcon.snp_right).offset(UIConstants.spacing0)
            make.right.equalTo(rejectButton.snp_left).offset(-UIConstants.spacing0)
        }
        
        // Date label
        formatLabel(dateLabel, text: "", color: UIColor.whiteColor(), font: UIFont.systemFontOfSize(UIConstants.fontSmall, weight: UIFontWeightRegular), layout: false)
        dateLabel.font = UIFont.systemFontOfSize(12, weight: UIFontWeightRegular)
        dateLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(locationIcon.snp_bottom)
            make.left.equalTo(profilePicView.snp_right).offset(UIConstants.spacing0)
            make.right.equalTo(rejectButton.snp_left).offset(-UIConstants.spacing0)
        }
        
        // Reject button
        rejectButton.titleLabel!.font = UIFont(name: "FontAwesome", size: UIConstants.fontMed)
        formatButton(rejectButton, title: "\u{f00d}", color: UIConstants.defaultTextColor, action: nil, delegate: nil)
        rejectButton.layer.cornerRadius = UIConstants.buttonCircleSize/2
        rejectButton.layer.borderColor = UIConstants.defaultTextColor.CGColor
        rejectButton.layer.borderWidth = UIConstants.borderThin
        rejectButton.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(contentView.snp_centerY)
            make.right.equalTo(acceptButton.snp_left).offset(-UIConstants.spacing0)
            make.height.equalTo(UIConstants.buttonCircleSize)
            make.width.equalTo(UIConstants.buttonCircleSize)
        }
        
        // Accept button
        acceptButton.titleLabel!.font = UIFont(name: "FontAwesome", size: UIConstants.fontMed)
        formatButton(acceptButton, title: "\u{f00c}", color: UIConstants.successColor, action: nil, delegate: nil)
        acceptButton.layer.cornerRadius = UIConstants.buttonCircleSize/2
        acceptButton.layer.borderColor = UIConstants.successColor.CGColor
        acceptButton.layer.borderWidth = UIConstants.borderThin
        acceptButton.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(contentView.snp_centerY)
            make.right.equalTo(contentView.snp_right).offset(-UIConstants.spacing0)
            make.height.equalTo(UIConstants.buttonCircleSize)
            make.width.equalTo(UIConstants.buttonCircleSize)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        print("what")
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        print("awake from nib")
        

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
