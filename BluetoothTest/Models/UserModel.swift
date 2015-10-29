//
//  UserModel.swift
//  BluetoothTest
//
//  Created by Mike Wang on 10/28/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import Foundation

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
    static let currentUser = User()
}