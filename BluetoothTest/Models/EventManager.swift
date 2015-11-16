//
//  EventManager.swift
//  BluetoothTest
//
//  Created by Mike Wang on 10/28/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import Foundation

// Event model data schema
class Event {
    var name = ""
    var location = ""
    var startDate = NSDate()
    var endDate = NSDate()
    var company = ""
    var description = ""
    var eventPhoto = ""
}

// Singleton containing all relevant events loaded on the app
class EventManager {
    static var events = [Event]()
}