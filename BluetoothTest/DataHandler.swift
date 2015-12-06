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
    static let acceptedCollection = "acceptedRequestsCollection"
    static let eventsCollection = "events"
    
    // Connection request
    static let connIdKey = "connIds"
    static let userId1Key = "userId1"
    static let userId2Key = "userId2"
    static let scoreKey = "score"
    static let user1StatusKey = "user1Status"
    static let user2StatusKey = "user2Status"
    static let dateKey = "date"
    static let name1Key = "name1"
    static let name2Key = "name2"
    static let title1Key = "title1"
    static let title2Key = "title2"
    static let profilePic1Key = "profile_pic1"
    static let profilePic2Key = "profile_pic2"

    // User info
    static let uidKey = "uid"
    static let nameKey = "name"
    static let titleKey = "title"
    static let emailKey = "email"
    static let phoneKey = "phone"
    static let profilePicKey = "profile_pic"
    static let coverPhotoKey = "coverPhoto"
    static let descriptionKey = "description"
    static let twitterKey = "twitter"
    static let linkedInKey = "linkedin"
    static let facebookKey = "facebook"
    static let numConnectionsKey = "numConnections"
    static let numEventsKey = "numEvents"
    static let contactsKey = "contacts"
    static let eventsKey = "events"
    
    // Event info
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
    static let acceptedRequestsRef = Firebase(url: DBConstants.serverUrl).childByAppendingPath(DBConstants.acceptedCollection)
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
        userRef.childByAppendingPath(id).observeSingleEventOfType(.Value, withBlock: completion)
    }
    
    static func updateContacts(id: String, addCompletion: (FDataSnapshot!) -> Void, removeCompletion: (FDataSnapshot!) -> Void) {
        userRef.childByAppendingPath(id).childByAppendingPath(DBConstants.contactsKey).observeEventType(.ChildAdded, withBlock: addCompletion)
        userRef.childByAppendingPath(id).childByAppendingPath(DBConstants.contactsKey).observeEventType(.ChildRemoved, withBlock: removeCompletion)
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
    // When two users connect, each of them will both submit a connection request (one will overwrite)
    // Must query for user info to get request fields so we don't have to query again in notifications later
    static func submitConnectionRequest(userId1: String, userId2: String, date: NSDate, location: String, score: Double) {
        let compareVal = userId1.compare(userId2)
        
        User.getUserInfo(userId1, completion: { (user1: User) in
            User.getUserInfo(userId2, completion: { (user2: User) in
                // Connection id is formed by appending userids in alphabetical order
                let connId = (compareVal == NSComparisonResult.OrderedAscending) ? userId1 + userId2 : userId2 + userId1
                // Set request in DB
                connectionRequestsRef.childByAppendingPath(connId).setValue([
                    DBConstants.userId1Key: userId1,    // the current user
                    DBConstants.userId2Key: userId2,    // the other user
                    DBConstants.name1Key: user1.name,
                    DBConstants.name2Key: user2.name,
                    DBConstants.title1Key: user1.title,
                    DBConstants.title2Key: user2.title,
                    DBConstants.profilePic1Key: user1.profilePic,
                    DBConstants.profilePic2Key: user2.profilePic,
                    DBConstants.scoreKey: score,        // the likelihood they talked, used for priority
                    DBConstants.user1StatusKey: 0,      // when both are 1, exchange contacts
                    DBConstants.user2StatusKey: 0,
                    DBConstants.dateKey: date.timeIntervalSince1970,          // date when connection was made
                    DBConstants.locationKey: location   // location where the connection was made
                ])
            })
        })
        
    }

    // Get all pending connection requests for a user
    static func getConnectionRequests(userId: String, completion: ([ConnectionRequest]) -> Void) {
        var numCompleted = 0
//        var connections = [ConnectionRequest]()
        
        func waitForRequests(snapshot: FDataSnapshot!) -> Void {
//            let data: [String: AnyObject]? = snapshot.value as? [String : AnyObject]
//            if data != nil {
////                print(data!.values)
//                for k in data!.keys {
//                    let connDataDict = data![k] as! [String : AnyObject]
//                    connections.append(ConnectionRequest(id: k, fromData: connDataDict))
//                }
//            }
//            print("Getting new connections")
//            completion(connections)
            
            var connections = [ConnectionRequest]()
            let data: [String: AnyObject]? = snapshot.value as? [String : AnyObject]
            if data != nil {
                for k in data!.keys {
                    let connDataDict = data![k] as! [String : AnyObject]
//                    completion(ConnectionRequest(id: snapshot.key, fromData: connDataDict))
                    connections.append(ConnectionRequest(id: k, fromData: connDataDict))
                }
            }
            completion(connections)
            
//            // Evaluate this for each new connection object
//            let connDataDict = snapshot.value as? [String : AnyObject]
//            if connDataDict != nil {
//                completion(ConnectionRequest(id: snapshot.key, fromData: connDataDict!))
//            }
            
//            numCompleted++
//            print("waiting for requests: \(numCompleted)")
//            if numCompleted >= 1 {
//                numCompleted = 0
//            }
        }
        
        // can't think of a better way to do this right now aside from storing two entries for each request
        connectionRequestsRef.queryOrderedByChild(DBConstants.userId1Key).queryEqualToValue(userId).observeEventType(.Value, withBlock: waitForRequests)
        connectionRequestsRef.queryOrderedByChild(DBConstants.userId2Key).queryEqualToValue(userId).observeEventType(.Value, withBlock: waitForRequests)
    }

    // Submit an accept connection request
    static func userAcceptedConnection(userId: String, otherUserId: String, connId: String) {
        connectionRequestsRef.childByAppendingPath(connId).observeSingleEventOfType(.Value, withBlock: { snapshot in
            let connReq = (snapshot.value as! [String: AnyObject])
            let id1 = connReq[DBConstants.userId1Key] as! String
            let id2 = connReq[DBConstants.userId2Key] as! String
            let user1Status = connReq[DBConstants.user1StatusKey] as! Int
            let user2Status = connReq[DBConstants.user2StatusKey] as! Int
            
            if userId == id1 && user2Status == 1 || userId == id2 && user1Status == 1 {
                print("accepted connection request!")
                // Both accepted the connection request, exchange contacts and remove request
                self.addContact(userId, contactId: otherUserId)
                self.addContact(otherUserId, contactId: userId)
                connectionRequestsRef.childByAppendingPath(connId).removeValue()
            } else if user1Status == -1 || user2Status == -1 {
                print("accepted but it was rejected!")
                // One user rejected and the other accepted, so remove request
                connectionRequestsRef.childByAppendingPath(connId).removeValue()
            } else {
                print("accepted but other not responded!")
                // Other use has not responded yet, set status
                // CAN GET INTO STATE WHERE BOTH ARE 1 IF THEY CLICK AT THE SAME TIME!!
                let updateKey = userId == id1 ? DBConstants.user1StatusKey : DBConstants.user2StatusKey
                connectionRequestsRef.childByAppendingPath(connId).childByAppendingPath(updateKey).setValue(1)
            }
        })
    }

    // Submit a reject connection request
    static func userRejectedConnection(userId: String, connId: String) {
        connectionRequestsRef.childByAppendingPath(connId).observeSingleEventOfType(.Value, withBlock: { snapshot in
            let connReq = (snapshot.value as! [String: AnyObject])
            let id1 = connReq[DBConstants.userId1Key] as! String
            let user1Status = connReq[DBConstants.user1StatusKey] as! Int
            let user2Status = connReq[DBConstants.user1StatusKey] as! Int

            if user1Status != 0 || user2Status != 0 {
                // Both have responded, remove the request
                connectionRequestsRef.childByAppendingPath(connId).removeValue()
            } else {
                // Other use has not responded so submit reject status
                let updateKey = userId == id1 ? DBConstants.user1StatusKey : DBConstants.user2StatusKey
                connectionRequestsRef.childByAppendingPath(connId).childByAppendingPath(updateKey).setValue(-1)
            }

        })
    }
    
    // Submit a new contact for this user
    static func addContact(userId: String, contactId: String) {
        userRef.childByAppendingPath(userId).childByAppendingPath(DBConstants.contactsKey).childByAppendingPath(contactId).setValue(1)
    }

    // Add a new attended event to this user
    static func addEventAttended(userId: String, eventId: String) {
        userRef.childByAppendingPath(userId).childByAppendingPath(DBConstants.eventsKey).childByAppendingPath(eventId).setValue(1)
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
