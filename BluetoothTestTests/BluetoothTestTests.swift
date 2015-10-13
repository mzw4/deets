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
//        XCTAssert(error == nil)
        if error != nil {
            print("Error creating user! \(error)")
        }
    }
    
    // Test that we can create a user with Firebase
    func testCreateUser() {
        viewController.createUser("test@test.com", password: "bestpasswordever", completion: testCreateUserCompletion)
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
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
