//
//  ConnReqManager.swift
//  BluetoothTest
//
//  Created by Mike Wang on 10/28/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import Foundation

// Connection Request model data schema
class ConnectionRequest {
    var userId1 = ""
    var userId2 = ""
    var score = 0.0
    var acceptedCount = 0
}

// Singleton containing all currently outstanding connection requests for the current user
class ConnectionRequestManager {
    static var connectionRequests = [ConnectionRequest]()
}