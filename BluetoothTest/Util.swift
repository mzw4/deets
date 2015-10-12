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