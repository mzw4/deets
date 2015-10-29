//
//  EventManager.swift
//  BluetoothTest
//
//  Created by Mike Wang on 10/28/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import Foundation

// Singleton containing all relevant events loaded on the app
class EventManager {
    static var events = [Event]()
    
    static func addEvent(event: Event) {
        events.append(event)
    }
}