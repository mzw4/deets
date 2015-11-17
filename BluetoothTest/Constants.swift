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
    static let fieldWidth = 250
    static let fieldWidthSmall = 92
    static let textHeight = 20.5
    
    static let spacing0 = 8
    static let spacing1 = 20
    static let spacing2 = 32
    static let spacing3 = 64
    static let spacing4 = 128

    static let borderThin = 0.5
    static let borderThick = 1

    static let topMargin = 100
    static let botMargin = -75
    static let leftMargin = 60
    static let rightMargin = -60

    static let logoHeightLarge = 50
    static let logoWidthLarge = 50

    static let profilePictureSize = 96
    
    static let fontLarge = 64
    static let fontBig = 32
    static let fontMed = 24
    static let fontSmallish = 18
    static let fontSmall = 14
    static let fontTiny = 10

    static let primaryColor = UIColor(red: 2.0/255, green: 132.0/255, blue: 255.0/255, alpha: 1)
    static let errorColor = UIColor(red: 1, green: 153.0/255, blue: 153.0/255, alpha: 1)
    static let fadedColor = UIColor(white: 1, alpha: 0.5)
    static let veryFadedColor = UIColor(white: 1, alpha: 0.1)

    static let alphaMedFade = CGFloat(0.5)
    static let alphaHighFade = CGFloat(0.25)
    
    static let fontLight = "OpenSans-Light"
    static let fontRegular = "OpenSans-Light"
    static let systemFont = UIFont.systemFontOfSize(12).fontName
}

struct StringConstants {
    static let tagline = "Stay connected"
}

class EventChosen {
    var eventSelected = ""
    var eventImage = ""
    var eventAddress = ""
    static let events = EventChosen()
}

class PeopleMet {
    var peopleMet:[String] = []
    static let people = PeopleMet()
}

class BeaconStarted{
    var started = false
    static let beacon = BeaconStarted()
}

class ProfileChosen {
    var profileSelected = ""
    static let profiles = ProfileChosen()
}