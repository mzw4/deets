//
//  ConnReqManager.swift
//  BluetoothTest
//
//  Created by Mike Wang on 10/28/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import Foundation
import Firebase

// Connection Request model data schema
class ConnectionRequest {
    var connId = ""
    var userId1 = ""
    var userId2 = ""
    var name1 = ""
    var name2 = ""
    var title1 = ""
    var title2 = ""
    var profilePic1 = ""
    var profilePic2 = ""
    var date: NSDate!
    var location = ""
    var score = 0.0
    var acceptedCount = 0
    
    init(id: String, fromData data: [String: AnyObject]) {
        connId = id
        userId1 = data[DBConstants.userId1Key] as! String
        userId2 = data[DBConstants.userId2Key] as! String
        date = NSDate(timeIntervalSince1970: data[DBConstants.dateKey] as! Double)
        location = data[DBConstants.locationKey] as! String
        score = data[DBConstants.scoreKey] as! Double
        acceptedCount = data[DBConstants.acceptedKey] as! Int
        name1 = data[DBConstants.name1Key] as! String
        name2 = data[DBConstants.name2Key] as! String
        title1 = data[DBConstants.title1Key] as! String
        title2 = data[DBConstants.title2Key] as! String
        profilePic1 = data[DBConstants.profilePic1Key] as! String
        profilePic2 = data[DBConstants.profilePic2Key] as! String
    }
}

// Singleton containing all currently outstanding connection requests for the current user
class ConnectionRequestManager {
    static var connectionRequests = [String : ConnectionRequest]()
    
    static func getConnectionRequests(id: String, completion: ([String : ConnectionRequest]) -> Void) {
        DataHandler.getConnectionRequests(id, completion: { connections in
            print("got connection requests \(connections.count)")
            connectionRequests = connections
            completion(connections)
        })
    }
}