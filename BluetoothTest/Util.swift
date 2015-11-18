//
//  Util.swift
//  BluetoothTest
//
//  Created by Mike Wang on 10/12/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import Foundation
import UIKit

func createLinedField(field: UITextField) {
    let border = CALayer()
    let width = CGFloat(0.5)
    border.borderColor = UIColor.whiteColor().CGColor
    border.frame = CGRect(x: 0, y: field.frame.size.height - width, width: field.frame.size.width, height: field.frame.size.height)
    border.borderWidth = width
    field.layer.addSublayer(border)
}

func formatLabel(label: UILabel, text: String, color: UIColor, font: UIFont?, fontName: String = UIConstants.fontRegular, fontSize: CGFloat = UIConstants.fontSmall, layout: Bool = true) {
    label.text = text
    label.textColor = color
    label.font = (font != nil ? font! : UIFont(name: fontName, size: fontSize))
    if layout {
        label.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(label.intrinsicContentSize().width)
            make.height.equalTo(label.intrinsicContentSize().height)
        }
    }
}

func formatButton(button: UIButton, title: String, color: UIColor = UIColor.whiteColor(), action: Selector?, delegate: UIViewController?) {
    button.setTitle(title, forState: .Normal)
    button.setTitleColor(color, forState: .Normal)
    if action != nil && delegate != nil {
        button.addTarget(delegate, action: action!, forControlEvents: UIControlEvents.TouchUpInside)
    }
}

func buildConnectionRequestView() {
    
}