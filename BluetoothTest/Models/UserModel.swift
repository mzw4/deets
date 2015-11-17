//
//  UserModel.swift
//  BluetoothTest
//
//  Created by Mike Wang on 10/28/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import Foundation
import Firebase

// User model data schema
class User {
    var userId = ""
    var name = ""
    var title = ""
    var email = ""
    var phone = ""
    var profilePic = ""
    var coverPhoto = ""
    var description = ""
    var twitter = ""
    var linkedIn = ""
    var facebook = ""
    var numConnections = 0
    var numEvents = 0
    var events = [String]() // list of event ids
    var notes = ""
    
    init() {}
    
    init(id: String, fromData data: [String : AnyObject]) {
        userId = id
        name = String(data[DBConstants.nameKey]!)
        title = String(data[DBConstants.titleKey]!)
        email = String(data[DBConstants.emailKey]!)
        phone = String(data[DBConstants.phoneKey]!)
        profilePic = String(data[DBConstants.profilePicKey]!)
        coverPhoto = String(data[DBConstants.coverPhotoKey]!)
        description = String(data[DBConstants.descriptionKey]!)
        
        twitter = String(data[DBConstants.twitterKey]!)
        linkedIn = String(data[DBConstants.linkedInKey]!)
        
        numConnections = data[DBConstants.numConnectionsKey] as! Int
        numEvents = data[DBConstants.numEventsKey] as! Int
    }
    
    // Singleton for the current user
    static var currentUser = User()
    
    static func getUserInfo(userId: String, completion: (User) -> Void) {
        DataHandler.getUserInfo(userId, completion: { (snapshot) in
            let userInfo: [String: AnyObject] = snapshot.value as! [String : AnyObject]
            
            let user = User(id: snapshot.key, fromData: userInfo)
            completion(user)
        })
    }
}