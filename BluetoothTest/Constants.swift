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

    static let spacing0 = 8
    static let spacing1 = 20
    static let spacing2 = 32

    static let topMargin = 100
    static let botMargin = -75
    static let leftMargin = 60
    static let rightMargin = -60

    static let logoHeightLarge = 50
    static let logoWidthLarge = 50

    static let fontLarge = 64
    static let fontBig = 32
    static let fontMed = 24
    static let fontSmall = 14
    static let fontTiny = 10

    static let primaryColor = UIColor(red: 51.0/255, green: 102.0/255, blue: 204.0/255, alpha: 1)
    static let errorColor = UIColor(red: 1, green: 153.0/255, blue: 153.0/255, alpha: 1)

    static let fadedColor = UIColor(white: 1, alpha: 0.5)
    
    static let mainFont = "OpenSans-Light"
}

struct StringConstants {
    static let tagline = "Stay connected."
}

class EventChosen {
    var eventSelected = ""
    var eventImage = ""
    static let events = EventChosen()
}