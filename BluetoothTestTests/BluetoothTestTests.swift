//
//  BluetoothTestTests.swift
//  BluetoothTestTests
//
//  Created by Vivek Sudarsan on 9/10/15.
//  Copyright (c) 2015 Vivek Sudarsan. All rights reserved.
//

import UIKit
import XCTest

@testable import BluetoothTest

class BluetoothTestTests: XCTestCase {
    // Get an instance of the main view controller
    let viewController: ViewController = ViewController()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateUserCompletion(error: NSError!, result: [NSObject: AnyObject]!) {
        if error != nil {
            print("Error creating user! \(error)")
        }
    }

    // Test that we can create a user with Firebase
    func testCreateUser() {
        DataHandler.createUser("test@test.com", password: "bestpasswordever", user: User(), completion: { error, result in
            XCTAssert(error != nil)
            if error != nil {
                // There was an error creating a user
                print("Error logging in! \(error)")
            } else {
                // Created user
                print("\(result) created")
            }
        })
    }

    func testFirebaseLogin() {
        viewController.firebaseRef.authUser("test@test.com", password: "bestpasswordever",
            withCompletionBlock: { error, authData in
                XCTAssert(error == nil)
                if error != nil {
                    // There was an error logging in to this account
                    print("Error logging in! \(error)")
                } else {
                    // We are now logged in
                    let email = authData.providerData["email"]
                    print("\(authData) logged in with email \(email) and id \(authData.uid)")
                }
        })
    }

    func testAddContacts() {
        DataHandler.userRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            let userIds: [String] = Array((snapshot.value as! [String: AnyObject]).keys)

            for i in 0..<userIds.count {
                DataHandler.addContact(userIds[i], contactId: userIds[(i+2) % userIds.count])
                DataHandler.addContact(userIds[(i+2) % userIds.count], contactId: userIds[i])
            }


        })
    }

    static func testAddEvents() {
        print("adding events...")
        DataHandler.userRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            let userIds: [String] = Array((snapshot.value as! [String: AnyObject]).keys)

            DataHandler.eventsRef.observeSingleEventOfType(.Value, withBlock: { snapshot2 in
                let eventIds: [String] = Array((snapshot2.value as! [String: AnyObject]).keys)

                for u in 0..<userIds.count {
                    print("Adding events \(u)")
                    for i in u..<(u+3) {
                        DataHandler.addEventAttended(userIds[u], eventId: eventIds[i % eventIds.count])
                    }
                }
            })
        })
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
}
