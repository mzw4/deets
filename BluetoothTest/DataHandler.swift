//
//  DataHandler.swift
//  BluetoothTest
//
//  Created by Mike Wang on 10/28/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import Foundation
import Firebase

struct DBConstants {
    static let serverUrl = "https://fiery-heat-4470.firebaseio.com"
    static let usersCollection = "users"
    static let connReqCollection = "connectionRequests"
    static let eventsCollection = "events"
    
    static let userId1Key = "userId1"
    static let userId2Key = "userId2"
    static let scoreKey = "score"
    static let acceptedKey = "accepted"
    
    static let nameKey = "name"
    static let titleKey = "title"
    static let emailKey = "email"
    static let phoneKey = "phone"
    static let profilePicKey = "profilePic"
    static let coverPhotoKey = "coverPhoto"
    static let descriptionKey = "description"
    static let twitterKey = "twitter"
    static let linkedInKey = "linkedin"
    static let facebookKey = "facebook"
    
    static let companyKey = "company"
    static let locationKey = "location"
    static let startDateKey = "startDate"
    static let endDateKey = "endDate"
    static let eventPhoto = "eventPhoto"
}


class DataHandler {
    // Create a reference to a Firebase location
    static let firebaseRef = Firebase(url: DBConstants.serverUrl)
    static let userRef = Firebase(url: DBConstants.serverUrl).childByAppendingPath(DBConstants.usersCollection)
    static let connectionRequestsRef = Firebase(url: DBConstants.serverUrl).childByAppendingPath(DBConstants.connReqCollection)
    static let eventsRef = Firebase(url: DBConstants.serverUrl).childByAppendingPath(DBConstants.eventsCollection)
    
    static let dateFormatter: NSDateFormatter = NSDateFormatter()
    
    // --------------------- User functions ---------------------

    // Create a user using firebase auth and write all of the profile fields
    static func createUser(email: String, password: String, user: User,
        completion: (NSError!, [NSObject : AnyObject]!) -> Void) {
            firebaseRef.createUser(email, password: password, withValueCompletionBlock: { error, result in
                let uid = result["uid"] as? String
                userRef.childByAppendingPath(uid).setValue([
                    DBConstants.nameKey: user.name,
                    DBConstants.titleKey: user.title,
                    DBConstants.emailKey: user.email,
                    DBConstants.phoneKey: user.phone,
                    DBConstants.profilePicKey: user.profilePic,
                    DBConstants.coverPhotoKey: user.coverPhoto,
                    DBConstants.descriptionKey: user.description,
                    DBConstants.twitterKey: user.twitter,
                    DBConstants.linkedInKey: user.linkedIn,
                    DBConstants.facebookKey: user.facebook,
                ])
            })
    }

    // Authenticate the user
    static func loginUser(email: String, password: String, completion: (NSError!, FAuthData!) -> Void) {
        firebaseRef.authUser(email, password: password, withCompletionBlock: completion)
    }
    
    // Read user data for one user
    static func getUserInfo(id: String, completion: (FDataSnapshot!) -> Void) {
        userRef.childByAppendingPath(id).observeEventType(.Value, withBlock: completion)
    }

    // Write user data to the database for one field
    static func writeUserInfo(id: String, key: String, value: String) {
        userRef.childByAppendingPath(id).updateChildValues([key: value])
    }

    // Write user data to the database
    static func writeUserInfo(id: String, vals: [String: String]) {
        userRef.childByAppendingPath(id).updateChildValues(vals)
    }

    // --------------------- Connection Request functions ---------------------

    // Create a connection request between two users
    static func submitConnectionRequest(userId1: String, userId2: String, score: Double) {
        connectionRequestsRef.childByAutoId().setValue([
            DBConstants.userId1Key: userId1,
            DBConstants.userId2Key: userId2,
            DBConstants.scoreKey: score, // the likelihood they taked, used for priority
            DBConstants.acceptedKey: 0   // when the count is 2, exchange contacts
        ])
    }

    // Get all pending connection requests for a user
    static func getConnectionRequests(userId: String, completion: (FDataSnapshot!) -> Void) {
        // can't think of a better way to do this right now aside from storing two entries for each request
        // but then we would have to update accepted for both each time as well
        
        // May be slightly buggy since
        connectionRequestsRef.queryOrderedByChild(DBConstants.userId1Key).queryEqualToValue(userId)
            .observeEventType(.ChildAdded, withBlock: completion)
        connectionRequestsRef.queryOrderedByChild(DBConstants.userId2Key).queryEqualToValue(userId)
            .observeEventType(.ChildAdded, withBlock: completion)
    }

    // Submit an accept connection request
    static func userAcceptedConnection(userId: String, connId: String, block: (FMutableData!) -> FTransactionResult) {
        connectionRequestsRef.childByAppendingPath(connId).runTransactionBlock({ currentData in
            let requestData = currentData.value as! [String: String]
            let userId1 = requestData[DBConstants.userId1Key]!
            let userId2 = requestData[DBConstants.userId2Key]!
            let score = requestData[DBConstants.scoreKey]!
            let acceptedCount = requestData[DBConstants.acceptedKey]!

            // Increment accepted count
            let acceptResult = Int(acceptedCount)! + 1
            
            // If they've both accepted the connection request, exchange contacts
            if acceptResult == 2 {
                let otherUserId = (userId == userId1) ? userId2 : userId1
                
                self.addContact(userId, contactId: otherUserId)
                self.addContact(otherUserId, contactId: userId)
            }
            
            let result = FMutableData()
            result.value = [
                DBConstants.userId1Key: userId1,
                DBConstants.userId2Key: userId2,
                DBConstants.scoreKey: score, // the likelihood they taked, used for priority
                DBConstants.acceptedKey: 0   // when the count is 2, exchange contacts
            ]
            return FTransactionResult.successWithValue(result)
        })
    }

    static func addContact(userId: String, contactId: String) {
        print("adding contact!")
    }

    // Submit a reject connection request
    static func userRejectedConnection(userId: String, connId: String) {
        connectionRequestsRef.childByAppendingPath(connId).removeValue()
    }

    // --------------------- Event functions ---------------------

    // Create event, return the id
    static func createEvent(name: String, location: String, startDate: NSDate, endDate: NSDate,
        company: String, description: String, eventPhoto: String) -> String {
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        let event = eventsRef.childByAutoId()
        event.setValue([
            DBConstants.nameKey: name,
            DBConstants.locationKey: location,
            DBConstants.startDateKey: startDate.timeIntervalSince1970,
            DBConstants.endDateKey: endDate.timeIntervalSince1970,
            DBConstants.companyKey: company,
            DBConstants.descriptionKey: description,
            DBConstants.eventPhoto: eventPhoto,
        ])
        return event.key
    }

    static func getAllEvents(completion: (FDataSnapshot!) -> Void) {
        eventsRef.queryOrderedByChild(DBConstants.startDateKey).observeEventType(.ChildAdded, withBlock: completion)
    }

    static func getEventById(eventId: String, completion: (FDataSnapshot!) -> Void) {
        eventsRef.childByAppendingPath(eventId).observeEventType(.Value, withBlock: completion)
    }
}
