//
//  Constants.swift
//  BluetoothTest
//
//  Created by Mike Wang on 10/12/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import Foundation
import UIKit

struct UIConstants {
    static let fieldHeight = 12
    static let fieldWidth = 200
    static let fieldWidthSmall = 92
    static let textHeight = 20.5
    
    static let spacing0 = 8
    static let spacing1 = 20
    static let spacing2 = 32
    static let spacing3 = 64
    static let spacing4 = 128

    static let borderThin = CGFloat(0.5)
    static let borderThick = CGFloat(1)

    static let topMargin = 100
    static let botMargin = -75
    static let leftMargin = 60
    static let rightMargin = -60

    static let logoHeightLarge = 50
    static let logoWidthLarge = 50

    static let profilePictureSize = 96
    static let profilePictureSizeSmall = 64
    
    static let buttonCircleSize = CGFloat(32)

    static let fontLarge = CGFloat(64)
    static let fontBig = CGFloat(32)
    static let fontMed = CGFloat(24)
    static let fontSmallish = CGFloat(18)
    static let fontSmall = CGFloat(14)
    static let fontTiny = CGFloat(10)

    static let primaryColor = UIColor(red: 51.0/255, green: 102.0/255, blue: 204.0/255, alpha: 1)
    static let errorColor = UIColor(red: 1, green: 153.0/255, blue: 153.0/255, alpha: 1)
    static let fadedColor = UIColor(white: 1, alpha: 0.5)
    static let veryFadedColor = UIColor(white: 1, alpha: 0.1)
    static let defaultTextColor = UIColor.whiteColor()
    static let successColor = UIColor(red: 71.0/250, green: 218.0/255, blue: 145.0/255, alpha: 1)
    
    static let alphaMedFade = CGFloat(0.5)
    static let alphaHighFade = CGFloat(0.25)
    
    static let fontLight = "OpenSans-Light"
    static let fontRegular = "OpenSans-Light"
    static let systemFont = UIFont.systemFontOfSize(12).fontName
}

struct StringConstants {
    static let tagline = "Stay connected."
}

class EventChosen {
    var eventSelected = ""
    var eventImage = ""
    static let events = EventChosen()
}