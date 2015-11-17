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
    
    // Singleton for the current user
    static var currentUser = User()
    
    static func getUserInfo(userId: String, completion: (User) -> Void) {
        DataHandler.getUserInfo(userId, completion: { (snapshot) in
            let userInfo: [String: AnyObject] = snapshot.value as! [String : AnyObject]
            
            let user = User()
            user.userId = snapshot.key
            user.name = String(userInfo["name"]!)
            user.title = String(userInfo["title"]!)
            user.email = String(userInfo["email"]!)
            user.phone = String(userInfo["phone"]!)
            user.profilePic = String(userInfo["profile_pic"]!)
            user.coverPhoto = String(userInfo["coverPhoto"]!)
            user.description = String(userInfo["description"]!)
            
            user.twitter = String(userInfo["twitter"]!)
            user.linkedIn = String(userInfo["linkedin"]!)
            
            user.numConnections = userInfo["numConnections"] as! Int
            user.numEvents = userInfo["numEvents"] as! Int
            
            completion(user)
        })
    }
}